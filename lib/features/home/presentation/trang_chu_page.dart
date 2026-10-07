import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/shared_workspace_header.dart';
import '../../../shared/widgets/state_views.dart';
import '../../news/application/news_providers.dart';

/// Tab 1: Trang chủ (Workspace Dashboard)
/// Provides employee greeting, enterprise workspace identity, quota status,
/// notification bell, quick overview shortcuts, pending work/learning cards,
/// and internal company news (Bản tin mới).
class TrangChuPage extends ConsumerWidget {
  const TrangChuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final newsAsync = ref.watch(newsListProvider);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SharedWorkspaceHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Pending tasks strip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.4,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              l10n.homePendingTasksStrip(2),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Quick action shortcut chips
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: [
                        ActionChip(
                          avatar: const Icon(
                            Icons.question_answer_outlined,
                            size: 16,
                          ),
                          label: Text(l10n.askHrPolicyChip),
                          onPressed: () => context.go(AppRoutes.askHr),
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.add_task_outlined, size: 16),
                          label: Text(l10n.myWorkTitle),
                          onPressed: () => context.go(AppRoutes.myWork),
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.school_outlined, size: 16),
                          label: Text(l10n.mainNavLearning),
                          onPressed: () => context.go(AppRoutes.learning),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Card 1: Việc sắp đến hạn (A3)
                    _DashboardCard(
                      title: l10n.homeUpcomingWork,
                      subtitle: 'Hoàn tất checklist nhận việc · hạn 10/10',
                      badge: 'A3',
                      badgeColor: Colors.amber.shade100,
                      badgeTextColor: Colors.brown.shade900,
                      onTap: () => context.go(AppRoutes.myWork),
                    ),

                    // Card 2: Khóa học của tôi (A7)
                    _DashboardCard(
                      title: l10n.homeMyCourses,
                      subtitle: 'An toàn lao động cơ bản · còn 12 phút',
                      badge: 'A7',
                      badgeColor: Colors.purple.shade100,
                      badgeTextColor: Colors.purple.shade900,
                      onTap: () => context.go(AppRoutes.learning),
                    ),

                    // Card 3: Yêu cầu HR #HR-1042 (A0)
                    _DashboardCard(
                      title: l10n.homePendingCase,
                      subtitle: 'Đang chờ HR phản hồi · dự kiến 09/10',
                      badge: 'A0',
                      badgeColor: theme.colorScheme.primaryContainer,
                      badgeTextColor: theme.colorScheme.onPrimaryContainer,
                      onTap: () => context.go(AppRoutes.myWork),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Section: BẢN TIN MỚI
                    Row(
                      children: [
                        Text(
                          l10n.homeNewsSection,
                          style: theme.textTheme.labelLarge?.copyWith(
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.news),
                          child: Text(l10n.homeViewAllNews),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    newsAsync.when(
                      loading: () =>
                          const LoadingView(label: 'Đang tải bản tin...'),
                      error: (err, _) => ErrorView(
                        message: err.toString(),
                        onRetry: () => ref.refresh(newsListProvider),
                      ),
                      data: (newsItems) {
                        if (newsItems.isEmpty) {
                          return const Text('Chưa có bản tin nào.');
                        }
                        return Column(
                          children: [
                            for (final item in newsItems.take(2))
                              Card(
                                margin: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: ListTile(
                                  title: Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${item.summary}\n${item.publishedAt.toString().split(' ').first}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                  ),
                                  onTap: () =>
                                      context.push(AppRoutes.article(item.id)),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Chip(
                label: Text(badge),
                visualDensity: VisualDensity.compact,
                backgroundColor: badgeColor,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: badgeTextColor,
                ),
              ),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
