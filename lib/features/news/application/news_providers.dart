import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/fake_news_repository.dart';
import '../domain/news_item.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) {
    return FakeNewsRepository();
  }
  throw UnimplementedError(
    'Remote News API repository is pending backend integration. Set useFakeBackend=true for development demo mode.',
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
