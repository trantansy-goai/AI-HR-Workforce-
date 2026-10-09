import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../../auth/application/auth_providers.dart';
import '../data/fake_quota_repository.dart';
import '../data/open_webui_quota_repository.dart';
import '../domain/user_quota.dart';

/// Token usage: Open WebUI `/api/v1/users/usage` against the configured
/// allowance (`TOKEN_QUOTA_LIMIT`), or a fixed demo quota with the fake
/// backend. Rebuilt per user.
final quotaRepositoryProvider = Provider<QuotaRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) {
    return FakeQuotaRepository();
  }
  ref.watch(authControllerProvider.select((s) => s.user?.id));
  return OpenWebUiQuotaRepository(
    dio: ref.watch(authenticatedDioProvider),
    baseUrl: config.openWebUiBaseUrl,
    limitTokens: config.tokenQuotaLimit,
  );
});

final userQuotaProvider = FutureProvider.autoDispose<UserQuota>((ref) async {
  final repo = ref.watch(quotaRepositoryProvider);
  return repo.getUserQuota();
});
