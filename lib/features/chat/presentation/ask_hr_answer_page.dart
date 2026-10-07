import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/hr_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/hr_top_bar.dart';
import '../../../shared/widgets/hr_widgets.dart';
import 'widgets/hr_answer_widgets.dart';

/// M04 · A4 — answer with an approved source, so employees can check the
/// content and its effective date. "Tạo yêu cầu HR" switches to the Việc
/// tab and opens the request dialog (M05).
class AskHrAnswerPage extends StatelessWidget {
  const AskHrAnswerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isTablet =
        MediaQuery.sizeOf(context).width >= ResponsiveBreakpoints.tablet;

    return Theme(
      data: hrScopedTheme(Theme.of(context)),
      child: Scaffold(
        backgroundColor: AppHrPalette.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HrTopBar(
                title: l10n.homeAppBarTitle,
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go(AppRoutes.askHr),
                actions: const [HrNotificationButton()],
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? AppSpacing.xl : AppSpacing.lg,
                    vertical: isTablet ? AppSpacing.xxl : AppSpacing.xl,
                  ),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            HrPageTitle(l10n.askHrAnswerTitle, large: isTablet),
                            const SizedBox(height: AppSpacing.lg),
                            HrChatBubble(
                              text: l10n.askHrAnswerBody,
                              fromUser: false,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            const _SourceCard(),
                            const SizedBox(height: AppSpacing.lg),
                            HrNoticeBox(
                              text: l10n.askHrSourceWarning,
                              warning: true,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppButton(
                              label: l10n.askHrOpenSource,
                              variant: AppButtonVariant.tonal,
                              onPressed: () =>
                                  context.push(AppRoutes.documents),
                              expand: true,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppButton(
                              label: l10n.askHrCreateRequest,
                              onPressed: () =>
                                  context.go(AppRoutes.myWorkNewRequest),
                              expand: true,
                            ),
                          ],
                        ),
                      ),
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

/// "NGUỒN ĐƯỢC DUYỆT" card: document, version, effective date, owner and
/// where it lives in the company library.
class _SourceCard extends StatelessWidget {
  const _SourceCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppHrPalette.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppHrPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.askHrSourceEyebrow,
            style: const TextStyle(
              color: AppHrPalette.accent,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.askHrSourceTitle,
            style: const TextStyle(
              color: AppHrPalette.ink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.askHrSourceMeta,
            style: const TextStyle(
              color: AppHrPalette.inkMuted,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.only(left: AppSpacing.md),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppHrPalette.ink, width: 2),
              ),
            ),
            child: Text(
              l10n.askHrSourcePath,
              style: const TextStyle(
                color: AppHrPalette.inkMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
