import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/fake_news_repository.dart';
import '../domain/news_item.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return FakeNewsRepository();
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
