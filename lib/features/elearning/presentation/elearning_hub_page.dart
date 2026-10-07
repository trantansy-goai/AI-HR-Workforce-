import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/hr_widgets.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../../online_test/application/test_providers.dart';
import '../../online_test/domain/test_models.dart';
import '../application/learning_providers.dart';
import '../domain/learning_course.dart';

/// Tab 4: Học (Learning) in the GO AI HR frame, with two tabs:
/// - Khóa học đào tạo: "Học tập của tôi" (M08 · A7) — mandatory summary, the
///   course to continue, other assigned courses and the content-owner note.
/// - Bài kiểm tra chứng chỉ: certification tests.
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

    return HrScaffold(
      body: Column(
        children: [
          ColoredBox(
            color: AppHrPalette.surface,
            child: ResponsiveCenter(
              maxWidth: ContentConstraints.dashboard,
              child: TabBar(
                controller: _tabController,
                labelColor: AppHrPalette.accent,
                unselectedLabelColor: AppHrPalette.inkMuted,
                indicatorColor: AppHrPalette.accent,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppHrPalette.divider,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
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
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [_CoursesTabView(), _TestsTabView()],
            ),
          ),
        ],
      ),
    );
  }
}

String _dayMonth(DateTime date) => DateFormat('dd/MM').format(date);

/// "Video 12 phút · bài kiểm tra 8 câu · hạn 12/10" style meta line.
String _courseMeta(AppLocalizations l10n, LearningCourse course) {
  final parts = <String>[
    switch (course.format) {
      CourseFormat.video => l10n.learningVideoMinutes(course.durationMinutes),
      CourseFormat.document => l10n.learningDocMinutes(course.durationMinutes),
    },
    if (course.quizQuestionCount > 0)
      l10n.learningQuizQuestions(course.quizQuestionCount),
    if (course.isCompleted)
      l10n.learningCompletedStatus
    else if (course.completionPercentage == 0)
      l10n.learningNotStarted,
    if (course.dueDate != null && !course.isCompleted)
      l10n.learningDue(_dayMonth(course.dueDate!)),
  ];
  return parts.join(' · ');
}

/// Khóa học đào tạo — M08 "Học tập của tôi".
class _CoursesTabView extends ConsumerWidget {
  const _CoursesTabView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final coursesAsync = ref.watch(learningCoursesProvider);

    return coursesAsync.when(
      loading: () => const LoadingView(),
      error: (_, _) =>
          ErrorView(onRetry: () => ref.invalidate(learningCoursesProvider)),
      data: (courses) {
        final pending = courses.where((c) => !c.isCompleted).toList();
        final mandatory = pending.where((c) => c.isMandatory).toList()
          ..sort(
            (a, b) => (a.dueDate ?? DateTime(9999)).compareTo(
              b.dueDate ?? DateTime(9999),
            ),
          );
        final featured = mandatory.firstOrNull ?? pending.firstOrNull;
        final others = [
          for (final c in courses)
            if (c != featured) c,
        ];
        final nearestDue = mandatory.firstOrNull?.dueDate;

        return HrPageBody(
          children: [
            HrPageTitle(l10n.learningMyTitle),
            const SizedBox(height: AppSpacing.lg),
            HrNoticeBox(
              text: mandatory.isEmpty || nearestDue == null
                  ? l10n.learningNoMandatory
                  : l10n.learningMandatorySummary(
                      mandatory.length,
                      _dayMonth(nearestDue),
                    ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (courses.isEmpty)
              HrCard(child: Text(l10n.learningEmptyCourses))
            else ...[
              if (featured != null) ...[
                _CourseCard(course: featured),
                const SizedBox(height: AppSpacing.lg),
                _CourseProgress(course: featured),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: featured.completionPercentage > 0
                      ? l10n.learningContinue
                      : l10n.learningStart,
                  onPressed: () => context.push(AppRoutes.course(featured.id)),
                  expand: true,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              for (final course in others) ...[
                _CourseCard(course: course),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
            HrNoticeBox(text: l10n.learningPolicyNote, warning: true),
          ],
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
    final l10n = context.l10n;
    final (badge, background, foreground) = course.isMandatory
        ? (
            l10n.learningMandatoryBadge,
            AppHrPalette.amberSoft,
            AppHrPalette.amberInk,
          )
        : (
            l10n.learningModuleBadge,
            AppHrPalette.violetSoft,
            AppHrPalette.violetInk,
          );

    return HrCard(
      onTap: () => context.push(AppRoutes.course(course.id)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    color: AppHrPalette.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _courseMeta(l10n, course),
                  style: const TextStyle(
                    color: AppHrPalette.inkMuted,
                    fontSize: 13.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: foreground,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseProgress extends StatelessWidget {
  const _CourseProgress({required this.course});

  final LearningCourse course;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: course.completionPercentage,
            minHeight: 8,
            color: AppHrPalette.violetInk,
            backgroundColor: AppHrPalette.divider,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          context.l10n.learningProgress(
            (course.completionPercentage * 100).round(),
          ),
          style: const TextStyle(color: AppHrPalette.inkMuted, fontSize: 13.5),
        ),
      ],
    );
  }
}

/// Bài kiểm tra chứng chỉ — same content as before, restyled.
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
            final isTablet =
                constraints.maxWidth >= ResponsiveBreakpoints.tablet;
            final padding = EdgeInsets.all(
              isTablet ? AppSpacing.xl : AppSpacing.lg,
            );

            if (!isTablet) {
              return ListView.separated(
                padding: padding,
                itemCount: tests.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) => _TestCard(test: tests[index]),
              );
            }

            return ResponsiveCenter(
              maxWidth: ContentConstraints.dashboard,
              child: GridView.builder(
                padding: padding,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  mainAxisExtent: 150,
                ),
                itemCount: tests.length,
                itemBuilder: (context, index) => _TestCard(test: tests[index]),
              ),
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
    return HrCard(
      onTap: () => context.push(AppRoutes.test(test.id)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppHrPalette.accentSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: AppHrPalette.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppHrPalette.ink,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${test.totalQuestions} questions • ${test.timeLimitMinutes} mins\n${test.description}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppHrPalette.inkMuted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(64, 38),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              textStyle: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            onPressed: () => context.push(AppRoutes.test(test.id)),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}
