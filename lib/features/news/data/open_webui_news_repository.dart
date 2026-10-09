import 'package:dio/dio.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/error_mapper.dart';
import '../domain/news_item.dart';

/// Company news from Open WebUI, newest first:
/// - admin banners (`GET /api/v1/configs/banners`), shown to everyone;
/// - notes shared with the user (`GET /api/v1/notes/`, `/{id}`): HR writes a
///   note and grants read access to a group. The user's own notes are not
///   news.
///
/// Notes need the `features.notes` permission, and without it the server
/// answers 401, which would end the session. Pass [enabled] = false then:
/// only banners are read.
class OpenWebUiNewsRepository implements NewsRepository {
  OpenWebUiNewsRepository({
    required this._dio,
    required String baseUrl,
    required this.selfId,
    required this.enabled,
  }) : _baseUrl = baseUrl.endsWith('/')
           ? baseUrl.substring(0, baseUrl.length - 1)
           : baseUrl;

  final Dio _dio;
  final String _baseUrl;

  /// The signed-in user; their own notes are skipped.
  final String selfId;
  final bool enabled;

  static const _summaryLength = 160;

  static const _bannerPrefix = 'banner:';

  @override
  Future<List<NewsItem>> getNews() async {
    final (banners, notes) = await (_banners(), _notes()).wait;
    return [...banners, ...notes]
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  Future<List<NewsItem>> _notes() async {
    if (!enabled) return const [];
    final body = await _get('/api/v1/notes/', {'page': 1});
    if (body is! List) {
      throw const UnknownFailure('Malformed /api/v1/notes/ response');
    }
    return [
      for (final note in body.whereType<Map<String, dynamic>>())
        if (_authorId(note) != selfId) ?_itemOf(note),
    ];
  }

  /// `[{"id", "type", "title"?, "content" (markdown), "timestamp"}]`.
  Future<List<NewsItem>> _banners() async {
    final body = await _get('/api/v1/configs/banners');
    if (body is! List) return const [];
    return [
      for (final banner in body.whereType<Map<String, dynamic>>())
        if (banner['id']?.toString() case final id? when id.isNotEmpty)
          _bannerOf(id, banner),
    ];
  }

  NewsItem _bannerOf(String id, Map<String, dynamic> banner) {
    final markdown = banner['content']?.toString().trim() ?? '';
    final title = banner['title']?.toString().trim() ?? '';
    return NewsItem(
      id: '$_bannerPrefix$id',
      title: title.isEmpty ? _firstLine(markdown) : title,
      summary: _summaryOf(markdown),
      content: markdown,
      publishedAt: _fromEpoch(banner['timestamp']),
    );
  }

  @override
  Future<NewsItem> getNewsDetail(String id) async {
    if (id.startsWith(_bannerPrefix)) {
      final banners = await _banners();
      return banners.firstWhere(
        (b) => b.id == id,
        orElse: () => throw const NotFoundFailure('Article not found'),
      );
    }
    if (!enabled) throw const ForbiddenFailure('Notes are disabled');
    final body = await _get('/api/v1/notes/${Uri.encodeComponent(id)}');
    final item = body is Map<String, dynamic> ? _itemOf(body) : null;
    if (item == null) throw const NotFoundFailure('Article not found');
    return item;
  }

  static String? _authorId(Map<String, dynamic> note) =>
      (note['user'] as Map?)?['id']?.toString() ?? note['user_id']?.toString();

  /// `{"id", "title", "data": {"content": {"md"}}, "created_at" (ns),
  /// "user": {"name"}}`; lists cut `md` to 1000 characters.
  NewsItem? _itemOf(Map<String, dynamic> note) {
    final id = note['id']?.toString();
    if (id == null || id.isEmpty) return null;
    final markdown = switch (note['data']) {
      {'content': {'md': final String md}} => md.trim(),
      _ => '',
    };
    final title = note['title']?.toString().trim() ?? '';
    return NewsItem(
      id: id,
      title: title.isEmpty ? _firstLine(markdown) : title,
      summary: _summaryOf(markdown),
      content: markdown,
      publishedAt: _fromEpoch(note['created_at']),
      byline: (note['user'] as Map?)?['name']?.toString(),
    );
  }

  static String _firstLine(String markdown) =>
      _plain(markdown)
          .split('\n')
          .firstWhere((line) => line.trim().isNotEmpty, orElse: () => '');

  static String _summaryOf(String markdown) {
    final text = _plain(markdown).replaceAll(RegExp(r'\s+'), ' ').trim();
    return text.length <= _summaryLength
        ? text
        : '${text.substring(0, _summaryLength - 1)}…';
  }

  /// Drops the common markdown marks for one-line previews.
  static String _plain(String markdown) => markdown
      .replaceAll(RegExp(r'!\[[^\]]*\]\([^)]*\)'), '')
      .replaceAllMapped(RegExp(r'\[([^\]]*)\]\([^)]*\)'), (m) => m[1]!)
      .replaceAll(
        RegExp(r'^\s{0,3}(#{1,6}|>|[-*+]|\d+\.)\s+', multiLine: true),
        '',
      )
      .replaceAll(RegExp(r'[*_`~]'), '');

  /// Notes store nanoseconds; other resources seconds.
  static DateTime _fromEpoch(Object? value) {
    if (value is! num) return DateTime.fromMillisecondsSinceEpoch(0);
    final micros = value > 1e17
        ? value / 1000
        : value > 1e14
        ? value
        : value > 1e11
        ? value * 1000
        : value * 1000000;
    return DateTime.fromMicrosecondsSinceEpoch(micros.round());
  }

  Future<Object?> _get(String path, [Map<String, Object?>? query]) async {
    try {
      final response = await _dio.get<Object?>(
        '$_baseUrl$path',
        queryParameters: query,
      );
      return response.data;
    } on DioException catch (e) {
      throw ErrorMapper.fromDio(e);
    }
  }
}
