import 'package:equatable/equatable.dart';

/// Something on the user's calendar: a deadline, meeting or HR event.
class ScheduledItem extends Equatable {
  const ScheduledItem({
    required this.id,
    required this.title,
    required this.startsAt,
    this.location,
  });

  final String id;
  final String title;
  final DateTime startsAt;
  final String? location;

  @override
  List<Object?> get props => [id, title, startsAt, location];
}

abstract interface class ScheduleRepository {
  /// Items starting in [from]..[to], soonest first. Throws `AppFailure`.
  Future<List<ScheduledItem>> between(DateTime from, DateTime to);
}
