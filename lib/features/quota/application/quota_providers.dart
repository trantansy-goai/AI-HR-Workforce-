import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/fake_quota_repository.dart';
import '../domain/user_quota.dart';

final quotaRepositoryProvider = Provider<QuotaRepository>((ref) {
  return FakeQuotaRepository();
});

final userQuotaProvider = FutureProvider.autoDispose<UserQuota>((ref) async {
  final repo = ref.watch(quotaRepositoryProvider);
  return repo.getUserQuota();
});
