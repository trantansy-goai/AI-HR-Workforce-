// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/ai/text_generation.dart';
import '../../domain/extensions/ai_extensions.dart';
import 'open_webui_sse_parser.dart';

/// Production client adapter for Open WebUI AI & Model APIs.
class OpenWebUiClient implements RemoteAiClient {
  OpenWebUiClient({
    required Dio dio,
    required String openWebUiBaseUrl,
    String apiKey = '',
    ModelInfo? initialModel,
    OpenWebUiSseParser sseParser = const OpenWebUiSseParser(),
  })  : _dio = dio,
        _baseUrl = openWebUiBaseUrl.endsWith('/')
            ? openWebUiBaseUrl.substring(0, openWebUiBaseUrl.length - 1)
            : openWebUiBaseUrl,
        _apiKey = apiKey,
        _sseParser = sseParser,
        _currentModel = initialModel ??
            const ModelInfo(
              id: 'open-webui-default',
              displayName: 'Open WebUI Model',
            );

  final Dio _dio;
  final String _baseUrl;
  final String _apiKey;
  final OpenWebUiSseParser _sseParser;

  ModelInfo _currentModel;
  CancelToken? _activeCancelToken;

  @override
  ModelInfo get model => _currentModel;

  /// Updates the active model target for generation calls.
  void setModel(ModelInfo newModel) {
    _currentModel = newModel;
  }

  /// Fetches available models from Open WebUI (`GET /api/models`).
  Future<List<ModelInfo>> fetchModels() async {
    final url = '$_baseUrl/api/models';
    final options = Options(
      headers: {
        if (_apiKey.isNotEmpty) 'Authorization': 'Bearer $_apiKey',
      },
    );

    try {
      final response = await _dio.get<dynamic>(url, options: options);
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'];
        if (list is List) {
          final models = <ModelInfo>[];
          for (final item in list) {
            if (item is Map<String, dynamic>) {
              final id = item['id']?.toString() ?? '';
              final name = item['name']?.toString() ?? id;
              if (id.isNotEmpty) {
                models.add(ModelInfo(
                  id: id,
                  displayName: name,
                  contextWindow: item['context_length'] as int?,
                ));
              }
            }
          }
          if (models.isNotEmpty) {
            return models;
          }
        }
      }
    } catch (_) {
      // Return default model fallback if backend API is not live
    }

    return [_currentModel];
  }

  @override
  Stream<AiStreamChunk> generate(GenerationRequest request) async* {
    await cancel(); // Cancel any existing generation in flight
    _activeCancelToken = CancelToken();

    final url = '$_baseUrl/api/chat/completions';
    final options = Options(
      headers: {
        'Content-Type': 'application/json',
        if (_apiKey.isNotEmpty) 'Authorization': 'Bearer $_apiKey',
      },
      responseType: ResponseType.stream,
    );

    final payload = {
      'model': _currentModel.id,
      'stream': true,
      'messages': request.turns.map((turn) {
        final roleStr = switch (turn.role) {
          AiRole.system => 'system',
          AiRole.user => 'user',
          AiRole.assistant => 'assistant',
          AiRole.tool => 'tool',
        };
        return {
          'role': roleStr,
          'content': turn.content,
        };
      }).toList(),
      if (request.options.maxTokens != null)
        'max_tokens': request.options.maxTokens,
      if (request.options.temperature != null)
        'temperature': request.options.temperature,
    };

    try {
      final response = await _dio.post<ResponseBody>(
        url,
        data: payload,
        options: options,
        cancelToken: _activeCancelToken,
      );

      final streamBody = response.data?.stream;
      if (streamBody == null) {
        yield const DoneChunk(finishReason: FinishReasons.error);
        return;
      }

      final textLineStream = streamBody
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      yield* _sseParser.parseStream(textLineStream);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        yield const DoneChunk(finishReason: FinishReasons.cancelled);
      } else {
        yield const DoneChunk(finishReason: FinishReasons.error);
      }
    } catch (_) {
      yield const DoneChunk(finishReason: FinishReasons.error);
    } finally {
      _activeCancelToken = null;
    }
  }

  @override
  Future<void> cancel() async {
    if (_activeCancelToken != null && !_activeCancelToken!.isCancelled) {
      _activeCancelToken!.cancel('User cancelled generation');
      _activeCancelToken = null;
    }
  }
}
