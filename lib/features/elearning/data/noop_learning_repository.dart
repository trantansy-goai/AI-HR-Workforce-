import '../../../core/error/app_failure.dart';
import '../domain/learning_course.dart';

/// Used against the real backend until a learning API exists: no courses,
/// so the screen shows its empty state instead of an error.
class NoopLearningRepository implements LearningRepository {
  const NoopLearningRepository();

  @override
  Future<List<LearningCourse>> getCourses() async => const [];

  @override
  Future<LearningCourse> getCourseDetail(String id) async =>
      throw NotFoundFailure('Course $id not found');
}
