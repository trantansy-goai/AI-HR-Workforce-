import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/extensions/ai_extensions.dart';

/// A server chat as listed by `GET /api/v1/chats/`.
class OpenWebUiChatSummary {
  const OpenWebUiChatSummary({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.modelId,
  });

  final String id;
  final String title;
  final DateTime updatedAt;

  /// Model that answered last, when known (see [OpenWebUiChatsApi.listChats]).
  final String? modelId;
}

/// A server chat with its current branch of messages, oldest first.
class OpenWebUiChat {
  const OpenWebUiChat({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.messages,
    this.modelId,
  });

  final String id;
  final String title;
  final DateTime updatedAt;
  final String? modelId;

  /// Raw Open WebUI message maps (`id`, `parentId`, `role`, `content`,
  /// `timestamp`, `model`, `files`, `sources`, ...).
  final List<Map<String, dynamic>> messages;
}

/// Open WebUI chat history (`/api/v1/chats/*`), the store the website uses.
///
/// Chats are JSON documents: `chat.history.messages` is a tree keyed by
/// message id (`parentId`/`childrenIds`), `chat.history.currentId` the leaf
/// of the shown branch. `POST /api/v1/chats/{id}` merges `history` with what
/// is stored, so callers send only new or changed messages.
class OpenWebUiChatsApi {
  OpenWebUiChatsApi({required this._dio, required String baseUrl})
    : _baseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

  final Dio _dio;
  final String _baseUrl;

  /// Server page size of `GET /api/v1/chats/?page=`.
  static const pageSize = 60;

  /// Newest chats first, including pinned chats and chats in folders.
  ///
  /// The list has no model ids, so they are joined best effort from
  /// `GET /api/v1/chats/stats/usage` (same user, same order).
  Future<List<OpenWebUiChatSummary>> listChats({int page = 1}) async {
    // Requested together; the stats call never throws.
    final models = _modelsByChat(page);
    final list = await _get('/api/v1/chats/', {
      'page': page,
      'include_pinned': true,
      'include_folders': true,
    });
    final modelIds = await models;
    if (list is! List) {
      throw const UnknownFailure('Malformed /api/v1/chats/ response');
    }
    return [
      for (final item in list.whereType<Map<String, dynamic>>())
        if (item['id']?.toString() case final id? when id.isNotEmpty)
          OpenWebUiChatSummary(
            id: id,
            title: _title(item['title']),
            updatedAt: _fromEpochSeconds(item['updated_at']),
            modelId: modelIds[id],
          ),
    ];
  }

  Future<Map<String, String>> _modelsByChat(int page) async {
    try {
      final body = await _get('/api/v1/chats/stats/usage', {
        'items_per_page': pageSize,
        'page': page,
      });
      final items = body is Map ? body['items'] : null;
      return {
        if (items is List)
          for (final item in items.whereType<Map<String, dynamic>>())
            if ((item['id'], _topModel(item['models'])) case (
              final String id,
              final String model,
            ))
              id: model,
      };
    } on Object {
      return const {}; // Model ids only filter lists; never block them.
    }
  }

  /// The model with most answers in the chat's current branch.
  static String? _topModel(Object? counts) {
    if (counts is! Map || counts.isEmpty) return null;
    final entries = counts.entries.where((e) => e.value is num).toList()
      ..sort((a, b) => (b.value as num).compareTo(a.value as num));
    return entries.firstOrNull?.key.toString();
  }

  /// `GET /api/v1/chats/{id}`; messages follow `history.currentId` up to
  /// the root, like the website shows them.
  Future<OpenWebUiChat> getChat(String id) async {
    final body = await _get('/api/v1/chats/${Uri.encodeComponent(id)}');
    if (body is! Map<String, dynamic>) {
      throw const UnknownFailure('Malformed chat response');
    }
    final chat = body['chat'] is Map<String, dynamic>
        ? body['chat'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final messages = currentBranch(chat);
    return OpenWebUiChat(
      id: body['id']?.toString() ?? id,
      title: _title(body['title'] ?? chat['title']),
      updatedAt: _fromEpochSeconds(body['updated_at']),
      messages: messages,
      modelId: switch (chat['models']) {
        [final String first, ...] when first.isNotEmpty => first,
        _ =>
          messages.reversed
              .map((m) => m['model'])
              .whereType<String>()
              .firstOrNull,
      },
    );
  }

  /// `POST /api/v1/chats/new`; returns the new chat id.
  Future<String> createChat(Map<String, Object?> chat) async {
    final body = await _post('/api/v1/chats/new', {'chat': chat});
    final id = body is Map ? body['id']?.toString() : null;
    if (id == null || id.isEmpty) {
      throw const UnknownFailure('Create chat response has no id');
    }
    return id;
  }

  /// `POST /api/v1/chats/{id}`: patches top-level keys of the chat document
  /// and merges `history.messages` by id.
  Future<void> updateChat(String id, Map<String, Object?> chat) =>
      _post('/api/v1/chats/${Uri.encodeComponent(id)}', {'chat': chat});

  /// A short title for a chat from the server's task model
  /// (`POST /api/v1/tasks/title/completions`), as the website names chats.
  /// Null when the admin disabled title generation or the reply has none.
  Future<String?> generateTitle({
    required String chatId,
    required String modelId,
    required List<Map<String, Object?>> messages,
  }) async {
    final body = await _post('/api/v1/tasks/title/completions', {
      'model': modelId,
      'chat_id': chatId,
      'messages': messages,
    });
    final content = switch (body) {
      {'choices': [{'message': {'content': final String text}}, ...]} => text,
      _ => null, // e.g. {"detail": "Title generation is disabled"}
    };
    if (content == null) return null;
    // Usually {"title": "..."}, sometimes wrapped in prose or single quotes.
    final match = RegExp(
      r'''["'‘’`]title["'‘’`]\s*:\s*["'‘’`](.+?)["'‘’`]\s*}''',
      dotAll: true,
    ).firstMatch(content);
    final title = (match?[1] ?? content).trim();
    if (title.isEmpty || title.startsWith('{') || title.length > 120) {
      return null;
    }
    return title;
  }

  /// Shared prompt templates the user may use (`GET /api/v1/prompts/list`).
  /// Templates with `{{variables}}` need a form, so they are left out.
  Future<List<PromptSuggestion>> listPrompts() async {
    final body = await _get('/api/v1/prompts/list', {'page': 1});
    final items = body is Map ? body['items'] : null;
    if (items is! List) return const [];
    return [
      for (final p in items.whereType<Map<String, dynamic>>())
        if (p['is_active'] != false &&
            p['content'] is String &&
            (p['content'] as String).trim().isNotEmpty &&
            !(p['content'] as String).contains('{{'))
          PromptSuggestion(
            label: (p['name'] ?? p['command'] ?? p['content'])
                .toString()
                .trim(),
            text: (p['content'] as String).trim(),
          ),
    ];
  }

  /// Download URL of an uploaded file (needs the bearer token).
  String fileContentUrl(String fileId) =>
      '$_baseUrl/api/v1/files/${Uri.encodeComponent(fileId)}/content';

  /// Messages from the root to `history.currentId`, oldest first. Falls back
  /// to the legacy flat `messages` list.
  static List<Map<String, dynamic>> currentBranch(Map<String, dynamic> chat) {
    if (chat['history']
        case {
          'messages': final Map<String, dynamic> all,
          'currentId': final Object? currentId,
        }
        when all.isNotEmpty) {
      final branch = <Map<String, dynamic>>[];
      final seen = <Object?>{};
      var id = currentId;
      while (id != null && seen.add(id) && all[id] is Map<String, dynamic>) {
        final message = all[id] as Map<String, dynamic>;
        branch.add(message);
        id = message['parentId'];
      }
      return branch.reversed.toList();
    }
    final flat = chat['messages'];
    return flat is List
        ? flat.whereType<Map<String, dynamic>>().toList()
        : const [];
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

  Future<Object?> _post(String path, Map<String, Object?> data) async {
    try {
      final response = await _dio.post<Object?>('$_baseUrl$path', data: data);
      return response.data;
    } on DioException catch (e) {
      throw ErrorMapper.fromDio(e);
    }
  }

  static String _title(Object? value) {
    final title = value?.toString().trim() ?? '';
    return title.isEmpty ? 'New Chat' : title;
  }

  static DateTime _fromEpochSeconds(Object? value) => value is num
      ? DateTime.fromMillisecondsSinceEpoch((value * 1000).round())
      : DateTime.fromMillisecondsSinceEpoch(0);
}
