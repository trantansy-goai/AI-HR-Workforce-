import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../../auth/application/auth_providers.dart';
import '../data/fake_news_repository.dart';
import '../data/open_webui_news_repository.dart';
import '../domain/news_item.dart';

/// News: Open WebUI notes shared with the user, or fixtures with the fake
/// backend. Rebuilt per user.
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) {
    return FakeNewsRepository();
  }
  final user = ref.watch(authControllerProvider.select((s) => s.user));
  return OpenWebUiNewsRepository(
    dio: ref.watch(authenticatedDioProvider),
    baseUrl: config.openWebUiBaseUrl,
    selfId: user?.id ?? '',
    // Without this permission the notes API answers 401 (session end).
    enabled:
        user != null && (user.role == 'admin' || user.allows('features.notes')),
  );
});

final newsListProvider = FutureProvider.autoDispose<List<NewsItem>>((
  ref,
) async {
  final repo = ref.watch(newsRepositoryProvider);
  return repo.getNews();
});

final newsDetailProvider = FutureProvider.autoDispose.family<NewsItem, String>((
  ref,
  id,
) async {
  final repo = ref.watch(newsRepositoryProvider);
  return repo.getNewsDetail(id);
});
