import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/features/quota/data/open_webui_quota_repository.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  test(
    'sums the daily tokens of the period against the configured limit',
    () async {
      final http = FakeHttpAdapter({
        'GET /api/v1/users/usage': (_) => const FakeResponse({
          'totals': {'lifetime_tokens': 999999},
          'heatmap': [
            {'date': '2026-10-08', 'tokens': 10750},
            {'date': '2026-10-09', 'tokens': 10426},
            {'date': '2026-10-07'},
          ],
        }),
      });
      final repository = OpenWebUiQuotaRepository(
        dio: fakeDio(http),
        baseUrl: 'https://webui.test',
        limitTokens: 200000,
      );

      final quota = await repository.getUserQuota();

      expect(quota.usedTokens, 21176);
      expect(quota.limitTokens, 200000);
      expect(quota.usagePercentage, closeTo(0.106, 0.001));
      expect(quota.isWarning, isFalse);
      expect(http.requests.single.queryParameters, {'days': 30});
    },
  );

  test('rejects an unexpected response', () async {
    final repository = OpenWebUiQuotaRepository(
      dio: fakeDio(
        FakeHttpAdapter({
          'GET /api/v1/users/usage': (_) => const FakeResponse(<Object>[]),
        }),
      ),
      baseUrl: 'https://webui.test',
      limitTokens: 200000,
    );

    await expectLater(
      repository.getUserQuota(),
      throwsA(isA<UnknownFailure>()),
    );
  });
}
