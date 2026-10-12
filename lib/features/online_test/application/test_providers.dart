import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/fake_test_repository.dart';
import '../data/noop_test_repository.dart';
import '../domain/test_models.dart';

final onlineTestRepositoryProvider = Provider<OnlineTestRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) {
    return FakeTestRepository();
  }
  return const NoopTestRepository();
});

final onlineTestsProvider = FutureProvider.autoDispose<List<OnlineTest>>((
  ref,
) async {
  final repo = ref.watch(onlineTestRepositoryProvider);
  return repo.getTests();
});

final testQuestionsProvider = FutureProvider.autoDispose
    .family<List<TestQuestion>, String>((ref, testId) async {
      final repo = ref.watch(onlineTestRepositoryProvider);
      return repo.getTestQuestions(testId);
    });

class TestTakingState {
  const TestTakingState({
    required this.testId,
    this.answers = const {},
    this.isSubmitting = false,
    this.result,
    this.error,
  });

  final String testId;
  final Map<String, int> answers; // questionId -> selectedOptionIndex
  final bool isSubmitting;
  final TestResult? result;
  final String? error;

  TestTakingState copyWith({
    Map<String, int>? answers,
    bool? isSubmitting,
    TestResult? result,
    String? error,
  }) {
    return TestTakingState(
      testId: testId,
      answers: answers ?? this.answers,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

class TestTakingController extends Notifier<TestTakingState> {
  TestTakingController(this.testId);

  final String testId;

  @override
  TestTakingState build() => TestTakingState(testId: testId);

  void selectAnswer(String questionId, int optionIndex) {
    if (state.isSubmitting || state.result != null) return;
    final updated = Map<String, int>.from(state.answers)
      ..[questionId] = optionIndex;
    state = state.copyWith(answers: updated);
  }

  Future<TestResult?> submit() async {
    // Prevent double submission
    if (state.isSubmitting || state.result != null) return state.result;

    state = state.copyWith(isSubmitting: true, error: null);
    try {
      final repo = ref.read(onlineTestRepositoryProvider);
      final result = await repo.submitTest(
        TestSubmission(testId: testId, answers: state.answers),
      );
      state = state.copyWith(isSubmitting: false, result: result);
      return result;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }
}

final testTakingControllerProvider = NotifierProvider.autoDispose
    .family<TestTakingController, TestTakingState, String>((testId) {
      return TestTakingController(testId);
    });
