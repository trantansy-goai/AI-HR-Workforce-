import 'package:equatable/equatable.dart';

class UserQuota extends Equatable {
  const UserQuota({
    required this.usedTokens,
    required this.limitTokens,
    required this.periodName,
  });

  final int usedTokens;
  final int limitTokens;
  final String periodName;

  int get remainingTokens => (limitTokens - usedTokens).clamp(0, limitTokens);
  double get usagePercentage =>
      limitTokens > 0 ? (usedTokens / limitTokens).clamp(0.0, 1.0) : 0.0;
  bool get isExceeded => usedTokens >= limitTokens;
  bool get isWarning => usagePercentage >= 0.8 && !isExceeded;

  @override
  List<Object?> get props => [usedTokens, limitTokens, periodName];
}

abstract interface class QuotaRepository {
  Future<UserQuota> getUserQuota();
}
