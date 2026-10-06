import 'package:flutter_project_base/features/online_test/data/fake_test_repository.dart';
import 'package:flutter_project_base/features/online_test/domain/test_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnlineTestRepository & Models', () {
    late FakeTestRepository repo;

    setUp(() {
      repo = FakeTestRepository();
    });

    test('fetches available tests', () async {
      final tests = await repo.getTests();
      expect(tests.isNotEmpty, isTrue);
      expect(tests.first.title, contains('AI Compliance'));
    });

    test('fetches questions for a test', () async {
      final questions = await repo.getTestQuestions('test-1');
      expect(questions.length, equals(3));
      expect(questions.first.options.length, equals(4));
    });

    test('submits test and returns grade result', () async {
      const submission = TestSubmission(
        testId: 'test-1',
        answers: {'q1': 1, 'q2': 1},
      );
      final result = await repo.submitTest(submission);
      expect(result.testId, equals('test-1'));
      expect(result.isPassed, isTrue);
      expect(result.scorePercentage, equals(100));
    });
  });
}
