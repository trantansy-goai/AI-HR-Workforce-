import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../application/learning_providers.dart';

class LearningListPage extends ConsumerWidget {
  const LearningListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(learningCoursesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('E-Learning Modules')),
      body: ResponsiveCenter(
        child: coursesAsync.when(
          loading: () => const LoadingView(label: 'Loading courses...'),
          error: (err, stack) => ErrorView(
            error: err,
            onRetry: () => ref.refresh(learningCoursesProvider),
          ),
          data: (courses) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(label: Text(course.category)),
                            const Spacer(),
                            if (course.isCompleted)
                              const Icon(
                                Icons.check_circle,
                                color: AppHrPalette.accent,
                              )
                            else
                              Text(
                                '${(course.completionPercentage * 100).toInt()}% Done',
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(course.description),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: course.completionPercentage,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () =>
                                context.push('/home/learning/${course.id}'),
                            icon: const Icon(Icons.play_circle_fill),
                            label: Text(
                              course.isCompleted
                                  ? 'Review Course'
                                  : 'Start Course',
                            ),
                          ),
                        ),
                      ],
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

class LearningDetailPage extends ConsumerWidget {
  const LearningDetailPage({required this.courseId, super.key});

  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(learningCourseDetailProvider(courseId));

    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: ResponsiveCenter(
        child: courseAsync.when(
          loading: () => const LoadingView(label: 'Loading course...'),
          error: (err, stack) => ErrorView(
            error: err,
            onRetry: () => ref.refresh(learningCourseDetailProvider(courseId)),
          ),
          data: (course) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(label: Text(course.category)),
                  const SizedBox(height: 16),
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(course.description),
                  const SizedBox(height: 24),
                  Text(
                    'Lessons (${course.lessonCount})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: course.lessonCount,
                      itemBuilder: (context, i) {
                        return ListTile(
                          leading: CircleAvatar(child: Text('${i + 1}')),
                          title: Text('Lesson ${i + 1}: Core Concepts'),
                          subtitle: const Text('10 mins • Video & Quiz'),
                          trailing: const Icon(Icons.play_arrow),
                          onTap: context.showComingSoon,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
