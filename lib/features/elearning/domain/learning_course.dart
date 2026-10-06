import 'package:equatable/equatable.dart';

class LearningCourse extends Equatable {
  const LearningCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.lessonCount,
    required this.completionPercentage,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final int lessonCount;
  final double completionPercentage;
  final bool isCompleted;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    lessonCount,
    completionPercentage,
    isCompleted,
  ];
}

abstract interface class LearningRepository {
  Future<List<LearningCourse>> getCourses();
  Future<LearningCourse> getCourseDetail(String id);
}
