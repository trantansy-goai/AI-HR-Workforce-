import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/error_mapper.dart';
import '../domain/speech_synthesizer.dart';

/// Open WebUI text-to-speech (`POST /api/v1/audio/speech`, `{"input"}` →
/// audio/mpeg) with the voice and engine the admin configured. Each text is
/// fetched once and kept in [cacheDirectory].
class OpenWebUiSpeechSynthesizer implements SpeechSynthesizer {
  OpenWebUiSpeechSynthesizer({
    required this._dio,
    required String baseUrl,
    required this.cacheDirectory,
  }) : _baseUrl = baseUrl.endsWith('/')
           ? baseUrl.substring(0, baseUrl.length - 1)
           : baseUrl;

  final Dio _dio;
  final String _baseUrl;
  final Future<Directory> Function() cacheDirectory;

  @override
  Future<String> synthesize(String text) async {
    final input = text.trim();
    if (input.isEmpty) {
      throw const ValidationFailure(message: 'Nothing to read');
    }
    final root = await cacheDirectory();
    final file = File('${root.path}/speech/${_keyOf(input)}.mp3');
    if (await file.exists() && await file.length() > 0) return file.path;
    final Response<List<int>> response;
    try {
      response = await _dio.post<List<int>>(
        '$_baseUrl/api/v1/audio/speech',
        data: {'input': input},
        options: Options(responseType: ResponseType.bytes),
      );
    } on DioException catch (e) {
      throw ErrorMapper.fromDio(e);
    }
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw const UnknownFailure('Empty speech response');
    }
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  /// Stable file name for a text (FNV-1a over its UTF-8 bytes).
  static String _keyOf(String text) {
    var hash = 0xcbf29ce484222325;
    for (final byte in utf8.encode(text)) {
      hash = (hash ^ byte) * 0x100000001b3; // Wraps at 64 bits.
    }
    return hash.toUnsigned(64).toRadixString(16);
  }
}
