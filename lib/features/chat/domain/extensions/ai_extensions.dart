import '../entities/message_metadata.dart';

/// Optional AI-specific message data. These live on top of the generic chat
/// domain: nothing in `Message`/`Conversation` depends on them, and they
/// carry no vendor types.

/// Which model produced a message and how generation ended.
class AiGenerationInfo extends MessageExtension {
  const AiGenerationInfo({
    required this.model,
    this.finishReason,
    this.promptTokens,
    this.completionTokens,
  });

  final ModelInfo model;

  /// e.g. `stop`, `length`, `cancelled`, `error`.
  final String? finishReason;
  final int? promptTokens;
  final int? completionTokens;

  bool get wasCancelled => finishReason == FinishReasons.cancelled;

  @override
  String get key => 'ai.generation';

  @override
  Map<String, Object?> toJson() => {
    'model': model.toJson(),
    'finishReason': finishReason,
    'promptTokens': promptTokens,
    'completionTokens': completionTokens,
  };

  @override
  List<Object?> get props => [
    model,
    finishReason,
    promptTokens,
    completionTokens,
  ];
}

abstract final class FinishReasons {
  static const stop = 'stop';
  static const length = 'length';
  static const cancelled = 'cancelled';
  static const error = 'error';
}

/// Vendor-neutral model descriptor.
class ModelInfo {
  const ModelInfo({
    required this.id,
    required this.displayName,
    this.isLocal = false,
    this.contextWindow,
    this.description,
    this.suggestions = const [],
  });

  final String id;
  final String displayName;

  /// What the model/agent is for, as configured on the server.
  final String? description;

  /// Starter questions configured for this model/agent.
  final List<PromptSuggestion> suggestions;

  /// True when inference runs on-device.
  final bool isLocal;
  final int? contextWindow;

  Map<String, Object?> toJson() => {
    'id': id,
    'displayName': displayName,
    'isLocal': isLocal,
    'contextWindow': contextWindow,
    'description': description,
  };

  @override
  bool operator ==(Object other) =>
      other is ModelInfo && other.id == id && other.isLocal == isLocal;

  @override
  int get hashCode => Object.hash(id, isLocal);
}

/// The user's rating of a reply: +1 (helpful) or -1 (not helpful).
class UserRating extends MessageExtension {
  const UserRating(this.value) : assert(value == 1 || value == -1);

  final int value;

  bool get isPositive => value > 0;

  @override
  String get key => 'feedback.rating';

  @override
  Map<String, Object?> toJson() => {'value': value};

  @override
  List<Object?> get props => [value];
}

/// A ready-made question the user can ask with one tap.
class PromptSuggestion {
  const PromptSuggestion({required this.label, required this.text});

  /// Short chip label.
  final String label;

  /// Message sent when chosen.
  final String text;

  @override
  bool operator ==(Object other) =>
      other is PromptSuggestion && other.label == label && other.text == text;

  @override
  int get hashCode => Object.hash(label, text);
}

/// Sources backing an answer (RAG / web search / knowledge base).
class Citations extends MessageExtension {
  const Citations(this.sources);

  final List<SourceReference> sources;

  @override
  String get key => 'ai.citations';

  @override
  Map<String, Object?> toJson() => {
    'sources': [for (final s in sources) s.toJson()],
  };

  @override
  List<Object?> get props => [sources];
}

class SourceReference {
  const SourceReference({
    required this.id,
    required this.title,
    this.uri,
    this.snippet,
    this.score,
  });

  final String id;
  final String title;
  final String? uri;
  final String? snippet;

  /// Retrieval relevance (0..1), when the backend provides it.
  final double? score;

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'uri': uri,
    'snippet': snippet,
    'score': score,
  };

  @override
  bool operator ==(Object other) =>
      other is SourceReference && other.id == id && other.uri == uri;

  @override
  int get hashCode => Object.hash(id, uri);
}

/// Tool/function calls made while producing a message.
class ToolCalls extends MessageExtension {
  const ToolCalls(this.calls);

  final List<ToolCallResult> calls;

  @override
  String get key => 'ai.toolCalls';

  @override
  Map<String, Object?> toJson() => {
    'calls': [for (final c in calls) c.toJson()],
  };

  @override
  List<Object?> get props => [calls];
}

class ToolCallResult {
  const ToolCallResult({
    required this.id,
    required this.name,
    this.argumentsJson,
    this.resultJson,
    this.isError = false,
  });

  final String id;
  final String name;

  /// Raw JSON strings keep this type vendor-neutral.
  final String? argumentsJson;
  final String? resultJson;
  final bool isError;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'arguments': argumentsJson,
    'result': resultJson,
    'isError': isError,
  };

  @override
  bool operator ==(Object other) =>
      other is ToolCallResult && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}
