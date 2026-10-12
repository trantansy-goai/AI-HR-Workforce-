import '../../../core/error/app_failure.dart';
import '../domain/test_models.dart';

/// Used against the real backend until an online test API exists: no tests,
/// so the screen shows its empty state instead of an error.
class NoopTestRepository implements OnlineTestRepository {
  const NoopTestRepository();

  @override
  Future<List<OnlineTest>> getTests() async => const [];

  @override
  Future<List<TestQuestion>> getTestQuestions(String testId) async =>
      throw NotFoundFailure('Test $testId not found');

  @override
  Future<TestResult> submitTest(TestSubmission submission) async =>
      throw NotFoundFailure('Test ${submission.testId} not found');
}
