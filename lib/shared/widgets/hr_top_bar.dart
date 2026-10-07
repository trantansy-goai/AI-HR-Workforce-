import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../core/localization/l10n.dart';
import '../../core/theme/app_tokens.dart';

/// White title bar from the GO AI HR mockups: title on the left, optional
/// back button and trailing actions, hairline bottom border.
class HrTopBar extends StatelessWidget {
  const HrTopBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.onBack,
  });

  final String title;
  final List<Widget> actions;

  /// Shows a back arrow before the title when set.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final isTablet =
        MediaQuery.sizeOf(context).width >= ResponsiveBreakpoints.tablet;
    final gutter = isTablet ? AppSpacing.xl : AppSpacing.lg;

    return Container(
      height: isTablet ? 64 : 56,
      padding: EdgeInsets.only(
        left: onBack == null ? gutter : AppSpacing.xs,
        right: actions.isEmpty ? gutter : AppSpacing.xs,
      ),
      decoration: const BoxDecoration(
        color: AppHrPalette.surface,
        border: Border(bottom: BorderSide(color: AppHrPalette.divider)),
      ),
      child: Row(
        children: [
          if (onBack != null)
            BackButton(color: AppHrPalette.ink, onPressed: onBack),
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppHrPalette.ink,
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

/// Teal bell with an unread dot that opens the notification list.
class HrNotificationButton extends StatelessWidget {
  const HrNotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.notificationTitle,
      onPressed: () => context.push(AppRoutes.notifications),
      icon: const Badge(
        smallSize: 7,
        backgroundColor: AppHrPalette.accent,
        child: Icon(
          Icons.notifications_none_rounded,
          color: AppHrPalette.accent,
        ),
      ),
    );
  }
}
