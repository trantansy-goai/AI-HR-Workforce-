import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/ai/text_generation.dart';
import '../../domain/extensions/ai_extensions.dart';
import 'open_webui_sse_parser.dart';

/// Production client adapter for Open WebUI AI & Model APIs.
///
/// Use the authenticated Dio client: it attaches the signed-in user's JWT
/// and ends the session on 401, as the API handoff requires.
class OpenWebUiClient implements RemoteAiClient {
  OpenWebUiClient({
    required this._dio,
    required String openWebUiBaseUrl,
    this._sseParser = const OpenWebUiSseParser(),
    this.generationTimeout = const Duration(minutes: 5),
  }) : _baseUrl = openWebUiBaseUrl.endsWith('/')
           ? openWebUiBaseUrl.substring(0, openWebUiBaseUrl.length - 1)
           : openWebUiBaseUrl;

  final Dio _dio;
  final String _baseUrl;
  final OpenWebUiSseParser _sseParser;

  /// Max wait for the next streamed chunk. Agents pause for 10–20 s while
  /// retrieving or calling tools, beyond the app-wide receive timeout.
  final Duration generationTimeout;

  /// Placeholder until the server's model list is known; never sent.
  static const _unresolved = ModelInfo(id: '', displayName: 'Open WebUI');

  ModelInfo _currentModel = _unresolved;
  List<ModelInfo>? _models;
  CancelToken? _activeCancelToken;

  @override
  ModelInfo get model => _currentModel;

  /// Updates the default model for requests that don't name one.
  void setModel(ModelInfo newModel) {
    _currentModel = newModel;
  }

  /// Models/agents the signed-in user may use (`GET /api/models`).
  ///
  /// Throws `AppFailure` (e.g. `UnauthorizedFailure` on 401).
  Future<List<ModelInfo>> fetchModels() async {
    final Response<dynamic> response;
    try {
      response = await _dio.get<dynamic>('$_baseUrl/api/models');
    } on DioException catch (e) {
      throw ErrorMapper.fromDio(e);
    }
    final models = parseModels(response.data);
    _models = models;
    if (!models.contains(_currentModel) && models.isNotEmpty) {
      _currentModel = models.first;
    }
    return models;
  }

  /// `{"data": [{"id", "name", "info": {"meta": {"description"}}}]}`.
  static List<ModelInfo> parseModels(Object? body) {
    final list = body is Map ? body['data'] : null;
    if (list is! List) {
      throw const UnknownFailure('Malformed /api/models response');
    }
    return [
      for (final item in list.whereType<Map<String, dynamic>>())
        if (item['id']?.toString() case final id? when id.isNotEmpty)
          ModelInfo(
            id: id,
            displayName: item['name']?.toString() ?? id,
            description: switch (item['info']) {
              {'meta': {'description': final String d}} when d.isNotEmpty => d,
              _ => null,
            },
          ),
    ];
  }

  /// The model to answer [request]: the requested one when the server
  /// offers it, else the current default.
  Future<ModelInfo> _resolveModel(GenerationRequest request) async {
    final models = _models ?? await fetchModels();
    if (models.isEmpty) {
      throw const ForbiddenFailure('No models available for this account');
    }
    final requested = request.modelId;
    return models.firstWhere(
      (m) => m.id == requested,
      orElse: () =>
          models.contains(_currentModel) ? _currentModel : models.first,
    );
  }

  @override
  Stream<AiStreamChunk> generate(GenerationRequest request) async* {
    await cancel(); // Cancel any existing generation in flight
    final cancelToken = _activeCancelToken = CancelToken();

    try {
      final model = await _resolveModel(request);
      // Reported as the author model of the reply.
      _currentModel = model;

      final response = await _dio.post<ResponseBody>(
        '$_baseUrl/api/chat/completions',
        data: buildPayload(request, model.id),
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: generationTimeout,
        ),
        cancelToken: cancelToken,
      );

      final body = response.data;
      if (body == null) {
        yield const DoneChunk(finishReason: FinishReasons.error);
        return;
      }
      final text = body.stream.cast<List<int>>().transform(utf8.decoder);

      // The server's "Stream Chat Response" setting may override `stream`.
      final contentType = response.headers.value(Headers.contentTypeHeader);
      if (contentType != null && contentType.contains('application/json')) {
        yield* _sseParser.parseCompletion(await text.join());
      } else {
        yield* _sseParser.parseStream(text.transform(const LineSplitter()));
      }
    } on DioException catch (e) {
      yield DoneChunk(
        finishReason: CancelToken.isCancel(e)
            ? FinishReasons.cancelled
            : FinishReasons.error,
      );
    } on AppFailure {
      yield const DoneChunk(finishReason: FinishReasons.error);
    } finally {
      if (identical(_activeCancelToken, cancelToken)) _activeCancelToken = null;
    }
  }

  /// `POST /api/chat/completions` body.
  static Map<String, Object?> buildPayload(
    GenerationRequest request,
    String modelId,
  ) => {
    'model': modelId,
    'stream': true,
    'messages': [
      for (final turn in request.turns)
        {'role': turn.role.name, 'content': turn.content},
    ],
    if (request.fileIds.isNotEmpty)
      'files': [
        for (final id in request.fileIds.toSet()) {'type': 'file', 'id': id},
      ],
    if (request.options.maxTokens != null)
      'max_tokens': request.options.maxTokens,
    if (request.options.temperature != null)
      'temperature': request.options.temperature,
  };

  @override
  Future<void> cancel() async {
    final token = _activeCancelToken;
    if (token != null && !token.isCancelled) {
      token.cancel('User cancelled generation');
    }
    _activeCancelToken = null;
  }
}
