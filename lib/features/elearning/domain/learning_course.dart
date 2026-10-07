import 'package:equatable/equatable.dart';

/// Main content type of a course, shown as "Video 12 phút" / "Tài liệu 6 phút".
enum CourseFormat { video, document }

class LearningCourse extends Equatable {
  const LearningCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.lessonCount,
    required this.completionPercentage,
    required this.isCompleted,
    this.isMandatory = false,
    this.dueDate,
    this.format = CourseFormat.document,
    this.durationMinutes = 0,
    this.quizQuestionCount = 0,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final int lessonCount;
  final double completionPercentage;
  final bool isCompleted;

  /// Assigned as mandatory (e.g. safety) — highlighted on the Học tab.
  final bool isMandatory;
  final DateTime? dueDate;
  final CourseFormat format;
  final int durationMinutes;

  /// Questions in the closing quiz; 0 when the course has none.
  final int quizQuestionCount;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    lessonCount,
    completionPercentage,
    isCompleted,
    isMandatory,
    dueDate,
    format,
    durationMinutes,
    quizQuestionCount,
  ];
}

abstract interface class LearningRepository {
  Future<List<LearningCourse>> getCourses();
  Future<LearningCourse> getCourseDetail(String id);
}
