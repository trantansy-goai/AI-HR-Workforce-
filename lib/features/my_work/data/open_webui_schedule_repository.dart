import 'package:dio/dio.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/error/error_mapper.dart';
import '../domain/scheduled_item.dart';

/// Events from the user's Open WebUI calendars, including events they are
/// invited to (`GET /api/v1/calendars/events?start=&end=`, ISO 8601;
/// `start_at` is in nanoseconds). Cancelled events are skipped.
class OpenWebUiScheduleRepository implements ScheduleRepository {
  OpenWebUiScheduleRepository({required this._dio, required String baseUrl})
    : _baseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

  final Dio _dio;
  final String _baseUrl;

  @override
  Future<List<ScheduledItem>> between(DateTime from, DateTime to) async {
    final Response<Object?> response;
    try {
      response = await _dio.get<Object?>(
        '$_baseUrl/api/v1/calendars/events',
        queryParameters: {
          'start': from.toUtc().toIso8601String(),
          'end': to.toUtc().toIso8601String(),
        },
      );
    } on DioException catch (e) {
      throw ErrorMapper.fromDio(e);
    }
    final events = response.data;
    if (events is! List) {
      throw const UnknownFailure('Malformed /api/v1/calendars/events response');
    }
    final items = [
      for (final e in events.whereType<Map<String, dynamic>>())
        if (e['is_cancelled'] != true &&
            e['id'] is String &&
            e['start_at'] is num)
          ScheduledItem(
            id: e['id'] as String,
            title: (e['title'] ?? '').toString(),
            startsAt: DateTime.fromMicrosecondsSinceEpoch(
              (e['start_at'] as num) ~/ 1000,
            ),
            location: switch (e['location']) {
              final String l when l.trim().isNotEmpty => l.trim(),
              _ => null,
            },
          ),
    ]..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return items;
  }
}
