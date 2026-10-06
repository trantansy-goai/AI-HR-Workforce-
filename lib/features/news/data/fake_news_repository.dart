import '../domain/news_item.dart';

class FakeNewsRepository implements NewsRepository {
  static final _news = [
    NewsItem(
      id: 'news-1',
      title: 'GOAI Mobile Phase 1 Milestone Reached',
      summary: 'Mobile team completes core Open WebUI integration and initial modular release.',
      content: 'We are pleased to announce that GOAI Mobile Phase 1 architecture has successfully integrated generative AI chat, streaming SSE parsers, document management, and offline test modules.',
      publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    NewsItem(
      id: 'news-2',
      title: 'Enterprise AI Model Upgrade Announced',
      summary: 'New high-performance models deployed to Open WebUI backend clusters.',
      content: 'Our cloud backend has upgraded model endpoints for faster inference response rates, higher context limits, and improved RAG source retrieval accuracy.',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<List<NewsItem>> getNews() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _news;
  }

  @override
  Future<NewsItem> getNewsDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _news.firstWhere((n) => n.id == id, orElse: () => _news.first);
  }
}
