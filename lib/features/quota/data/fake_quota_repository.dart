import '../domain/user_quota.dart';

class FakeQuotaRepository implements QuotaRepository {
  @override
  Future<UserQuota> getUserQuota() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const UserQuota(
      usedTokens: 42500,
      limitTokens: 50000,
      periodName: 'Monthly',
    );
  }
}
