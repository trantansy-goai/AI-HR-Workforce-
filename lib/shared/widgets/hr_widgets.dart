import 'package:flutter/material.dart';

import '../../core/localization/l10n.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/hr_theme.dart';
import 'hr_top_bar.dart';

/// Tinted rounded box for guidance (brand-blue) or caution (amber) copy.
class HrNoticeBox extends StatelessWidget {
  const HrNoticeBox({super.key, required this.text, this.warning = false});

  final String text;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: warning ? AppHrPalette.warningSoft : AppHrPalette.accentSoft,
        borderRadius: hrBoxRadius,
        border: warning ? Border.all(color: AppHrPalette.warningBorder) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: warning ? AppHrPalette.warningInk : AppHrPalette.ink,
          fontSize: 13.5,
          height: 1.45,
        ),
      ),
    );
  }
}

/// Large bold page heading used by the Hỏi HR screens.
class HrPageTitle extends StatelessWidget {
  const HrPageTitle(this.text, {super.key, this.large = false});

  final String text;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: TextStyle(
          color: AppHrPalette.ink,
          fontSize: large ? 30 : 26,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    );
  }
}

/// Small uppercase brand-blue label above a title or section.
class HrEyebrow extends StatelessWidget {
  const HrEyebrow(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppHrPalette.accent,
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }
}

/// White bordered card from the HR mockups; tappable when [onTap] is set.
class HrCard extends StatelessWidget {
  const HrCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppHrPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: AppHrPalette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Title + muted body pair used inside [HrCard]s.
class HrCardText extends StatelessWidget {
  const HrCardText({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          body,
          style: const TextStyle(
            color: AppHrPalette.inkMuted,
            fontSize: 14,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

/// Body for an HR mockup screen: scrolls, applies phone/tablet gutters and
/// caps the content width so tablets keep a readable column.
class HrPageBody extends StatelessWidget {
  const HrPageBody({super.key, required this.children, this.maxWidth = 640});

  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final isTablet =
        MediaQuery.sizeOf(context).width >= ResponsiveBreakpoints.tablet;
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? AppSpacing.xl : AppSpacing.lg,
        vertical: isTablet ? AppSpacing.xxl : AppSpacing.xl,
      ),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

/// Screen frame shared by the GO AI HR mockups: brand-blue-scoped theme, light
/// background, "GO AI · HR" top bar with the notification bell, then [body].
class HrScaffold extends StatelessWidget {
  const HrScaffold({super.key, required this.body, this.onBack});

  final Widget body;

  /// Shows a back arrow in the top bar when set.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: hrScopedTheme(Theme.of(context)),
      child: Scaffold(
        backgroundColor: AppHrPalette.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HrTopBar(
                title: context.l10n.homeAppBarTitle,
                onBack: onBack,
                actions: const [HrNotificationButton()],
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
