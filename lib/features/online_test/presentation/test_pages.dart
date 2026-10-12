import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../application/test_providers.dart';

class TestListPage extends ConsumerWidget {
  const TestListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testsAsync = ref.watch(onlineTestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Online Certification Tests')),
      body: ResponsiveCenter(
        child: testsAsync.when(
          loading: () => const LoadingView(label: 'Loading tests...'),
          error: (err, stack) => ErrorView(
            error: err,
            onRetry: () => ref.refresh(onlineTestsProvider),
          ),
          data: (tests) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final test = tests[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      test.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${test.totalQuestions} questions • ${test.timeLimitMinutes} mins\n${test.description}',
                    ),
                    isThreeLine: true,
                    trailing: ElevatedButton(
                      onPressed: () => context.push('/home/tests/${test.id}'),
                      child: const Text('Start'),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TestTakingPage extends ConsumerWidget {
  const TestTakingPage({required this.testId, super.key});

  final String testId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(testQuestionsProvider(testId));
    final testState = ref.watch(testTakingControllerProvider(testId));

    if (testState.result != null) {
      final res = testState.result!;
      return Scaffold(
        appBar: AppBar(title: const Text('Test Result')),
        body: ResponsiveCenter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  res.isPassed ? Icons.check_circle : Icons.cancel,
                  size: 80,
                  color: res.isPassed
                      ? AppHrPalette.accent
                      : AppHrPalette.danger,
                ),
                const SizedBox(height: 16),
                Text(
                  res.isPassed ? 'Test Passed!' : 'Test Failed',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Score: ${res.scorePercentage}%',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(res.feedback, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Back to Tests'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Taking Test')),
      body: ResponsiveCenter(
        child: questionsAsync.when(
          loading: () => const LoadingView(label: 'Loading questions...'),
          error: (err, stack) => ErrorView(
            error: err,
            onRetry: () => ref.refresh(testQuestionsProvider(testId)),
          ),
          data: (questions) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (int i = 0; i < questions.length; i++) ...[
                  Text(
                    'Q${i + 1}: ${questions[i].questionText}',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  for (
                    int optIdx = 0;
                    optIdx < questions[i].options.length;
                    optIdx++
                  ) ...[
                    RadioListTile<int>(
                      title: Text(questions[i].options[optIdx]),
                      value: optIdx,
                      // ignore: deprecated_member_use
                      groupValue: testState.answers[questions[i].id],
                      // ignore: deprecated_member_use
                      onChanged: (val) {
                        if (val != null) {
                          ref
                              .read(
                                testTakingControllerProvider(testId).notifier,
                              )
                              .selectAnswer(questions[i].id, val);
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: testState.isSubmitting
                      ? null
                      : () {
                          ref
                              .read(
                                testTakingControllerProvider(testId).notifier,
                              )
                              .submit();
                        },
                  child: testState.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Answers'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
