import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/l10n.dart';

/// Shell Scaffold providing persistent Material 3 bottom navigation across
/// the 5 main workspace branches: Timeline, Chat, E-learning, Document, My Profile.
class WorkspaceShell extends StatelessWidget {
  const WorkspaceShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
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
    );
  }
}
