import '../../domain/chat_provider.dart';
import '../../domain/entities/agent_item.dart';
import '../../domain/entities/participant.dart';
import '../sources/open_webui_client.dart';
import 'ai_chat_providers.dart';

/// Provider for Open WebUI backed generative AI conversations.
///
/// Conversations started for an agent (see [AgentItem.newConversationId]) are
/// answered by the Open WebUI model with that id; the client falls back to
/// its default model when the server does not offer it.
class OpenWebUiChatProvider extends RemoteAIChatProvider {
  OpenWebUiChatProvider({
    required OpenWebUiClient client,
    super.assistant = const Participant(
      id: 'open-webui-assistant',
      displayName: 'GOAI Assistant',
      type: SenderType.ai,
    ),
    super.systemPrompt,
    super.options,
    super.conversations,
    this.agentModelIds = const {},
  }) : _client = client,
       super(client: client);

  final OpenWebUiClient _client;

  /// App agent id → Open WebUI model id, for agents the app names itself
  /// (e.g. the Hỏi HR assistant). Other agent ids are model ids already.
  final Map<String, String> agentModelIds;

  OpenWebUiClient get client => _client;

  /// Attachments are uploaded by `OpenWebUiFileUploader` and passed to the
  /// model as RAG files.
  @override
  ChatProviderInfo get info => const ChatProviderInfo(
    id: 'open-webui',
    displayName: 'GO AI Workforce',
    capabilities: {
      ChatCapability.streaming,
      ChatCapability.stopGeneration,
      ChatCapability.regenerate,
      ChatCapability.citations,
      ChatCapability.attachments,
    },
  );

  @override
  String? modelIdFor(String conversationId) {
    final agentId = AgentItem.agentIdOf(conversationId);
    return agentModelIds[agentId] ?? agentId;
  }
}
