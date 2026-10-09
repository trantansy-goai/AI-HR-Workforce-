import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/hr_top_bar.dart';
import '../../auth/application/auth_providers.dart';
import '../../my_work/application/my_work_providers.dart';
import '../../news/application/news_providers.dart';
import '../../news/domain/news_item.dart';
import '../../quota/application/quota_providers.dart';

const _cardRadius = BorderRadius.all(Radius.circular(14));

/// Tab 1: Trang chủ (M02 · A0) — single entry point for the employee:
/// date + greeting, weekly task summary, quick actions, AI token quota,
/// pending work/learning/HR-request cards and the latest company news.
///
/// Phones show one column; tablets (>=600dp) put the greeting next to the
/// quota card and lay the cards and news out in a grid.
class TrangChuPage extends ConsumerWidget {
  const TrangChuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppHrPalette.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet =
                constraints.maxWidth >= ResponsiveBreakpoints.tablet;
            return Column(
              children: [
                HrTopBar(
                  title: context.l10n.homeAppBarTitle,
                  actions: const [HrNotificationButton()],
                ),
                Expanded(
                  child: isTablet
                      ? const _TabletDashboard()
                      : const _PhoneDashboard(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PhoneDashboard extends StatelessWidget {
  const _PhoneDashboard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        const _Hero(),
        const SizedBox(height: AppSpacing.md),
        const _QuotaCard(),
        const SizedBox(height: AppSpacing.md),
        for (final card in _overviewCards(context)) ...[
          card,
          const SizedBox(height: AppSpacing.md),
        ],
        const _NewsSection(columns: 1),
      ],
    );
  }
}

class _TabletDashboard extends StatelessWidget {
  const _TabletDashboard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final wide = width >= ResponsiveBreakpoints.wideTablet;
        final cards = _overviewCards(context);

        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? AppSpacing.xxl : AppSpacing.xl,
            vertical: AppSpacing.xl,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: ContentConstraints.dashboard,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (wide)
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _Hero(large: true)),
                          SizedBox(width: AppSpacing.xl),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.only(top: AppSpacing.xl),
                              child: _QuotaCard(),
                            ),
                          ),
                        ],
                      )
                    else
                      const _Hero(large: true),
                    const SizedBox(height: AppSpacing.xl),
                    // Portrait tablets fold the quota into a tidy 2x2 grid.
                    _Grid(
                      columns: wide ? 3 : 2,
                      children: wide ? cards : [const _QuotaCard(), ...cards],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _NewsSection(columns: wide ? 3 : 2),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Date, greeting, weekly summary and quick actions.
class _Hero extends StatelessWidget {
  const _Hero({this.large = false});

  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Greeting(large: large),
        const SizedBox(height: AppSpacing.md),
        const _PendingTasksBox(),
        const SizedBox(height: AppSpacing.sm),
        const _QuickActions(),
      ],
    );
  }
}

List<Widget> _overviewCards(BuildContext context) {
  final l10n = context.l10n;
  return [
    const _UpcomingWorkCard(),
    _OverviewCard(
      title: l10n.homeMyCourses,
      subtitle: l10n.homeMyCoursesDetail,
      badge: 'A7',
      badgeBackground: AppHrPalette.violetSoft,
      badgeForeground: AppHrPalette.violetInk,
      onTap: () => context.go(AppRoutes.learning),
    ),
    _OverviewCard(
      title: l10n.homePendingCase,
      subtitle: l10n.homePendingCaseDetail,
      badge: 'A0',
      badgeBackground: AppHrPalette.infoSoft,
      badgeForeground: AppHrPalette.infoInk,
      onTap: () => context.go(AppRoutes.myWork),
    ),
  ];
}

/// Rows of equal-width cells; the last row is left-aligned.
class _Grid extends StatelessWidget {
  const _Grid({required this.columns, required this.children});

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: AppSpacing.md));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var c = 0; c < columns; c++) ...[
                if (c > 0) const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: i + c < children.length
                      ? children[i + c]
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

/// "THỨ TƯ, 07/10" eyebrow and "Chào {name} 👋" title.
class _Greeting extends ConsumerWidget {
  const _Greeting({this.large = false});

  final bool large;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(authControllerProvider).user;
    final name = user == null || user.isAnonymous
        ? l10n.authGuestName
        : user.displayName ?? user.email ?? l10n.authGuestName;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat('EEEE, dd/MM', locale).format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date.toUpperCase(),
          style: TextStyle(
            color: AppHrPalette.accent,
            fontSize: large ? 14 : 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.homeHeroGreeting(name),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppHrPalette.ink,
            fontSize: large ? 30 : 26,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

/// "Bạn có **2 việc** cần hoàn thành tuần này." With a calendar, the count
/// is this week's calendar items; demo builds show a sample count.
class _PendingTasksBox extends ConsumerWidget {
  const _PendingTasksBox();

  static const _demoCount = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final endOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: DateTime.daysPerWeek - now.weekday + 1));
    final pendingCount = switch (ref.watch(upcomingScheduleProvider)) {
      AsyncData(value: final items?) =>
        items.where((i) => i.startsAt.isBefore(endOfWeek)).length,
      _ => _demoCount,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppHrPalette.accentSoft,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            color: AppHrPalette.ink,
            fontSize: 14,
            height: 1.4,
          ),
          children: [
            TextSpan(text: l10n.homePendingTasksLead),
            TextSpan(
              text: l10n.homePendingTasksCount(pendingCount),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            TextSpan(text: l10n.homePendingTasksTail),
          ],
        ),
      ),
    );
  }
}

/// "Hỏi chính sách" (left) and "Gửi yêu cầu" (right) pills.
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _Pill(
          label: l10n.homeAskPolicyAction,
          background: AppHrPalette.accentSoft,
          foreground: AppHrPalette.accent,
          onTap: () => context.go(AppRoutes.askHr),
        ),
        _Pill(
          label: l10n.homeSendRequestAction,
          background: AppHrPalette.infoSoft,
          foreground: AppHrPalette.infoInk,
          onTap: () => context.go(AppRoutes.myWork),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 36),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// White bordered surface shared by the overview, quota and news cards.
class _Surface extends StatelessWidget {
  const _Surface({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppHrPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: _cardRadius,
        side: BorderSide(color: AppHrPalette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// "Việc sắp đến hạn": the next calendar item, or the demo text without a
/// calendar.
class _UpcomingWorkCard extends ConsumerWidget {
  const _UpcomingWorkCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final subtitle = switch (ref.watch(upcomingScheduleProvider)) {
      AsyncData(value: null) => l10n.homeUpcomingWorkDetail,
      AsyncData(value: final items?) when items.isEmpty =>
        l10n.homeNoUpcomingWork,
      AsyncData(value: final items?) => l10n.homeUpcomingItem(
        items.first.title,
        DateFormat('dd/MM HH:mm').format(items.first.startsAt),
      ),
      AsyncError() => l10n.homeUpcomingUnavailable,
      _ => l10n.commonLoading,
    };
    return _OverviewCard(
      title: l10n.homeUpcomingWork,
      subtitle: subtitle,
      badge: 'A3',
      badgeBackground: AppHrPalette.amberSoft,
      badgeForeground: AppHrPalette.amberInk,
      onTap: () => context.go(AppRoutes.myWork),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeBackground,
    required this.badgeForeground,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String badge;
  final Color badgeBackground;
  final Color badgeForeground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
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
                  subtitle,
                  style: const TextStyle(
                    color: AppHrPalette.inkMuted,
                    fontSize: 13.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: badgeBackground,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeForeground,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// AI token quota, restyled to match the mockup cards.
class _QuotaCard extends ConsumerWidget {
  const _QuotaCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final quotaAsync = ref.watch(userQuotaProvider);

    Widget header({required Widget trailing, Color? iconColor}) => Row(
      children: [
        Icon(
          Icons.bolt_rounded,
          size: 20,
          color: iconColor ?? AppHrPalette.accent,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            l10n.homeQuotaTitle,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppHrPalette.ink,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: trailing,
        ),
      ],
    );

    Widget bar(double? value, Color color) => ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6,
        color: color,
        backgroundColor: color.withValues(alpha: 0.15),
      ),
    );

    return _Surface(
      child: quotaAsync.when(
        loading: () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header(
              trailing: Text(
                l10n.commonLoading,
                style: const TextStyle(
                  color: AppHrPalette.inkMuted,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            bar(null, AppHrPalette.accent),
          ],
        ),
        error: (_, _) => header(
          iconColor: AppHrPalette.danger,
          trailing: Text(
            l10n.headerQuotaUnavailable,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppHrPalette.danger,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        data: (quota) {
          final color = quota.isExceeded
              ? AppHrPalette.danger
              : quota.isWarning
              ? AppHrPalette.amberInk
              : AppHrPalette.accent;
          final percent = '${(quota.usagePercentage * 100).toInt()}%';
          final number = NumberFormat.decimalPattern();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header(
                iconColor: color,
                trailing: Text(
                  quota.isExceeded ? l10n.headerQuotaExceeded : percent,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              bar(quota.usagePercentage, color),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${l10n.headerTokenQuota}: '
                '${number.format(quota.usedTokens)} / '
                '${number.format(quota.limitTokens)}',
                style: const TextStyle(
                  color: AppHrPalette.inkMuted,
                  fontSize: 13,
                ),
              ),
              if (quota.isWarning) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.headerQuotaWarning,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// "BẢN TIN MỚI" eyebrow with the latest two items.
class _NewsSection extends ConsumerWidget {
  const _NewsSection({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final newsAsync = ref.watch(newsListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.homeNewsSection,
                style: const TextStyle(
                  color: AppHrPalette.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.news),
              style: TextButton.styleFrom(
                foregroundColor: AppHrPalette.accent,
                visualDensity: VisualDensity.compact,
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(l10n.homeViewAllNews),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        newsAsync.when(
          loading: () => Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: Semantics(
                label: l10n.homeNewsLoading,
                child: const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppHrPalette.accent,
                  ),
                ),
              ),
            ),
          ),
          error: (_, _) => _Surface(
            onTap: () => ref.invalidate(newsListProvider),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.commonErrorTitle,
                    style: const TextStyle(color: AppHrPalette.danger),
                  ),
                ),
                Text(
                  l10n.commonRetry,
                  style: const TextStyle(
                    color: AppHrPalette.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return Text(
                l10n.homeNewsEmpty,
                style: const TextStyle(color: AppHrPalette.inkMuted),
              );
            }
            final cards = [
              for (final item in items.take(columns == 1 ? 2 : columns))
                _NewsCard(item: item),
            ];
            if (columns == 1) {
              return Column(
                children: [
                  for (final card in cards) ...[
                    card,
                    const SizedBox(height: AppSpacing.md),
                  ],
                ],
              );
            }
            return _Grid(columns: columns, children: cards);
          },
        ),
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
    return _Surface(
      onTap: () => context.push(AppRoutes.article(item.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppHrPalette.ink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${item.summary} · $date',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppHrPalette.inkMuted,
              fontSize: 13.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
