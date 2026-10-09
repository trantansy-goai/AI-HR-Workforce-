import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/error_mapper.dart';
import '../../file/domain/mime_types.dart';
import '../domain/document_item.dart';

/// Documents from Open WebUI knowledge bases: every file of every knowledge
/// base the user may read (`GET /api/v1/knowledge/` → `/{id}/files`). These
/// are the same documents the HR agents answer from.
///
/// Download needs the bearer token, so [download] saves the file through the
/// authenticated Dio instead of handing the URL to another app.
class OpenWebUiDocumentRepository implements DocumentRepository {
  OpenWebUiDocumentRepository({
    required this._dio,
    required String baseUrl,
    required this._downloadDirectory,
    this.maxPages = 10,
  }) : _baseUrl = baseUrl.endsWith('/')
           ? baseUrl.substring(0, baseUrl.length - 1)
           : baseUrl;

  final Dio _dio;
  final String _baseUrl;
  final Future<Directory> Function() _downloadDirectory;

  /// Upper bound of pages read per list (the server pages by 30).
  final int maxPages;

  /// Last list, so details keep the knowledge base name.
  final Map<String, DocumentItem> _known = {};

  @override
  Future<List<DocumentItem>> getDocuments() async {
    final bases = await _pages('/api/v1/knowledge/');
    final perBase = await Future.wait([
      for (final base in bases)
        if (base['id'] case final String id when id.isNotEmpty)
          _pages('/api/v1/knowledge/${Uri.encodeComponent(id)}/files')
              .then((files) => (base, files)),
    ]);

    final documents = <String, DocumentItem>{};
    for (final (base, files) in perBase) {
      final source = base['name']?.toString() ?? '';
      for (final file in files) {
        final item = _itemOf(file, source: source);
        if (item != null) documents.putIfAbsent(item.id, () => item);
      }
    }
    final sorted = documents.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _known
      ..clear()
      ..addEntries(sorted.map((d) => MapEntry(d.id, d)));
    return sorted;
  }

  @override
  Future<DocumentItem> getDocumentDetail(String id) async {
    if (_known[id] case final known?) return known;
    final body = await _get('/api/v1/files/${Uri.encodeComponent(id)}');
    final item = body is Map<String, dynamic> ? _itemOf(body) : null;
    if (item == null) throw const NotFoundFailure('Document not found');
    return item;
  }

  @override
  Future<String> download(DocumentItem document) async {
    final directory = await _downloadDirectory();
    // Keep the original name; the id folder avoids clashes between files.
    final folder = Directory('${directory.path}/documents/${document.id}');
    await folder.create(recursive: true);
    final path = '${folder.path}/${_safeName(document.title)}';
    try {
      await _dio.download(document.downloadUrl, path);
    } on DioException catch (e) {
      throw ErrorMapper.fromDio(e);
    }
    return path;
  }

  /// `{"items": [...], "total": n}` pages, read until [maxPages].
  Future<List<Map<String, dynamic>>> _pages(String path) async {
    final items = <Map<String, dynamic>>[];
    for (var page = 1; page <= maxPages; page++) {
      final body = await _get(path, {'page': page});
      final list = body is Map ? body['items'] : null;
      if (list is! List) {
        throw UnknownFailure('Malformed $path response');
      }
      items.addAll(list.whereType<Map<String, dynamic>>());
      final total = body is Map ? body['total'] : null;
      if (list.isEmpty || total is! num || items.length >= total) break;
    }
    return items;
  }

  /// A file entry: `{"id", "filename", "meta": {"name", "content_type",
  /// "size"}, "created_at"}`.
  DocumentItem? _itemOf(Map<String, dynamic> file, {String source = ''}) {
    final id = file['id']?.toString();
    if (id == null || id.isEmpty) return null;
    final meta = file['meta'] is Map
        ? file['meta'] as Map
        : const <String, Object?>{};
    final name = (meta['name'] ?? file['filename'] ?? id).toString();
    final dot = name.lastIndexOf('.');
    final size = meta['size'];
    return DocumentItem(
      id: id,
      title: name,
      description: source,
      fileType: dot > 0 && dot < name.length - 1
          ? name.substring(dot + 1).toUpperCase()
          : 'FILE',
      fileSizeFormatted: size is num ? MimeTypes.formatBytes(size.toInt()) : '',
      downloadUrl: '$_baseUrl/api/v1/files/${Uri.encodeComponent(id)}/content',
      createdAt: switch (file['created_at']) {
        final num seconds => DateTime.fromMillisecondsSinceEpoch(
          (seconds * 1000).round(),
        ),
        _ => DateTime.fromMillisecondsSinceEpoch(0),
      },
    );
  }

  static String _safeName(String name) {
    final cleaned = name.replaceAll(RegExp(r'[/\\:*?"<>|]'), '_').trim();
    return cleaned.isEmpty ? 'document' : cleaned;
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
