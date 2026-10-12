import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/fake_learning_repository.dart';
import '../data/noop_learning_repository.dart';
import '../domain/learning_course.dart';

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) {
    return FakeLearningRepository();
  }
  return const NoopLearningRepository();
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
