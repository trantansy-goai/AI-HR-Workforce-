import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/fake_learning_repository.dart';
import '../domain/learning_course.dart';

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  return FakeLearningRepository();
});

final learningCoursesProvider =
    FutureProvider.autoDispose<List<LearningCourse>>((ref) async {
      final repo = ref.watch(learningRepositoryProvider);
      return repo.getCourses();
    });

final learningCourseDetailProvider = FutureProvider.autoDispose
    .family<LearningCourse, String>((ref, id) async {
      final repo = ref.watch(learningRepositoryProvider);
      return repo.getCourseDetail(id);
    });
