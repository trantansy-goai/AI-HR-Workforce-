import 'package:dio/dio.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/error_mapper.dart';
import '../domain/attachment.dart';
import '../domain/file_services.dart';

/// Uploads attachments to Open WebUI (`POST /api/v1/files/`) and waits until
/// the server has extracted/embedded them
/// (`GET /api/v1/files/{id}/process/status` → `completed`), so the next chat
/// request can reference them for RAG.
///
/// Returns a [RemoteAttachmentSource] whose `storageKey` is the Open WebUI
/// file id. Use the authenticated Dio client (JWT + 401 handling).
class OpenWebUiFileUploader implements FileUploader {
  OpenWebUiFileUploader({
    required this._dio,
    required String baseUrl,
    this.pollInterval = const Duration(seconds: 1),
    this.processingTimeout = const Duration(minutes: 2),
  }) : _baseUrl = baseUrl.endsWith('/')
           ? baseUrl.substring(0, baseUrl.length - 1)
           : baseUrl;

  final Dio _dio;
  final String _baseUrl;
  final Duration pollInterval;
  final Duration processingTimeout;

  /// Upload is the first 90% of the reported progress; processing the rest.
  static const _uploadShare = 0.9;

  @override
  Future<RemoteAttachmentSource> upload(
    Attachment attachment, {
    void Function(double progress)? onProgress,
  }) async {
    final path = switch (attachment.source) {
      LocalAttachmentSource(:final path) => path,
      final other => throw UnknownFailure('Cannot upload ${other.runtimeType}'),
    };

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/api/v1/files/',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(
            path,
            filename: attachment.name,
            contentType: DioMediaType.parse(attachment.mimeType),
          ),
        }),
        onSendProgress: (sent, total) {
          if (total > 0) onProgress?.call(sent / total * _uploadShare);
        },
      );
      final id = response.data?['id']?.toString();
      if (id == null || id.isEmpty) {
        throw const UnknownFailure('Upload response has no file id');
      }

      await _waitUntilProcessed(id);
      onProgress?.call(1);
      return RemoteAttachmentSource(
        url: '$_baseUrl/api/v1/files/$id/content',
        storageKey: id,
      );
    } on DioException catch (e) {
      throw ErrorMapper.fromDio(e);
    }
  }

  Future<void> _waitUntilProcessed(String id) async {
    final deadline = DateTime.now().add(processingTimeout);
    while (true) {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/api/v1/files/$id/process/status',
      );
      switch (response.data?['status']) {
        case 'completed':
          return;
        case 'failed':
          throw ServerFailure(
            message:
                'File processing failed: ${response.data?['error'] ?? 'unknown'}',
          );
        case 'not_found':
          throw const NotFoundFailure('Uploaded file disappeared');
      }
      if (DateTime.now().isAfter(deadline)) {
        throw const NetworkFailure(
          reason: NetworkFailureReason.timeout,
          message: 'File processing timed out',
        );
      }
      await Future<void>.delayed(pollInterval);
    }
  }
}
