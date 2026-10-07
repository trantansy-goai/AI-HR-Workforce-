import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/shared_workspace_header.dart';
import '../../../shared/widgets/state_views.dart';
import '../../online_test/application/test_providers.dart';
import '../../online_test/domain/test_models.dart';
import '../application/learning_providers.dart';
import '../domain/learning_course.dart';

/// Tab 3: Unified E-learning Hub providing entry to both Courses and Certification Tests.
class ELearningHubPage extends ConsumerStatefulWidget {
  const ELearningHubPage({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  ConsumerState<ELearningHubPage> createState() => _ELearningHubPageState();
}

class _ELearningHubPageState extends ConsumerState<ELearningHubPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: ContentConstraints.dashboard,
          child: Column(
            children: [
              const SharedWorkspaceHeader(),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.school_outlined),
                    text: l10n.elearningCourses,
                  ),
                  Tab(
                    icon: const Icon(Icons.assignment_turned_in_outlined),
                    text: l10n.elearningTests,
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [_CoursesTabView(), _TestsTabView()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoursesTabView extends ConsumerWidget {
  const _CoursesTabView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(learningCoursesProvider);

    return coursesAsync.when(
      loading: () => const LoadingView(label: 'Loading courses...'),
      error: (err, _) => ErrorView(
        message: err.toString(),
        onRetry: () => ref.refresh(learningCoursesProvider),
      ),
      data: (courses) {
        if (courses.isEmpty) {
          return const EmptyView(
            title: 'No Courses Available',
            message: 'You have no assigned learning courses at this time.',
            icon: Icons.school_outlined,
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 960
                ? 3
                : constraints.maxWidth >= 600
                ? 2
                : 1;

            if (crossAxisCount == 1) {
              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: courses.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) =>
                    _CourseCard(course: courses[index]),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                mainAxisExtent: 190,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) =>
                  _CourseCard(course: courses[index]),
            );
          },
        );
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});

  final LearningCourse course;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.course(course.id)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Chip(
                    label: Text(course.category),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Spacer(),
                  if (course.isCompleted)
                    const Icon(Icons.check_circle, color: Colors.green)
                  else
                    Text(
                      '${(course.completionPercentage * 100).toInt()}% Done',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                course.title,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                course.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(
                value: course.completionPercentage,
                borderRadius: AppRadius.smAll,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestsTabView extends ConsumerWidget {
  const _TestsTabView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testsAsync = ref.watch(onlineTestsProvider);

    return testsAsync.when(
      loading: () => const LoadingView(label: 'Loading certification tests...'),
      error: (err, _) => ErrorView(
        message: err.toString(),
        onRetry: () => ref.refresh(onlineTestsProvider),
      ),
      data: (tests) {
        if (tests.isEmpty) {
          return const EmptyView(
            title: 'No Tests Assigned',
            message: 'You have completed all pending certification exams.',
            icon: Icons.assignment_turned_in_outlined,
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMultiColumn = constraints.maxWidth >= 600;

            if (!isMultiColumn) {
              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: tests.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) => _TestCard(test: tests[index]),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                mainAxisExtent: 130,
              ),
              itemCount: tests.length,
              itemBuilder: (context, index) => _TestCard(test: tests[index]),
            );
          },
        );
      },
    );
  }
}

class _TestCard extends StatelessWidget {
  const _TestCard({required this.test});

  final OnlineTest test;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.secondaryContainer,
            foregroundColor: theme.colorScheme.onSecondaryContainer,
            child: const Icon(Icons.assignment_outlined),
          ),
          title: Text(
            test.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${test.totalQuestions} questions • ${test.timeLimitMinutes} mins\n${test.description}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          isThreeLine: true,
          trailing: ElevatedButton(
            onPressed: () => context.push(AppRoutes.test(test.id)),
            child: const Text('Start'),
          ),
        ),
      ),
    );
  }
}
