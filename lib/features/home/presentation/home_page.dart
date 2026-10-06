import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/responsive.dart';
import '../../auth/application/auth_providers.dart';
import '../../quota/presentation/quota_card.dart';

/// Dashboard landing page for GOAI Mobile Phase 1.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final user = ref.watch(authControllerProvider).user;
    final name = user == null || user.isAnonymous
        ? l10n.authGuestName
        : user.displayName ?? user.email ?? l10n.authGuestName;

    final items = const [
      _HomeItem(
        Icons.forum_outlined,
        'AI Chat & Agents',
        'Chat with Open WebUI assistant & enterprise agents',
        AppRoutes.chat,
      ),
      _HomeItem(
        Icons.folder_shared_outlined,
        'Knowledge Documents',
        'Access company policies and onboarding files',
        AppRoutes.documents,
      ),
      _HomeItem(
        Icons.school_outlined,
        'E-Learning',
        'Complete interactive security & AI training',
        AppRoutes.learning,
      ),
      _HomeItem(
        Icons.assignment_turned_in_outlined,
        'Online Tests',
        'Take compliance and knowledge exams',
        AppRoutes.tests,
      ),
      _HomeItem(
        Icons.newspaper_outlined,
        'Company News',
        'Latest announcements and platform updates',
        AppRoutes.news,
      ),
      _HomeItem(
        Icons.approval_outlined,
        'Approvals',
        'Review and approve pending employee requests',
        AppRoutes.approvals,
      ),
      _HomeItem(
        Icons.person_outline,
        'My Profile',
        'View user account identity and roles',
        AppRoutes.profile,
      ),
      _HomeItem(
        Icons.settings_outlined,
        'Settings',
        'App theme, language, and configuration',
        AppRoutes.settings,
      ),
    ];

    final columns = switch (context.windowSize) {
      WindowSize.compact => 1,
      WindowSize.medium => 2,
      WindowSize.expanded => 3,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('GOAI Workplace')),
      body: ResponsiveCenter(
        maxWidth: 1100,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeGreeting(name),
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text('Enterprise AI Assistant & Employee Workspace'),
                    const SizedBox(height: AppSpacing.md),
                    const QuotaUsageCard(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const gap = AppSpacing.md;
                    final width =
                        (constraints.maxWidth - gap * (columns - 1)) / columns;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (final item in items)
                          SizedBox(
                            width: width,
                            child: _HomeCard(item: item),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeItem {
  const _HomeItem(this.icon, this.title, this.subtitle, this.route);

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({required this.item});

  final _HomeItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(item.route),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                child: Icon(item.icon),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.subtitle,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
