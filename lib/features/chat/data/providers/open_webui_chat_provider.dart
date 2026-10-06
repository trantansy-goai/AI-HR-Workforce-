import '../../domain/entities/participant.dart';
import '../sources/open_webui_client.dart';
import 'ai_chat_providers.dart';

/// Provider for Open WebUI backed generative AI conversations.
class OpenWebUiChatProvider extends RemoteAIChatProvider {
  OpenWebUiChatProvider({
    required OpenWebUiClient client,
    super.assistant = const Participant(
      id: 'open-webui-assistant',
      displayName: 'GOAI Assistant',
      type: SenderType.ai,
    ),
    super.systemPrompt =
        'You are a helpful GOAI assistant powered by Open WebUI.',
    super.options,
    super.conversations,
  }) : _client = client,
       super(client: client);

  final OpenWebUiClient _client;

  OpenWebUiClient get client => _client;
}
