import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/hr_widgets.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/presentation/change_password_dialog.dart';
import '../../news/application/news_providers.dart';
import '../../news/domain/news_item.dart';
import '../../notification/application/notification_providers.dart';
import '../application/profile_providers.dart';
import '../domain/user_profile.dart';

/// Tab 5: Tài khoản — one list on phones and tablets:
/// - Bản tin công ty (M09 · A4): audience filter, latest items, full list.
/// - Thông báo & tài khoản (M10 · A0 + A4): my notifications, the account
///   card and the language / security / sign-out menu.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);

    return HrScaffold(
      body: profile.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          failure: error is AppFailure ? error : null,
          onRetry: () => ref.invalidate(currentProfileProvider),
        ),
        data: (p) => HrPageBody(
          maxWidth: ContentConstraints.reading,
          children: [
            const _CompanyNewsSection(),
            const SizedBox(height: AppSpacing.xxl),
            const _NotificationsSection(),
            const SizedBox(height: AppSpacing.lg),
            _AccountSection(profile: p),
          ],
        ),
      ),
    );
  }
}

/// M09 — "Bản tin công ty" with audience filter tabs.
class _CompanyNewsSection extends ConsumerStatefulWidget {
  const _CompanyNewsSection();

  @override
  ConsumerState<_CompanyNewsSection> createState() =>
      _CompanyNewsSectionState();
}

class _CompanyNewsSectionState extends ConsumerState<_CompanyNewsSection> {
  /// Selected audience tag; null = all.
  String? _tag;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final newsAsync = ref.watch(newsListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HrPageTitle(l10n.profileNewsTitle),
        const SizedBox(height: AppSpacing.md),
        newsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: CircularProgressIndicator(color: AppHrPalette.accent),
            ),
          ),
          error: (_, _) =>
              ErrorView(onRetry: () => ref.invalidate(newsListProvider)),
          data: (items) {
            final tags = {for (final item in items) ...item.tags}.toList();
            final visible = _tag == null
                ? items
                : items.where((i) => i.tags.contains(_tag)).toList();
            final labels = [l10n.profileNewsAll, ...tags];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DefaultTabController(
                  // Rebuild the controller when the set of tags changes.
                  key: ValueKey(labels.length),
                  length: labels.length,
                  initialIndex: _tag == null ? 0 : tags.indexOf(_tag!) + 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppHrPalette.surface,
                      borderRadius: AppRadius.mdAll,
                      border: Border.all(color: AppHrPalette.border),
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.mdAll,
                      child: TabBar(
                        onTap: (i) =>
                            setState(() => _tag = i == 0 ? null : tags[i - 1]),
                        labelColor: AppHrPalette.accent,
                        unselectedLabelColor: AppHrPalette.inkMuted,
                        indicatorColor: AppHrPalette.accent,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: [for (final label in labels) Tab(text: label)],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                for (final item in visible.take(3)) ...[
                  _NewsCard(item: item),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            );
          },
        ),
        AppButton(
          label: l10n.profileNewsViewFull,
          variant: AppButtonVariant.tonal,
          onPressed: () => context.push(AppRoutes.news),
          expand: true,
        ),
        const SizedBox(height: AppSpacing.md),
        HrNoticeBox(text: l10n.profileNewsAckNote),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM').format(item.publishedAt);
    return HrCard(
      onTap: () => context.push(AppRoutes.article(item.id)),
      child: HrCardText(
        title: item.title,
        body: item.byline == null ? date : '${item.byline} · $date',
      ),
    );
  }
}

/// M10 — "Thông báo của tôi".
class _NotificationsSection extends ConsumerWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final notifications = ref.watch(notificationListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HrPageTitle(l10n.profileNotificationsTitle),
        const SizedBox(height: AppSpacing.md),
        if (notifications.isEmpty)
          HrCard(child: Text(l10n.notificationEmpty))
        else
          for (final n in notifications) ...[
            HrCard(
              onTap: n.deepLink == null ? null : () => context.go(n.deepLink!),
              child: HrCardText(title: n.title, body: n.body ?? ''),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
      ],
    );
  }
}

/// M10 — "TÀI KHOẢN" card, account menu and the push privacy note.
class _AccountSection extends ConsumerWidget {
  const _AccountSection({required this.profile});

  final UserProfile profile;

  /// "NV1042" → "NV••042": enough to recognise, not to copy.
  static String _maskId(String id) => id.length <= 5
      ? id
      : '${id.substring(0, 2)}••${id.substring(id.length - 3)}';

  Future<void> _openMenu(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final action = await showDialog<_AccountAction>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppHrPalette.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.profileAccountActions,
                        style: const TextStyle(
                          color: AppHrPalette.ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.commonClose,
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close, color: AppHrPalette.ink),
                    ),
                  ],
                ),
              ),
              for (final (action, icon, label) in [
                (
                  _AccountAction.settings,
                  Icons.translate,
                  l10n.profileLanguageSettings,
                ),
                (
                  _AccountAction.security,
                  Icons.shield_outlined,
                  l10n.profileSecurity,
                ),
                (
                  _AccountAction.approvals,
                  Icons.approval_outlined,
                  l10n.profileApprovals,
                ),
                (
                  _AccountAction.chats,
                  Icons.forum_outlined,
                  l10n.profileChatList,
                ),
              ])
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  leading: Icon(icon, color: AppHrPalette.accent),
                  title: Text(label),
                  onTap: () => Navigator.of(dialogContext).pop(action),
                ),
              const Divider(height: 1),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                ),
                leading: const Icon(Icons.logout, color: AppHrPalette.danger),
                title: Text(
                  l10n.authSignOut,
                  style: const TextStyle(color: AppHrPalette.danger),
                ),
                onTap: () =>
                    Navigator.of(dialogContext).pop(_AccountAction.signOut),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
    if (action == null || !context.mounted) return;

    switch (action) {
      case _AccountAction.settings:
        await context.push(AppRoutes.settings);
      case _AccountAction.approvals:
        await context.push(AppRoutes.approvals);
      case _AccountAction.chats:
        context.go(AppRoutes.chats);
      case _AccountAction.security:
        // Guests have no password to change.
        final canChangePassword =
            ref.read(authControllerProvider).user?.isAnonymous == false;
        final changePassword = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            icon: const Icon(
              Icons.shield_outlined,
              color: AppHrPalette.accent,
              size: 32,
            ),
            title: Text(l10n.authSecurityDialogTitle),
            content: Text(l10n.authSecurityDialogMessage),
            actions: [
              if (canChangePassword)
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(l10n.authChangePassword),
                ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.commonClose),
              ),
            ],
          ),
        );
        if ((changePassword ?? false) && context.mounted) {
          await showChangePasswordDialog(context);
        }
      case _AccountAction.signOut:
        final confirmed = await context.showConfirmDialog(
          title: l10n.authSignOutConfirmTitle,
          message: l10n.authSignOutConfirmMessage,
          confirmLabel: l10n.authSignOut,
          destructive: true,
        );
        if (confirmed) {
          await ref.read(authControllerProvider.notifier).signOut();
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final name =
        profile.displayName ??
        (profile.isGuest ? l10n.authGuestName : profile.email ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HrEyebrow(l10n.profileAccountSection),
        const SizedBox(height: AppSpacing.sm),
        HrCard(
          child: HrCardText(
            title: name,
            body: l10n.profileEmployeeMeta(_maskId(profile.id)),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: l10n.profileAccountActions,
          variant: AppButtonVariant.tonal,
          onPressed: () => _openMenu(context, ref),
          expand: true,
        ),
        const SizedBox(height: AppSpacing.md),
        HrNoticeBox(text: l10n.profilePushNote, warning: true),
      ],
    );
  }
}

enum _AccountAction { settings, security, approvals, chats, signOut }
