import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../../auth/application/auth_providers.dart';
import '../../file/application/file_providers.dart';
import '../data/cache/in_memory_chat_cache.dart';
import '../data/chat_repository_impl.dart';
import '../data/providers/mock_chat_provider.dart';
import '../data/providers/open_webui_chat_provider.dart';
import '../data/repositories/model_repository_impl.dart';
import '../data/sources/open_webui_client.dart';
import '../domain/chat_cache.dart';
import '../domain/chat_provider.dart';
import '../domain/chat_repository.dart';
import '../domain/entities/conversation.dart';
import '../domain/entities/participant.dart';

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

/// Open WebUI HTTP & SSE API client.
final openWebUiClientProvider = Provider<OpenWebUiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = ref.watch(authenticatedDioProvider);
  return OpenWebUiClient(
    dio: dio,
    openWebUiBaseUrl: config.openWebUiBaseUrl,
    apiKey: config.openWebUiApiKey,
  );
});

/// Model & Agent repository.
final modelRepositoryProvider = Provider<ModelRepositoryImpl>((ref) {
  return ModelRepositoryImpl(ref.watch(openWebUiClientProvider));
});

/// Open WebUI generative chat provider.
final openWebUiChatProvider = Provider<OpenWebUiChatProvider>((ref) {
  final provider = OpenWebUiChatProvider(
    client: ref.watch(openWebUiClientProvider),
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
