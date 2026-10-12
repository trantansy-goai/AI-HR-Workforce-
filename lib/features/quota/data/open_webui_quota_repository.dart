import 'package:dio/dio.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/error_mapper.dart';
import '../domain/user_quota.dart';

/// Token usage of the signed-in user from Open WebUI
/// (`GET /api/v1/users/usage?days=`): the sum of the daily `heatmap` tokens
/// of the period. Open WebUI reports no allowance, so [limitTokens] comes
/// from the app config. Usage counts saved chats only (the website's and the
/// app's).
class OpenWebUiQuotaRepository implements QuotaRepository {
  OpenWebUiQuotaRepository({
    required this._dio,
    required String baseUrl,
    required this.limitTokens,
    this.days = 30,
    this.periodName = '30 days',
  }) : _baseUrl = baseUrl.endsWith('/')
           ? baseUrl.substring(0, baseUrl.length - 1)
           : baseUrl;

  final Dio _dio;
  final String _baseUrl;

  /// Period length; the server accepts 7–732.
  final int days;
  final String periodName;
  final int limitTokens;

  @override
  Future<UserQuota> getUserQuota() async {
    final Response<Object?> response;
    try {
      response = await _dio.get<Object?>(
        '$_baseUrl/api/v1/users/usage',
        queryParameters: {'days': days},
      );
    } on DioException catch (e) {
      throw ErrorMapper.fromDio(e);
    }
    final heatmap = switch (response.data) {
      {'heatmap': final List<dynamic> days} => days,
      _ => throw const UnknownFailure('Malformed /api/v1/users/usage response'),
    };
    var used = 0;
    for (final day in heatmap.whereType<Map<String, dynamic>>()) {
      if (day['tokens'] case final num tokens) used += tokens.toInt();
    }
    return UserQuota(
      usedTokens: used,
      limitTokens: limitTokens,
      periodName: periodName,
    );
  }
}
