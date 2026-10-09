import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/features/news/data/open_webui_news_repository.dart';

import '../../helpers/fake_http_adapter.dart';

const _createdNs = 1791500000000000000; // 2026-10-08, notes use nanoseconds.

Map<String, Object?> _note(String id, String title, String md, String userId) =>
    {
      'id': id,
      'title': title,
      'data': {
        'content': {'md': md},
      },
      'created_at': _createdNs,
      'user': {'id': userId, 'name': userId == 'hr' ? 'HR Team' : 'Mai'},
    };

void main() {
  late FakeHttpAdapter http;

  OpenWebUiNewsRepository repository({bool enabled = true}) {
    http = FakeHttpAdapter({
      'GET /api/v1/notes/': (_) => FakeResponse([
        _note(
          'n-1',
          'Lịch khám sức khỏe',
          '# Lịch khám\n\nNhân viên **Nhà máy A** khám ngày [10/10](https://x).',
          'hr',
        ),
        _note('n-2', 'My draft', 'private', 'me'),
        _note('n-3', '', '## Thông báo nghỉ lễ\nNghỉ 2/9.', 'hr'),
      ]),
      'GET /api/v1/configs/banners': (_) => const FakeResponse([
        {
          'id': 'b-1',
          'type': 'info',
          'content': '**Bảo trì hệ thống** tối 12/10',
          'dismissible': true,
          'timestamp': 1791600000,
        },
      ]),
      'GET /api/v1/notes/n-1': (_) =>
          FakeResponse(_note('n-1', 'Lịch khám sức khỏe', 'Full text', 'hr')),
    });
    return OpenWebUiNewsRepository(
      dio: fakeDio(http),
      baseUrl: 'https://webui.test',
      selfId: 'me',
      enabled: enabled,
    );
  }

  test('lists notes shared by others as news', () async {
    final news = await repository().getNews();

    expect(news.map((n) => n.id), ['banner:b-1', 'n-1', 'n-3']);
    expect(news.first.title, 'Bảo trì hệ thống tối 12/10');
    final first = news[1];
    expect(first.title, 'Lịch khám sức khỏe');
    expect(first.summary, 'Lịch khám Nhân viên Nhà máy A khám ngày 10/10.');
    expect(first.byline, 'HR Team');
    expect(
      first.publishedAt,
      DateTime.fromMicrosecondsSinceEpoch(_createdNs ~/ 1000),
    );
    expect(news.last.title, 'Thông báo nghỉ lễ');
  });

  test('reads the full note for the article', () async {
    final article = await repository().getNewsDetail('n-1');
    expect(article.content, 'Full text');
  });

  test('reads banners, but no notes, without the notes permission', () async {
    final repo = repository(enabled: false);

    expect((await repo.getNews()).map((n) => n.id), ['banner:b-1']);
    expect((await repo.getNewsDetail('banner:b-1')).content, contains('12/10'));
    await expectLater(
      repo.getNewsDetail('n-1'),
      throwsA(isA<ForbiddenFailure>()),
    );
    expect(http.calls, everyElement('GET /api/v1/configs/banners'));
  });
}
