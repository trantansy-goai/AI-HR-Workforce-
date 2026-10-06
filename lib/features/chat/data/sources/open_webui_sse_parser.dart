import 'dart:convert';
import '../../domain/ai/text_generation.dart';
import '../../domain/extensions/ai_extensions.dart';

/// Parses raw SSE event streams from Open WebUI / OpenAI compatible `/api/chat/completions`.
class OpenWebUiSseParser {
  const OpenWebUiSseParser();

  /// Transforms a stream of raw text chunks or lines into a stream of typed [AiStreamChunk]s.
  Stream<AiStreamChunk> parseStream(Stream<String> textLines) async* {
    var buffer = '';

    await for (final chunk in textLines) {
      buffer += chunk;
      final lines = buffer.split('\n');
      // Keep incomplete trailing line in buffer
      buffer = lines.removeLast();

      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith(':')) {
          continue; // Empty line or SSE comment
        }

        if (trimmed.startsWith('data: ')) {
          final data = trimmed.substring(6).trim();

          if (data == '[DONE]') {
            yield const DoneChunk(finishReason: FinishReasons.stop);
            return;
          }

          try {
            final json = jsonDecode(data);
            if (json is Map<String, dynamic>) {
              // Check for top-level error in stream
              if (json.containsKey('error')) {
                yield const DoneChunk(finishReason: FinishReasons.error);
                return;
              }

              // Extract citations / RAG sources if provided by Open WebUI
              if (json.containsKey('citations') || json.containsKey('sources')) {
                final citationsRaw = json['citations'] ?? json['sources'];
                if (citationsRaw is List && citationsRaw.isNotEmpty) {
                  final sources = <SourceReference>[];
                  for (final item in citationsRaw) {
                    if (item is Map<String, dynamic>) {
                      sources.add(SourceReference(
                        id: item['id']?.toString() ?? '',
                        title: item['title']?.toString() ?? item['name']?.toString() ?? 'Source',
                        uri: item['uri']?.toString() ?? item['url']?.toString(),
                        snippet: item['snippet']?.toString() ?? item['content']?.toString(),
                      ));
                    }
                  }
                  if (sources.isNotEmpty) {
                    yield CitationsChunk(sources);
                  }
                }
              }

              // Extract delta text content
              final choices = json['choices'];
              if (choices is List && choices.isNotEmpty) {
                final choice = choices.first;
                if (choice is Map<String, dynamic>) {
                  final delta = choice['delta'];
                  if (delta is Map<String, dynamic>) {
                    final content = delta['content'];
                    if (content is String && content.isNotEmpty) {
                      yield TextChunk(content);
                    }
                  }

                  final finishReason = choice['finish_reason'];
                  if (finishReason is String && finishReason.isNotEmpty) {
                    final mappedReason = finishReason == 'stop'
                        ? FinishReasons.stop
                        : finishReason;
                    yield DoneChunk(finishReason: mappedReason);
                    return;
                  }
                }
              }
            }
          } catch (_) {
            // Ignore malformed JSON chunks gracefully
          }
        }
      }
    }

    // Process leftover buffer line if stream ended without [DONE]
    if (buffer.trim().startsWith('data: ')) {
      final data = buffer.trim().substring(6).trim();
      if (data == '[DONE]') {
        yield const DoneChunk(finishReason: FinishReasons.stop);
      } else {
        try {
          final json = jsonDecode(data);
          if (json is Map<String, dynamic> && json.containsKey('choices')) {
            final choices = json['choices'];
            if (choices is List && choices.isNotEmpty) {
              final delta = (choices.first as Map<String, dynamic>)['delta'];
              if (delta is Map<String, dynamic> && delta['content'] is String) {
                yield TextChunk(delta['content'] as String);
              }
            }
          }
        } catch (_) {}
      }
    }
  }
}
