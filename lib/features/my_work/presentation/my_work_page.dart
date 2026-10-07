import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/hr_widgets.dart';
import '../../../shared/widgets/responsive.dart';
import '../application/my_work_providers.dart';
import '../domain/my_work_item.dart';
import 'employee_work_blocks.dart';
import 'hr_work_blocks.dart';
import 'new_hr_request_dialog.dart';

/// Tab 3: Việc của tôi (My Work), in the GO AI HR frame. The layout depends
/// on [workRoleProvider]:
/// - Employee: case tracking (M06) and onboarding checklist (M07); "Gửi yêu
///   cầu HR mới" opens the request dialog (M05).
/// - HR/Admin: approval inbox (M11), probation review (M12) and the A0
///   coordination queue (M13).
///
/// [openNewRequest] opens the M05 dialog on arrival (e.g. from Hỏi HR's
/// "Tạo yêu cầu HR"). Both roles show their blocks as a single list on
/// phones and tablets.
class MyWorkPage extends ConsumerStatefulWidget {
  const MyWorkPage({super.key, this.openNewRequest = false});

  final bool openNewRequest;

  @override
  ConsumerState<MyWorkPage> createState() => _MyWorkPageState();
}

class _MyWorkPageState extends ConsumerState<MyWorkPage> {
  final _reviewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.openNewRequest) _scheduleNewRequest();
  }

  @override
  void didUpdateWidget(MyWorkPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openNewRequest && !oldWidget.openNewRequest) {
      _scheduleNewRequest();
    }
  }

  void _scheduleNewRequest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Drop the query so the dialog doesn't reopen on rebuild/back.
      context.go(AppRoutes.myWork);
      _openNewRequest();
    });
  }

  Future<void> _openNewRequest() async {
    final created = await showNewHrRequestDialog(context);
    if (created == null || !mounted) return;
    context.showAppSnackBar(
      context.l10n.myWorkRequestSubmitted(created.id),
      type: AppSnackType.success,
    );
  }

  void _showReview() {
    final target = _reviewKey.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(workRoleProvider);
    final showRoleSwitch = ref.watch(appConfigProvider).useFakeBackend;

    return HrScaffold(
      body: ResponsiveCenter(
        maxWidth: ContentConstraints.dashboard,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 720;
            final blocks = switch (role) {
              WorkRole.employee => _employeeBlocks(),
              WorkRole.hrAdmin => _hrBlocks(),
            };
            return ListView(
              padding: EdgeInsets.all(isTablet ? AppSpacing.lg : AppSpacing.md),
              children: [
                if (showRoleSwitch) ...[
                  const _RoleSwitch(),
                  const SizedBox(height: AppSpacing.md),
                ],
                blocks,
              ],
            );
          },
        ),
      ),
    );
  }

  /// Employee blocks are a single list on every width, like on phones.
  Widget _employeeBlocks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CaseTrackingBlock(onNewRequest: _openNewRequest),
        const SizedBox(height: AppSpacing.lg),
        const OnboardingBlock(),
      ],
    );
  }

  /// HR/Admin blocks are a single list on every width, like on phones.
  Widget _hrBlocks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ApprovalInboxBlock(onOpenReview: _showReview),
        const SizedBox(height: AppSpacing.lg),
        ProbationReviewBlock(key: _reviewKey),
        const SizedBox(height: AppSpacing.lg),
        const CoordinationQueueBlock(),
      ],
    );
  }
}

/// Demo-only role picker (fake backend) so both Việc layouts can be shown.
class _RoleSwitch extends ConsumerWidget {
  const _RoleSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final role = ref.watch(workRoleProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.myWorkRoleDemoHint,
          style: const TextStyle(color: AppHrPalette.inkMuted, fontSize: 12.5),
        ),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<WorkRole>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: WorkRole.employee,
              label: Text(l10n.myWorkRoleEmployee),
            ),
            ButtonSegment(
              value: WorkRole.hrAdmin,
              label: Text(l10n.myWorkRoleHrAdmin),
            ),
          ],
          selected: {role},
          onSelectionChanged: (s) =>
              ref.read(workRoleProvider.notifier).select(s.first),
        ),
      ],
    );
  }
}
