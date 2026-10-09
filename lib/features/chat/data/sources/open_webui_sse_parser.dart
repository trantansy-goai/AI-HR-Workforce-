import 'dart:convert';

import '../../domain/ai/text_generation.dart';
import '../../domain/extensions/ai_extensions.dart';

/// Parses Open WebUI / OpenAI-compatible `/api/chat/completions` responses.
///
/// Stream events (`data: <json>` lines):
/// - `{"choices": [{"delta": {"content": "..."}, "finish_reason": null}]}`
/// - `{"sources": [...]}` (Open WebUI RAG) or `{"citations": [...]}`
/// - `{"usage": {"prompt_tokens": 1, "completion_tokens": 2}}`
/// - `{"error": ...}` and the terminal `[DONE]`
class OpenWebUiSseParser {
  const OpenWebUiSseParser();

  /// Transforms SSE lines (e.g. from `LineSplitter`) into typed chunks.
  Stream<AiStreamChunk> parseStream(Stream<String> textLines) async* {
    var buffer = '';
    final state = _StreamState();

    await for (final chunk in textLines) {
      buffer += '$chunk\n';
      final lines = buffer.split('\n');
      // Keep incomplete trailing line in buffer
      buffer = lines.removeLast();

      for (final line in lines) {
        for (final out in _parseLine(line, state)) {
          yield out;
          if (out is DoneChunk) return;
        }
      }
    }

    for (final out in _parseLine(buffer, state)) {
      yield out;
      if (out is DoneChunk) return;
    }
    // Stream ended without [DONE] / finish_reason.
    yield state.done(FinishReasons.stop);
  }

  /// Parses a non-streamed completion:
  /// `{"choices": [{"message": {"content": "..."}, "finish_reason": "stop"}]}`.
  Stream<AiStreamChunk> parseCompletion(String body) async* {
    final Object? json;
    try {
      json = jsonDecode(body);
    } on FormatException {
      yield const DoneChunk(finishReason: FinishReasons.error);
      return;
    }
    if (json is! Map<String, dynamic> || json.containsKey('error')) {
      yield const DoneChunk(finishReason: FinishReasons.error);
      return;
    }
    if (_sources(json) case final sources?) yield CitationsChunk(sources);
    final state = _StreamState()..readUsage(json);
    var finish = FinishReasons.stop;
    if (json['choices'] case [final Map<String, dynamic> choice, ...]) {
      if (choice['message'] case {'content': final String content}
          when content.isNotEmpty) {
        yield TextChunk(content);
      }
      if (choice['finish_reason'] case final String reason
          when reason.isNotEmpty) {
        finish = reason;
      }
    }
    yield state.done(finish);
  }

  Iterable<AiStreamChunk> _parseLine(String line, _StreamState state) sync* {
    final trimmed = line.trim();
    // Empty line, SSE comment or non-data field (event:, id:, retry:).
    if (!trimmed.startsWith('data:')) return;
    final data = trimmed.substring(5).trim();

    if (data == '[DONE]') {
      yield state.done(FinishReasons.stop);
      return;
    }

    final Object? json;
    try {
      json = jsonDecode(data);
    } on FormatException {
      return; // Ignore malformed chunks.
    }
    if (json is! Map<String, dynamic>) return;

    if (json.containsKey('error')) {
      yield const DoneChunk(finishReason: FinishReasons.error);
      return;
    }
    if (_sources(json) case final sources?) yield CitationsChunk(sources);
    state.readUsage(json);

    if (json['choices'] case [final Map<String, dynamic> choice, ...]) {
      if (choice['delta'] case {'content': final String content}
          when content.isNotEmpty) {
        yield TextChunk(content);
      }
      if (choice['finish_reason'] case final String reason
          when reason.isNotEmpty) {
        // Usage may still follow; wait for [DONE] when the server sends it.
        state.finishReason = reason;
      }
    }
  }

  List<SourceReference>? _sources(Map<String, dynamic> json) {
    final raw = json['sources'] ?? json['citations'];
    if (raw is! List) return null;
    final sources = [
      for (final item in raw.whereType<Map<String, dynamic>>())
        ?_sourceOf(item),
    ];
    return sources.isEmpty ? null : sources;
  }

  /// Accepts Open WebUI's `{"source": {...}, "document": [...],
  /// "metadata": [{...}]}` and flat `{"id", "title", "url", "snippet"}`.
  SourceReference? _sourceOf(Map<String, dynamic> item) {
    final source = item['source'] is Map
        ? item['source'] as Map
        : const <String, Object?>{};
    final metadata = switch (item['metadata']) {
      [final Map<dynamic, dynamic> first, ...] => first,
      _ => const <String, Object?>{},
    };
    String? pick(List<Object?> values) => values
        .whereType<Object>()
        .map((v) => v.toString())
        .where((v) => v.isNotEmpty)
        .firstOrNull;

    final title = pick([
      source['name'],
      item['title'],
      item['name'],
      metadata['name'],
      metadata['source'],
    ]);
    final id = pick([source['id'], item['id'], metadata['file_id'], title]);
    if (id == null) return null;
    return SourceReference(
      id: id,
      title: title ?? id,
      uri: pick([source['url'], item['uri'], item['url'], metadata['url']]),
      snippet: pick([
        if (item['document'] case [final Object first, ...]) first,
        item['snippet'],
        item['content'],
      ]),
    );
  }
}

class _StreamState {
  String? finishReason;
  int? promptTokens;
  int? completionTokens;

  void readUsage(Map<String, dynamic> json) {
    if (json['usage'] case final Map<String, dynamic> usage) {
      promptTokens = (usage['prompt_tokens'] as num?)?.toInt() ?? promptTokens;
      completionTokens =
          (usage['completion_tokens'] as num?)?.toInt() ?? completionTokens;
    }
  }

  DoneChunk done(String fallback) => DoneChunk(
    finishReason: finishReason ?? fallback,
    promptTokens: promptTokens,
    completionTokens: completionTokens,
  );
}
