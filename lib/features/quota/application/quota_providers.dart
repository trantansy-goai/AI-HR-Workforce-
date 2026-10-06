import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/fake_quota_repository.dart';
import '../domain/user_quota.dart';

final quotaRepositoryProvider = Provider<QuotaRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) {
    return FakeQuotaRepository();
  }
  throw UnimplementedError(
    'Remote Quota API repository is pending backend integration. Set useFakeBackend=true for development demo mode.',
  );
});

final userQuotaProvider = FutureProvider.autoDispose<UserQuota>((ref) async {
  final repo = ref.watch(quotaRepositoryProvider);
  return repo.getUserQuota();
});
