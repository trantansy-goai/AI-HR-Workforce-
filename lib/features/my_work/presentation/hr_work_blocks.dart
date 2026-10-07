import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/hr_widgets.dart';
import 'employee_work_blocks.dart';

// HR/Admin-role blocks of the Việc tab. Content is demo data until the
// approval / probation / A0 queue APIs exist.

/// Block 1 — M11 · A0 trình duyệt: items awaiting the approver. People
/// decide from evidence; there is deliberately no "approve all".
class ApprovalInboxBlock extends StatelessWidget {
  const ApprovalInboxBlock({super.key, required this.onOpenReview});

  /// Brings the probation review (block 2) into view.
  final VoidCallback onOpenReview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return HrCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HrEyebrow(l10n.hrApprovalsEyebrow),
          const SizedBox(height: AppSpacing.xs),
          _BlockTitle(l10n.hrApprovalsTitle),
          const SizedBox(height: AppSpacing.md),
          _ItemCard(
            title: l10n.hrApprovalProbationTitle,
            meta: l10n.hrApprovalProbationMeta,
            badge: WorkTag(
              l10n.hrApprovalProbationBadge,
              background: AppHrPalette.amberSoft,
              foreground: AppHrPalette.amberInk,
            ),
            onTap: onOpenReview,
          ),
          const SizedBox(height: AppSpacing.md),
          _ItemCard(
            title: l10n.hrApprovalChecklistTitle,
            meta: l10n.hrApprovalChecklistMeta,
            badge: WorkTag(
              l10n.hrApprovalChecklistBadge,
              background: AppHrPalette.infoSoft,
              foreground: AppHrPalette.infoInk,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          HrNoticeBox(text: l10n.hrApprovalsScopeNote),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: l10n.hrApprovalsOpenReview,
            onPressed: onOpenReview,
            expand: true,
          ),
          const SizedBox(height: AppSpacing.md),
          HrNoticeBox(text: l10n.hrApprovalsNoBulkNote, warning: true),
        ],
      ),
    );
  }
}

/// Block 2 — M12 · A3 chuẩn bị: gathers the probation evidence; the
/// decision stays with the approver.
class ProbationReviewBlock extends StatefulWidget {
  const ProbationReviewBlock({super.key});

  @override
  State<ProbationReviewBlock> createState() => _ProbationReviewBlockState();
}

class _ProbationReviewBlockState extends State<ProbationReviewBlock> {
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return HrCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BlockTitle(l10n.hrProbationTitle),
            const SizedBox(height: AppSpacing.md),
            HrCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Column(
                children: [
                  _EvidenceLine(text: l10n.hrProbationChecklist, done: true),
                  _EvidenceLine(text: l10n.hrProbationTraining, done: true),
                  _EvidenceLine(
                    text: l10n.hrProbationManagerOpinion,
                    done: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            HrNoticeBox(text: l10n.hrProbationMissingEvidence, warning: true),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _commentController,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.hrProbationCommentHint,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: l10n.hrProbationRequestMore,
              variant: AppButtonVariant.tonal,
              onPressed: context.showComingSoon,
              expand: true,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppHrPalette.amberInk,
                foregroundColor: Colors.white,
              ),
              onPressed: context.showComingSoon,
              child: Text(l10n.hrProbationEscalate),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.hrProbationDecisionNote,
              style: const TextStyle(
                color: AppHrPalette.inkMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Block 3 — M13 · A0: coordination queue on mobile — track overdue items
/// and exceptions; heavy work happens in the Web Workspace.
class CoordinationQueueBlock extends StatelessWidget {
  const CoordinationQueueBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return HrCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              WorkTag(
                l10n.hrQueueOverdue(3),
                background: AppHrPalette.amberSoft,
                foreground: AppHrPalette.amberInk,
              ),
              const Spacer(),
              WorkTag(
                l10n.hrQueuePending(8),
                background: AppHrPalette.infoSoft,
                foreground: AppHrPalette.infoInk,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final (title, meta) in [
            (l10n.hrQueueCase1Title, l10n.hrQueueCase1Meta),
            (l10n.hrQueueCase2Title, l10n.hrQueueCase2Meta),
            (l10n.hrQueueCase3Title, l10n.hrQueueCase3Meta),
          ]) ...[
            _ItemCard(title: title, meta: meta),
            const SizedBox(height: AppSpacing.md),
          ],
          AppButton(
            label: l10n.hrQueueOpenWeb,
            variant: AppButtonVariant.tonal,
            onPressed: context.showComingSoon,
            expand: true,
          ),
          const SizedBox(height: AppSpacing.md),
          HrNoticeBox(text: l10n.hrQueueMobileNote),
        ],
      ),
    );
  }
}

class _BlockTitle extends StatelessWidget {
  const _BlockTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppHrPalette.ink,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        height: 1.25,
      ),
    );
  }
}

/// Inner white card: bold title, muted meta line, optional status badge.
class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.title,
    required this.meta,
    this.badge,
    this.onTap,
  });

  final String title;
  final String meta;
  final Widget? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return HrCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppHrPalette.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  meta,
                  style: const TextStyle(
                    color: AppHrPalette.inkMuted,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null) ...[const SizedBox(width: AppSpacing.sm), badge!],
        ],
      ),
    );
  }
}

class _EvidenceLine extends StatelessWidget {
  const _EvidenceLine({required this.text, required this.done});

  final String text;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: done
                ? const Icon(Icons.check, size: 20, color: AppHrPalette.accent)
                : const Icon(
                    Icons.radio_button_unchecked,
                    size: 16,
                    color: AppHrPalette.inkMuted,
                  ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppHrPalette.ink, fontSize: 14.5),
            ),
          ),
        ],
      ),
    );
  }
}
