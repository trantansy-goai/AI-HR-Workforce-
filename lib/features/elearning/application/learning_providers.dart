import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/fake_learning_repository.dart';
import '../domain/learning_course.dart';

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) {
    return FakeLearningRepository();
  }
  throw UnimplementedError(
    'Remote Learning API repository is pending backend integration. Set useFakeBackend=true for development demo mode.',
  );
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
