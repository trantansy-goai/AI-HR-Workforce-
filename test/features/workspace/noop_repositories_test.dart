import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/config/app_config.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/features/approval/application/approval_providers.dart';
import 'package:goai_mobile/features/elearning/application/learning_providers.dart';
import 'package:goai_mobile/features/online_test/application/test_providers.dart';

import '../../helpers/test_helpers.dart';

void main() {
  // Real backend: learning, tests and approvals have no API yet, so their
  // lists are empty (the screens show "No data") instead of failing.
  const realConfig = AppConfig(
    environment: AppEnvironment.staging,
    appName: 'Test App',
    apiBaseUrl: 'https://api.test',
    useFakeBackend: false,
    useFakeNativeAdapters: true,
  );

  test('modules without an API return empty lists', () async {
    final container = ProviderContainer(
      overrides: baseTestOverrides(config: realConfig),
      retry: noRetry,
    );
    addTearDown(container.dispose);

    expect(await container.read(learningCoursesProvider.future), isEmpty);
    expect(await container.read(onlineTestsProvider.future), isEmpty);
    expect(await container.read(approvalListProvider.future), isEmpty);
    await expectLater(
      container.read(learningRepositoryProvider).getCourseDetail('x'),
      throwsA(isA<NotFoundFailure>()),
    );
  });
}
