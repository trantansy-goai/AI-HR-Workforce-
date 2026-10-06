import 'package:flutter_project_base/features/quota/domain/user_quota.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserQuota Entity Logic', () {
    test('calculates percentage, remaining tokens and warning state', () {
      const normalQuota = UserQuota(
        usedTokens: 10000,
        limitTokens: 50000,
        periodName: 'Oct',
      );
      expect(normalQuota.remainingTokens, equals(40000));
      expect(normalQuota.usagePercentage, equals(0.2));
      expect(normalQuota.isWarning, isFalse);
      expect(normalQuota.isExceeded, isFalse);

      const warningQuota = UserQuota(
        usedTokens: 42000,
        limitTokens: 50000,
        periodName: 'Oct',
      );
      expect(warningQuota.isWarning, isTrue);
      expect(warningQuota.isExceeded, isFalse);

      const exceededQuota = UserQuota(
        usedTokens: 55000,
        limitTokens: 50000,
        periodName: 'Oct',
      );
      expect(exceededQuota.isExceeded, isTrue);
      expect(exceededQuota.remainingTokens, equals(0));
    });
  });
}
