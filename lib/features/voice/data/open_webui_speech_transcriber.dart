import 'package:dio/dio.dart';

import '../../../core/error/error_mapper.dart';
import '../domain/speech_transcriber.dart';

/// Open WebUI speech-to-text (`POST /api/v1/audio/transcriptions`, multipart
/// `file` + optional `language` → `{"text": "..."}`), with the engine the
/// server is configured for.
class OpenWebUiSpeechTranscriber implements SpeechTranscriber {
  OpenWebUiSpeechTranscriber({required this._dio, required String baseUrl})
    : _baseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

  final Dio _dio;
  final String _baseUrl;

  @override
  Future<String> transcribe(
    String path, {
    required String mimeType,
    String? language,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/api/v1/audio/transcriptions',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
            contentType: DioMediaType.parse(mimeType),
          ),
          'language': ?language,
        }),
      );
      return response.data?['text']?.toString().trim() ?? '';
    } on DioException catch (e) {
      throw ErrorMapper.fromDio(e);
    }
  }
}
