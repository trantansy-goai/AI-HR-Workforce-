import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/shared_workspace_header.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/application/auth_providers.dart';
import '../application/profile_providers.dart';
import '../domain/user_profile.dart';

/// Tab 5: My Profile root screen for employee account functions, workspace approvals, and settings.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SharedWorkspaceHeader(),
              Expanded(
                child: profile.when(
                  loading: () => const LoadingView(),
                  error: (error, _) => ErrorView(
                    failure: error is AppFailure ? error : null,
                    onRetry: () => ref.invalidate(currentProfileProvider),
                  ),
                  data: (p) => _ProfileView(profile: p),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileView extends ConsumerWidget {
  const _ProfileView({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Center(
          child: CircleAvatar(
            radius: 36,
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            child: Text(
              profile.initials,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          profile.displayName ??
              (profile.isGuest ? l10n.authGuestName : profile.email ?? ''),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Center(
          child: Chip(
            label: Text(profile.isGuest ? l10n.profileGuestBadge : 'Employee'),
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: Text(l10n.profileUserId),
                subtitle: Text(profile.id),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: Text(l10n.profileEmail),
                subtitle: Text(profile.email ?? l10n.profileNoEmail),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Workspace & Actions',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.approval_outlined),
                title: Text(l10n.profileApprovals),
                subtitle: const Text('Review and approve requests'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.approvals),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text(l10n.profileSettings),
                subtitle: const Text('Theme, language & system information'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.settings),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.logout, color: theme.colorScheme.error),
                title: Text(
                  l10n.authSignOut,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                onTap: () async {
                  final confirmed = await context.showConfirmDialog(
                    title: l10n.authSignOutConfirmTitle,
                    message: l10n.authSignOutConfirmMessage,
                    confirmLabel: l10n.authSignOut,
                    destructive: true,
                  );
                  if (confirmed) {
                    await ref.read(authControllerProvider.notifier).signOut();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
