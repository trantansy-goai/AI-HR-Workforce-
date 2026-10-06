import 'package:flutter_project_base/features/elearning/data/fake_learning_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeLearningRepository', () {
    late FakeLearningRepository repo;

    setUp(() {
      repo = FakeLearningRepository();
    });

    test('fetches learning course list', () async {
      final courses = await repo.getCourses();
      expect(courses.length, greaterThanOrEqualTo(3));
      expect(courses.first.isCompleted, isTrue);
    });

    test('fetches course detail by id', () async {
      final course = await repo.getCourseDetail('course-2');
      expect(course.id, equals('course-2'));
      expect(course.lessonCount, equals(8));
    });
  });
}
