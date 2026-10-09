import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../../auth/application/auth_providers.dart';
import '../../file/application/file_providers.dart';
import '../../settings/application/settings_controller.dart';
import '../../voice/application/voice_providers.dart';
import '../data/cache/in_memory_chat_cache.dart';
import '../data/chat_repository_impl.dart';
import '../data/fixtures/chat_fixtures.dart';
import '../data/providers/mock_chat_provider.dart';
import '../data/providers/open_webui_chat_provider.dart';
import '../data/repositories/model_repository_impl.dart';
import '../data/sources/open_webui_chats_api.dart';
import '../data/sources/open_webui_client.dart';
import '../domain/chat_cache.dart';
import '../domain/chat_provider.dart';
import '../domain/chat_repository.dart';
import '../domain/entities/agent_item.dart';
import '../domain/entities/conversation.dart';
import '../domain/entities/participant.dart';
import '../domain/extensions/ai_extensions.dart';

/// The current user as a chat participant. Only rebuilds when identity
/// changes (not on token refresh).
final chatSelfProvider = Provider<Participant>((ref) {
  final id = ref.watch(authControllerProvider.select((s) => s.user?.id));
  final name = ref.watch(
    authControllerProvider.select((s) => s.user?.displayName ?? s.user?.email),
  );
  return Participant(
    id: id ?? 'anonymous',
    displayName: name ?? 'You',
    type: SenderType.user,
  );
});

/// Open WebUI HTTP & SSE API client, authorized with the user's JWT.
/// Rebuilt per user so a cached model list never outlives its account.
final openWebUiClientProvider = Provider<OpenWebUiClient>((ref) {
  ref.watch(chatSelfProvider.select((p) => p.id));
  return OpenWebUiClient(
    dio: ref.watch(authenticatedDioProvider),
    openWebUiBaseUrl: ref.watch(appConfigProvider).openWebUiBaseUrl,
  );
});

/// Model & Agent repository.
final modelRepositoryProvider = Provider<ModelRepositoryImpl>((ref) {
  return ModelRepositoryImpl(ref.watch(openWebUiClientProvider));
});

/// App agent id → Open WebUI model id, for agents the app names itself.
/// Hỏi HR → "GO AI Employee Service" (grounded HR FAQ + routing). Users
/// without access to it get their default model instead.
const _agentModelIds = {AgentItem.hrAssistantId: 'employee_service'};

/// The server model that answers for [agentId]; conversations list it as a
/// participant (see `AgentConversationListPage`).
String agentModelId(String agentId) => _agentModelIds[agentId] ?? agentId;

/// Open WebUI chat history (`/api/v1/chats/*`), shared with the website.
final openWebUiChatsApiProvider = Provider<OpenWebUiChatsApi>((ref) {
  return OpenWebUiChatsApi(
    dio: ref.watch(authenticatedDioProvider),
    baseUrl: ref.watch(appConfigProvider).openWebUiBaseUrl,
  );
});

/// Open WebUI generative chat provider; history is kept on the server.
final openWebUiChatProvider = Provider<OpenWebUiChatProvider>((ref) {
  final provider = OpenWebUiChatProvider(
    client: ref.watch(openWebUiClientProvider),
    agentModelIds: _agentModelIds,
    chats: ref.watch(openWebUiChatsApiProvider),
    self: ref.watch(chatSelfProvider),
    logger: ref.watch(appLoggerProvider),
  );
  ref.onDispose(provider.dispose);
  return provider;
});

/// The active transport behind the chat.
/// When fake backend is enabled, defaults to MockChatProvider;
/// otherwise uses OpenWebUiChatProvider.
final chatProviderProvider = Provider<ChatProvider>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) {
    final provider = MockChatProvider(self: ref.watch(chatSelfProvider));
    ref.onDispose(provider.dispose);
    return provider;
  }
  return ref.watch(openWebUiChatProvider);
});

/// Swap for a persistent implementation (Drift/SQLite) for offline history.
final chatCacheProvider = Provider<ChatCache>((ref) {
  // New user => fresh cache, so data never leaks between accounts.
  ref.watch(chatSelfProvider.select((p) => p.id));
  return InMemoryChatCache();
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final repository = ChatRepositoryImpl(
    provider: ref.watch(chatProviderProvider),
    cache: ref.watch(chatCacheProvider),
    self: ref.watch(chatSelfProvider),
    uploader: ref.watch(fileUploaderProvider),
    logger: ref.watch(appLoggerProvider),
    transcriber: ref.watch(speechTranscriberProvider),
    // The app's language (or the device's when it follows the system).
    transcriptionLanguage: () =>
        (ref.read(settingsControllerProvider).locale ??
                PlatformDispatcher.instance.locale)
            .languageCode,
  );
  ref.onDispose(repository.dispose);
  return repository;
});

/// Conversation list; triggers a refresh from the provider on first listen.
final conversationsProvider = StreamProvider.autoDispose<List<Conversation>>((
  ref,
) async* {
  final repository = ref.watch(chatRepositoryProvider);
  final result = await repository.refreshConversations();
  if (result.failureOrNull case final failure?) throw failure;
  yield* repository.watchConversations();
});

/// AI agents the signed-in user may chat with: Open WebUI models from
/// `GET /api/models` (filtered by the server per user), or fixtures with the
/// fake backend.
final agentsProvider = FutureProvider<List<AgentItem>>((ref) async {
  if (ref.watch(appConfigProvider).useFakeBackend) return ChatFixtures.agents;
  final models = await ref.watch(modelRepositoryProvider).getAgents();
  return [
    for (final model in models)
      AgentItem(
        id: model.id,
        name: model.displayName,
        description: model.description ?? '',
        role: '',
        modelId: model.id,
      ),
  ];
});

/// One-tap questions for [agentId]: the starters configured on its server
/// model plus the shared prompt templates. Empty with the fake backend, and
/// when the server has none or cannot be reached (they are optional).
final promptSuggestionsProvider = FutureProvider.autoDispose
    .family<List<PromptSuggestion>, String>((ref, agentId) async {
      if (ref.watch(appConfigProvider).useFakeBackend) return const [];
      final modelId = agentModelId(agentId);
      final (models, prompts) = await (
        ref
            .watch(modelRepositoryProvider)
            .getAgents()
            .catchError((Object _) => <ModelInfo>[]),
        ref
            .watch(openWebUiChatsApiProvider)
            .listPrompts()
            .catchError((Object _) => <PromptSuggestion>[]),
      ).wait;
      final starters = [
        for (final m in models)
          if (m.id == modelId) ...m.suggestions,
      ];
      return {...starters, ...prompts}.toList();
    });
