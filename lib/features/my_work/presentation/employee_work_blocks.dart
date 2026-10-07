import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/hr_widgets.dart';
import '../../../shared/widgets/state_views.dart';
import '../../file/application/file_providers.dart';
import '../application/my_work_providers.dart';
import '../domain/my_work_item.dart';

// Employee-role blocks of the Việc tab.

/// Block 1 — M06 · A0: where the latest case stands, without internal notes.
class CaseTrackingBlock extends ConsumerWidget {
  const CaseTrackingBlock({super.key, required this.onNewRequest});

  final VoidCallback onNewRequest;

  Future<void> _addDocuments(BuildContext context, WidgetRef ref) async {
    final picked = await ref.read(attachmentPickerProvider).pick();
    if (picked.isEmpty || !context.mounted) return;
    context.showAppSnackBar(
      context.l10n.myWorkCaseDocsAdded(picked.length),
      type: AppSnackType.success,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final casesAsync = ref.watch(caseTrackingListProvider);

    return HrCard(
      child: casesAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) =>
            ErrorView(onRetry: () => ref.invalidate(caseTrackingListProvider)),
        data: (cases) {
          final item = cases.firstOrNull;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (item == null)
                Text(
                  l10n.myWorkCasesEmpty,
                  style: const TextStyle(color: AppHrPalette.inkMuted),
                )
              else ...[
                Row(
                  children: [
                    WorkTag(
                      item.id,
                      background: AppHrPalette.infoSoft,
                      foreground: AppHrPalette.infoInk,
                    ),
                    const Spacer(),
                    Text(
                      l10n.myWorkCaseUpdated(item.updatedDate),
                      style: const TextStyle(
                        color: AppHrPalette.inkMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: AppHrPalette.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _CaseStepper(currentStep: item.currentStep),
                const SizedBox(height: AppSpacing.md),
                HrCard(
                  child: HrCardText(
                    title: item.stepLabel,
                    body: l10n.myWorkCaseStatusBody(item.expectedResponseDate),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                HrCard(
                  onTap: context.showComingSoon,
                  child: HrCardText(
                    title: l10n.myWorkCaseSecureTitle,
                    body: l10n.myWorkCaseSecureBody,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: l10n.myWorkCaseAddDocs,
                  variant: AppButtonVariant.tonal,
                  onPressed: () => _addDocuments(context, ref),
                  expand: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.myWorkCaseEscalationNote,
                  style: const TextStyle(
                    color: AppHrPalette.inkMuted,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: onNewRequest,
                icon: const Icon(Icons.add_comment_outlined, size: 18),
                label: Text(l10n.myWorkNewRequestButton),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Đã nhận → Đã giao → Đang xử lý → Hoàn tất. Steps before [currentStep]
/// are done; [currentStep] is active.
class _CaseStepper extends StatelessWidget {
  const _CaseStepper({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.myWorkStepReceived,
      l10n.myWorkStepAssigned,
      l10n.myWorkStepInProgress,
      l10n.myWorkStepDone,
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: _StepIndicator(
              number: i + 1,
              label: labels[i],
              isDone: i + 1 < currentStep,
              isActive: i + 1 == currentStep,
            ),
          ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.number,
    required this.label,
    required this.isDone,
    required this.isActive,
  });

  final int number;
  final String label;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final reached = isDone || isActive;
    return Semantics(
      label: label,
      selected: isActive,
      child: Column(
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: reached ? AppHrPalette.accentSoft : AppHrPalette.divider,
              border: Border.all(
                color: reached ? AppHrPalette.accent : AppHrPalette.border,
              ),
            ),
            child: isDone
                ? const Icon(Icons.check, size: 15, color: AppHrPalette.accent)
                : Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isActive
                          ? AppHrPalette.accent
                          : AppHrPalette.inkMuted,
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ExcludeSemantics(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppHrPalette.inkMuted,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Block 2 — M07 · A3 qua A0: what to do before day one and during
/// probation. Shows the first items; "Xem mục còn lại" expands the rest.
class OnboardingBlock extends ConsumerStatefulWidget {
  const OnboardingBlock({super.key});

  @override
  ConsumerState<OnboardingBlock> createState() => _OnboardingBlockState();
}

class _OnboardingBlockState extends ConsumerState<OnboardingBlock> {
  static const _previewCount = 4;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final checklistAsync = ref.watch(onboardingChecklistProvider);

    return HrCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HrEyebrow(l10n.myWorkOnboardingEyebrow),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.myWorkOnboardingRole,
            style: const TextStyle(
              color: AppHrPalette.ink,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.myWorkOnboardingTemplate,
            style: const TextStyle(
              color: AppHrPalette.inkMuted,
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          checklistAsync.when(
            loading: () => const LoadingView(),
            error: (_, _) => ErrorView(
              onRetry: () => ref.invalidate(onboardingChecklistProvider),
            ),
            data: (items) {
              final done = items.where((i) => i.isCompleted).length;
              final visible = _expanded ? items : items.take(_previewCount);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: items.isEmpty ? 0 : done / items.length,
                      minHeight: 8,
                      color: AppHrPalette.accent,
                      backgroundColor: AppHrPalette.divider,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.myWorkOnboardingProgress(done, items.length),
                    style: const TextStyle(
                      color: AppHrPalette.inkMuted,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  HrCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: Column(
                      children: [
                        for (final item in visible) _ChecklistLine(item: item),
                      ],
                    ),
                  ),
                  if (items.length > _previewCount) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: _expanded
                          ? l10n.myWorkOnboardingCollapse
                          : l10n.myWorkOnboardingShowRest,
                      onPressed: () => setState(() => _expanded = !_expanded),
                      expand: true,
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          HrNoticeBox(text: l10n.myWorkOnboardingEvidenceNote, warning: true),
        ],
      ),
    );
  }
}

/// Checklist row: brand-blue tick when confirmed, empty circle otherwise, plus
/// the owning team.
class _ChecklistLine extends StatelessWidget {
  const _ChecklistLine({required this.item});

  final OnboardingChecklistItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs + 2),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: item.isCompleted
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
              item.title,
              style: const TextStyle(color: AppHrPalette.ink, fontSize: 14.5),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          WorkTag(
            item.owner,
            background: AppHrPalette.surface,
            foreground: AppHrPalette.inkMuted,
            outlined: true,
          ),
        ],
      ),
    );
  }
}

/// Small rounded label (section tags, checklist owners).
class WorkTag extends StatelessWidget {
  const WorkTag(
    this.label, {
    super.key,
    required this.background,
    required this.foreground,
    this.outlined = false,
  });

  final String label;
  final Color background;
  final Color foreground;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: outlined ? Border.all(color: AppHrPalette.border) : null,
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: foreground,
          fontSize: outlined ? 10.5 : 11.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
