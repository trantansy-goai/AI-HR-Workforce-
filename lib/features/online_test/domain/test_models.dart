import 'package:equatable/equatable.dart';

class OnlineTest extends Equatable {
  const OnlineTest({
    required this.id,
    required this.title,
    required this.description,
    required this.timeLimitMinutes,
    required this.totalQuestions,
  });

  final String id;
  final String title;
  final String description;
  final int timeLimitMinutes;
  final int totalQuestions;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    timeLimitMinutes,
    totalQuestions,
  ];
}

class TestQuestion extends Equatable {
  const TestQuestion({
    required this.id,
    required this.questionText,
    required this.options,
  });

  final String id;
  final String questionText;
  final List<String> options;

  @override
  List<Object?> get props => [id, questionText, options];
}

class TestSubmission extends Equatable {
  const TestSubmission({
    required this.testId,
    required this.answers, // Map<questionId, selectedOptionIndex>
  });

  final String testId;
  final Map<String, int> answers;

  @override
  List<Object?> get props => [testId, answers];
}

class TestResult extends Equatable {
  const TestResult({
    required this.testId,
    required this.scorePercentage,
    required this.isPassed,
    required this.feedback,
  });

  final String testId;
  final int scorePercentage;
  final bool isPassed;
  final String feedback;

  @override
  List<Object?> get props => [testId, scorePercentage, isPassed, feedback];
}

abstract interface class OnlineTestRepository {
  Future<List<OnlineTest>> getTests();
  Future<List<TestQuestion>> getTestQuestions(String testId);
  Future<TestResult> submitTest(TestSubmission submission);
}
