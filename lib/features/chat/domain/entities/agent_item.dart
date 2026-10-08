import 'package:equatable/equatable.dart';

/// Descriptor for an enterprise AI Assistant Agent.
class AgentItem extends Equatable {
  const AgentItem({
    required this.id,
    required this.name,
    required this.description,
    required this.role,
    this.avatarUrl,
    this.modelId,
  });

  /// Agent behind the Hỏi HR tab. Transports map it to a server model
  /// (see `OpenWebUiChatProvider.agentModelIds`).
  static const hrAssistantId = 'hr-assistant';

  /// Conversation id for a new chat with agent [agentId]
  /// (`agent-<agentId>-<millis>`).
  static String newConversationId(String agentId, {DateTime? now}) =>
      'agent-$agentId-${(now ?? DateTime.now()).millisecondsSinceEpoch}';

  /// The agent id encoded by [newConversationId], or null for other ids.
  static String? agentIdOf(String conversationId) =>
      RegExp(r'^agent-(.+)-\d+$').firstMatch(conversationId)?.group(1);

  final String id;
  final String name;
  final String description;
  final String role;
  final String? avatarUrl;
  final String? modelId;

  @override
  List<Object?> get props => [id, name, description, role, avatarUrl, modelId];
}
