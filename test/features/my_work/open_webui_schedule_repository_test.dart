import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/features/my_work/data/open_webui_schedule_repository.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  test('reads calendar events in the range, soonest first', () async {
    final at = DateTime.utc(2026, 10, 12, 2);
    int ns(DateTime t) => t.microsecondsSinceEpoch * 1000;
    final http = FakeHttpAdapter({
      'GET /api/v1/calendars/events': (_) => FakeResponse([
        {
          'id': 'e-2',
          'title': 'Nộp hồ sơ thử việc',
          'start_at': ns(at.add(const Duration(days: 2))),
          'location': ' ',
        },
        {
          'id': 'e-1',
          'title': 'Khám sức khỏe',
          'start_at': ns(at),
          'location': 'Phòng y tế',
        },
        {'id': 'e-3', 'title': 'Hủy', 'start_at': ns(at), 'is_cancelled': true},
      ]),
    });
    final repository = OpenWebUiScheduleRepository(
      dio: fakeDio(http),
      baseUrl: 'https://webui.test/',
    );

    final items = await repository.between(
      DateTime.utc(2026, 10, 9),
      DateTime.utc(2026, 11, 8),
    );

    expect(items.map((i) => i.id), ['e-1', 'e-2']);
    expect(items.first.startsAt.toUtc(), at);
    expect(items.first.location, 'Phòng y tế');
    expect(items.last.location, isNull);
    expect(http.requests.single.queryParameters, {
      'start': '2026-10-09T00:00:00.000Z',
      'end': '2026-11-08T00:00:00.000Z',
    });
  });
}
