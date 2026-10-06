import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../application/notification_providers.dart';

class NotificationListPage extends ConsumerWidget {
  const NotificationListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final notifications = ref.watch(notificationListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationTitle)),
      body: ResponsiveCenter(
        child: notifications.isEmpty
            ? EmptyView(
                title: l10n.notificationEmpty,
                icon: Icons.notifications_none_outlined,
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: notifications.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: notif.deepLink != null
                          ? () => context.push(notif.deepLink!)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              foregroundColor:
                                  theme.colorScheme.onPrimaryContainer,
                              child: const Icon(
                                Icons.notifications_active_outlined,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notif.title,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if (notif.body != null) ...[
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      notif.body!,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                  if (notif.deepLink != null) ...[
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Tap to view details',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme.colorScheme.primary,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (notif.deepLink != null)
                              const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
