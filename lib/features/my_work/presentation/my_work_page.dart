import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/shared_workspace_header.dart';
import '../../../shared/widgets/state_views.dart';
import '../../approval/application/approval_providers.dart';
import '../application/my_work_providers.dart';
import '../domain/my_work_item.dart';

/// Tab 3: Việc của tôi (My Work) root screen.
/// Includes Onboarding Checklist (A3), My Cases & Requests (A0/A4),
/// and Permission-aware Approval Inbox (M11).
class MyWorkPage extends ConsumerWidget {
  const MyWorkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final checklistAsync = ref.watch(onboardingChecklistProvider);
    final casesAsync = ref.watch(caseTrackingListProvider);
    final hasApprovalPermission = ref.watch(hasApprovalPermissionProvider);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: ContentConstraints.dashboard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SharedWorkspaceHeader(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth >= 720;

                    if (isTablet) {
                      return ListView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left column: Checklist hội nhập
                              Expanded(
                                flex: 5,
                                child: _buildChecklistSection(
                                  context,
                                  ref,
                                  checklistAsync,
                                  l10n,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              // Right column: Cases & Approvals
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildCasesSection(
                                      context,
                                      ref,
                                      casesAsync,
                                      l10n,
                                    ),
                                    if (hasApprovalPermission) ...[
                                      const SizedBox(height: AppSpacing.lg),
                                      _buildApprovalsSection(
                                        context,
                                        ref,
                                        l10n,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      children: [
                        // Section 1: Checklist hội nhập
                        _buildChecklistSection(
                          context,
                          ref,
                          checklistAsync,
                          l10n,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Section 2: Case & Yêu cầu của tôi
                        _buildCasesSection(context, ref, casesAsync, l10n),
                        const SizedBox(height: AppSpacing.lg),

                        // Section 3: Chờ tôi phê duyệt (Permission-aware)
                        if (hasApprovalPermission) ...[
                          _buildApprovalsSection(context, ref, l10n),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<OnboardingChecklistItem>> checklistAsync,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Chip(
                    label: const Text(
                      'A3 · HỘI NHẬP',
                      overflow: TextOverflow.ellipsis,
                    ),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '3/5 mục đã xác nhận',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Nhân viên vận hành · Nhà máy A',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Template vị trí + địa điểm · đã được HR duyệt',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.6,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            checklistAsync.when(
              loading: () => const LoadingView(label: 'Đang tải checklist...'),
              error: (err, _) => ErrorView(
                message: err.toString(),
                onRetry: () => ref.refresh(onboardingChecklistProvider),
              ),
              data: (items) {
                return Column(
                  children: [
                    for (final item in items)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              item.isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              size: 18,
                              color: item.isCompleted
                                  ? Colors.teal
                                  : theme.colorScheme.outline,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                item.title,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: item.isCompleted
                                      ? theme.colorScheme.onSurface
                                      : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: item.isCompleted
                                      ? FontWeight.normal
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(item.owner),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              labelStyle: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCasesSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<CaseTrackingItem>> casesAsync,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Chip(
                    label: const Text(
                      'A0 + A4 · CASE & YÊU CẦU',
                      overflow: TextOverflow.ellipsis,
                    ),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '#HR-1042',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Xác nhận thông tin cá nhân',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Đang chờ HR xác minh · dự kiến phản hồi 09/10',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Steps tracker
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _StepIndicator(label: 'Đã nhận', isDone: true),
                  _StepIndicator(label: 'Đã giao', isDone: true),
                  _StepIndicator(
                    label: 'Đang xử lý',
                    isDone: false,
                    isActive: true,
                  ),
                  _StepIndicator(label: 'Hoàn tất', isDone: false),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () {
                context.push(AppRoutes.askHr);
              },
              icon: const Icon(Icons.add_comment_outlined, size: 18),
              label: const Text('Gửi yêu cầu HR mới'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalsSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final approvalsAsync = ref.watch(approvalListProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Chip(
                    label: const Text(
                      'DÀNH CHO NGƯỜI CÓ QUYỀN',
                      overflow: TextOverflow.ellipsis,
                    ),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Colors.amber.shade100,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade900,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton(
                  onPressed: () => context.push(AppRoutes.approvals),
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Chờ tôi phê duyệt',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Quyền duyệt theo vị trí, đơn vị và thẩm quyền.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            approvalsAsync.when(
              loading: () => const LoadingView(label: 'Đang tải phê duyệt...'),
              error: (err, _) => ErrorView(
                message: err.toString(),
                onRetry: () => ref.refresh(approvalListProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const Text('Không có yêu cầu chờ duyệt.');
                }
                return Column(
                  children: [
                    for (final item in items.take(2))
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.assignment_late_outlined,
                          color: Colors.orange,
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${item.requesterName} · ${item.status.name.toUpperCase()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                        onTap: () => context.push(AppRoutes.approvals),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.label,
    required this.isDone,
    this.isActive = false,
  });

  final String label;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: isDone
              ? Colors.teal
              : isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          child: isDone
              ? const Icon(Icons.check, size: 12, color: Colors.white)
              : Text(
                  isActive ? '3' : '○',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : Colors.grey,
                  ),
                ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isDone || isActive
                ? FontWeight.bold
                : FontWeight.normal,
            color: isDone || isActive
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
