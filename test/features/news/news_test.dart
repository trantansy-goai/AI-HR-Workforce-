import 'package:flutter_project_base/features/news/data/fake_news_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeNewsRepository', () {
    late FakeNewsRepository repo;

    setUp(() {
      repo = FakeNewsRepository();
    });

    test('fetches news articles', () async {
      final news = await repo.getNews();
      expect(news.length, equals(2));
      expect(news.first.title, contains('Phase 1'));
    });

    test('fetches news detail', () async {
      final item = await repo.getNewsDetail('news-2');
      expect(item.id, equals('news-2'));
      expect(item.title, contains('Model Upgrade'));
    });
  });
}
