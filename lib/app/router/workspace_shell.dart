import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/l10n.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/app_feedback.dart';
import '../../shared/widgets/responsive.dart';

/// Shell Scaffold providing adaptive navigation across the 5 approved
/// workspace destinations:
/// - Compact/phone (< 600dp): Material 3 Bottom NavigationBar
/// - Tablet (>= 600dp): Side NavigationRail with GoAI brand header
///
/// System back on a tab root goes to Trang chủ; on Trang chủ the first press
/// shows a hint and a second press within [exitConfirmWindow] closes the app.
class WorkspaceShell extends StatefulWidget {
  const WorkspaceShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const exitConfirmWindow = Duration(seconds: 2);

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  DateTime? _lastBackPress;

  void _onBack() {
    final shell = widget.navigationShell;
    if (shell.currentIndex != 0) {
      shell.goBranch(0);
      return;
    }
    final now = DateTime.now();
    final last = _lastBackPress;
    if (last != null &&
        now.difference(last) <= WorkspaceShell.exitConfirmWindow) {
      SystemNavigator.pop();
      return;
    }
    _lastBackPress = now;
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
    context.showAppSnackBar(context.l10n.commonPressBackAgainToExit);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onBack();
      },
      child: _buildShell(context),
    );
  }

  Widget _buildShell(BuildContext context) {
    final l10n = context.l10n;
    final navigationShell = widget.navigationShell;

    if (context.isTablet) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              labelType: NavigationRailLabelType.all,
              backgroundColor: AppHrPalette.surface,
              indicatorColor: AppHrPalette.accentSoft,
              selectedIconTheme: const IconThemeData(
                color: AppHrPalette.accent,
              ),
              unselectedIconTheme: const IconThemeData(
                color: AppHrPalette.inkMuted,
              ),
              selectedLabelTextStyle: const TextStyle(
                color: AppHrPalette.accent,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
              unselectedLabelTextStyle: const TextStyle(
                color: AppHrPalette.inkMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Image.asset(
                  'assets/images/goai_logo.png',
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: Text(l10n.mainNavHome),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.forum_outlined),
                  selectedIcon: const Icon(Icons.forum),
                  label: Text(l10n.mainNavAskHr),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.checklist_outlined),
                  selectedIcon: const Icon(Icons.checklist),
                  label: Text(l10n.mainNavMyWork),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.school_outlined),
                  selectedIcon: const Icon(Icons.school),
                  label: Text(l10n.mainNavLearning),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: Text(l10n.mainNavAccount),
                ),
              ],
            ),
            const VerticalDivider(
              thickness: 1,
              width: 1,
              color: AppHrPalette.divider,
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _MockupNavigationTheme(
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l10n.mainNavHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.forum_outlined),
              selectedIcon: const Icon(Icons.forum),
              label: l10n.mainNavAskHr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.checklist_outlined),
              selectedIcon: const Icon(Icons.checklist),
              label: l10n.mainNavMyWork,
            ),
            NavigationDestination(
              icon: const Icon(Icons.school_outlined),
              selectedIcon: const Icon(Icons.school),
              label: l10n.mainNavLearning,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: l10n.mainNavAccount,
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom bar styled after the GO AI HR mockups: white bar with a hairline
/// top border, no selection pill, brand-blue icon + label for the active tab.
class _MockupNavigationTheme extends StatelessWidget {
  const _MockupNavigationTheme({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    WidgetStateProperty<T> bySelection<T>(T selected, T idle) =>
        WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? selected : idle,
        );

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppHrPalette.divider)),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 64,
          elevation: 0,
          backgroundColor: AppHrPalette.surface,
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          iconTheme: bySelection(
            const IconThemeData(color: AppHrPalette.accent, size: 24),
            const IconThemeData(color: AppHrPalette.inkMuted, size: 24),
          ),
          labelTextStyle: bySelection(
            const TextStyle(
              color: AppHrPalette.accent,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
            const TextStyle(
              color: AppHrPalette.inkMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
