import '../domain/test_models.dart';

class FakeTestRepository implements OnlineTestRepository {
  static final _tests = [
    const OnlineTest(
      id: 'test-1',
      title: 'AI Compliance & Security Certification Exam',
      description: 'Official test to verify understanding of AI safety & data handling policies.',
      timeLimitMinutes: 15,
      totalQuestions: 3,
    ),
    const OnlineTest(
      id: 'test-2',
      title: 'Information Safety Assessment 2026',
      description: 'Annual employee cybersecurity awareness quiz.',
      timeLimitMinutes: 10,
      totalQuestions: 2,
    ),
  ];

  static final Map<String, List<TestQuestion>> _questions = {
    'test-1': const [
      TestQuestion(
        id: 'q1',
        questionText: 'What type of information must NEVER be sent to public external LLMs?',
        options: [
          'Public company news',
          'Customer PII, API tokens, and confidential source code',
          'General programming syntax questions',
          'Weather forecasts',
        ],
      ),
      TestQuestion(
        id: 'q2',
        questionText:
            'Where are authentication tokens stored securely in GOAI Mobile?',
        options: [
          'Plaintext files on SD card',
          'Flutter SecureStore (Keychain / Keystore)',
          'SharedPreferences string',
          'Console log output',
        ],
      ),
      TestQuestion(
        id: 'q3',
        questionText: 'What should you do if an AI model outputs hallucinated or unverified facts?',
        options: [
          'Publish immediately without verification',
          'Cross-reference against authoritative documents',
          'Ignore company security guidelines',
          'Delete the application',
        ],
      ),
    ],
  };

  @override
  Future<List<OnlineTest>> getTests() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _tests;
  }

  @override
  Future<List<TestQuestion>> getTestQuestions(String testId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _questions[testId] ?? _questions['test-1']!;
  }

  @override
  Future<TestResult> submitTest(TestSubmission submission) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // Calculate simple mock score based on answers count
    final answered = submission.answers.length;
    final isPassed = answered >= 2;
    final score = isPassed ? 100 : 33;

    return TestResult(
      testId: submission.testId,
      scorePercentage: score,
      isPassed: isPassed,
      feedback: isPassed ? 'Congratulations! You passed the assessment.' : 'Score insufficient. Please review company policies and retake the assessment.',
    );
  }
}
