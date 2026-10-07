import 'package:flutter/material.dart';
import 'package:flutter_project_base/app/app.dart';
import 'package:flutter_project_base/features/approval/application/approval_providers.dart';
import 'package:flutter_project_base/features/chat/application/chat_providers.dart';
import 'package:flutter_project_base/features/chat/data/providers/mock_chat_provider.dart';
import 'package:flutter_project_base/features/chat/domain/chat_provider.dart';
import 'package:flutter_project_base/features/quota/application/quota_providers.dart';
import 'package:flutter_project_base/features/quota/domain/user_quota.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_helpers.dart';

void main() {
  Widget buildTestApp({List<Override> extraOverrides = const []}) {
    return ProviderScope(
      retry: noRetry,
      overrides: [
        ...baseTestOverrides(),
        chatProviderProvider.overrideWith((ref) {
          final provider = MockChatProvider(
            self: ref.watch(chatSelfProvider),
            tokenDelay: Duration.zero,
            replyDelay: Duration.zero,
          );
          ref.onDispose(provider.dispose);
          return provider as ChatProvider;
        }),
        ...extraOverrides,
      ],
      child: const App(),
    );
  }

  Future<void> signInAsGuest(
    WidgetTester tester, {
    List<Override> extraOverrides = const [],
  }) async {
    tester.view.physicalSize = const Size(1260, 3600);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildTestApp(extraOverrides: extraOverrides));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();
  }

  group('Workspace 5-Tab Navigation & Trang chủ default', () {
    testWidgets(
      'all five main tabs exist and Home / Trang chủ is the default landing tab',
      (tester) async {
        await signInAsGuest(tester);

        // Verify all 5 tab destinations are present in bottom navigation
        expect(find.text('Home'), findsWidgets);
        expect(find.text('Ask HR'), findsWidgets);
        expect(find.text('My Work'), findsWidgets);
        expect(find.text('Learning'), findsWidgets);
        expect(find.text('Account'), findsWidgets);

        // Verify Trang chủ Dashboard content is active by default
        expect(
          find.text('GOAI Mobile Phase 1 Milestone Reached'),
          findsOneWidget,
        );
        expect(find.text('Upcoming Work'), findsOneWidget);
        expect(find.text('My Courses'), findsOneWidget);
      },
    );

    testWidgets('switching between all 5 branches works cleanly', (
      tester,
    ) async {
      await signInAsGuest(tester);

      // 1. Switch to Ask HR tab
      await tester.tap(find.widgetWithText(NavigationDestination, 'Ask HR'));
      await tester.pumpAndSettle();
      expect(find.text('AI & HR AGENTS'), findsOneWidget);
      expect(find.text('OTHER'), findsOneWidget);

      // 2. Switch to My Work tab
      await tester.tap(find.widgetWithText(NavigationDestination, 'My Work'));
      await tester.pumpAndSettle();
      expect(find.text('A3 · HỘI NHẬP'), findsOneWidget);
      expect(find.text('Nhân viên vận hành · Nhà máy A'), findsOneWidget);
      expect(find.text('Xác minh hồ sơ cá nhân'), findsOneWidget);

      // 3. Switch to Learning tab
      await tester.tap(find.widgetWithText(NavigationDestination, 'Learning'));
      await tester.pumpAndSettle();
      expect(find.text('Courses & Training'), findsOneWidget);
      expect(find.text('Certification Tests'), findsOneWidget);

      // 4. Switch to Account tab
      await tester.tap(find.widgetWithText(NavigationDestination, 'Account'));
      await tester.pumpAndSettle();
      expect(find.text('Internal News & Bulletins'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // 5. Switch back to Home
      await tester.tap(find.widgetWithText(NavigationDestination, 'Home'));
      await tester.pumpAndSettle();
      expect(
        find.text('GOAI Mobile Phase 1 Milestone Reached'),
        findsOneWidget,
      );
    });
  });

  group('Ask HR, Agents & History', () {
    testWidgets('Ask HR root presents AI & HR agents', (tester) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Ask HR'));
      await tester.pumpAndSettle();

      expect(find.text('AI & HR AGENTS'), findsOneWidget);
      expect(find.text('Mock Assistant'), findsOneWidget);
      expect(find.text('HR Assistant'), findsOneWidget);
      expect(find.text('Legal Assistant'), findsOneWidget);

      expect(find.text('OTHER'), findsOneWidget);
      expect(find.text('BLOCKED'), findsOneWidget);
    });

    testWidgets('Agent -> History -> Start new conversation', (tester) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Ask HR'));
      await tester.pumpAndSettle();

      // Tap HR Assistant
      await tester.tap(find.text('HR Assistant'));
      await tester.pumpAndSettle();

      expect(find.text('HR Assistant History'), findsOneWidget);
      expect(find.text('Start new conversation'), findsOneWidget);
      expect(find.text('Leave Policy & Benefits'), findsOneWidget);

      // Tap start new conversation action
      await tester.tap(find.text('Start new conversation'));
      await tester.pumpAndSettle();

      // Opens conversation page with composer
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Agent -> History -> Open existing conversation', (
      tester,
    ) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Ask HR'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('HR Assistant'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Leave Policy & Benefits'));
      await tester.pumpAndSettle();

      expect(find.text('Leave Policy & Benefits'), findsOneWidget);
      expect(
        find.textContaining('You have 14 annual leave days remaining'),
        findsOneWidget,
      );
    });
  });

  group('Việc của tôi & Permission-Aware Approvals', () {
    testWidgets('renders Checklist and Cases with approval permission', (
      tester,
    ) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'My Work'));
      await tester.pumpAndSettle();

      expect(find.text('A3 · HỘI NHẬP'), findsOneWidget);
      expect(find.text('3/5 mục đã xác nhận'), findsOneWidget);
      expect(find.text('A0 + A4 · CASE & YÊU CẦU'), findsOneWidget);
      expect(find.text('#HR-1042'), findsOneWidget);

      // With default approval permission true:
      expect(find.text('DÀNH CHO NGƯỜI CÓ QUYỀN'), findsOneWidget);
      expect(find.text('Chờ tôi phê duyệt'), findsOneWidget);
      expect(
        find.text('Quota Expansion Request (100k Tokens)'),
        findsOneWidget,
      );
    });

    testWidgets('hides approval inbox when user lacks approval permission', (
      tester,
    ) async {
      await signInAsGuest(
        tester,
        extraOverrides: [
          hasApprovalPermissionProvider.overrideWithValue(false),
        ],
      );
      await tester.tap(find.widgetWithText(NavigationDestination, 'My Work'));
      await tester.pumpAndSettle();

      // Checklist and Cases are visible
      expect(find.text('A3 · HỘI NHẬP'), findsOneWidget);
      expect(find.text('A0 + A4 · CASE & YÊU CẦU'), findsOneWidget);

      // Approval section is NOT visible
      expect(find.text('DÀNH CHO NGƯỜI CÓ QUYỀN'), findsNothing);
      expect(find.text('Chờ tôi phê duyệt'), findsNothing);
    });
  });

  group('Học tập (Courses & Online Tests)', () {
    testWidgets('switches between Courses and Tests tabs', (tester) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Learning'));
      await tester.pumpAndSettle();

      // Courses tab active by default
      expect(
        find.text('Enterprise AI & Security Compliance 101'),
        findsOneWidget,
      );

      // Switch to Certification Tests tab
      await tester.tap(find.text('Certification Tests'));
      await tester.pumpAndSettle();

      expect(
        find.text('AI Compliance & Security Certification Exam'),
        findsOneWidget,
      );
      expect(find.text('Start'), findsWidgets);
    });
  });

  group('Tài khoản (Account), Bản tin, and Notifications', () {
    testWidgets('header notification icon navigates to Notification list', (
      tester,
    ) async {
      await signInAsGuest(tester);

      // Tap notification bell in header
      await tester.tap(find.byIcon(Icons.notifications_outlined).first);
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Pending Approval Request'), findsOneWidget);
    });

    testWidgets('Account tab navigates to Bản tin (News list)', (tester) async {
      await signInAsGuest(tester);
      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();

      // Tap Internal News & Bulletins
      await tester.tap(find.text('Internal News & Bulletins'));
      await tester.pumpAndSettle();

      expect(find.text('Company News & Updates'), findsOneWidget);
      expect(
        find.text('GOAI Mobile Phase 1 Milestone Reached'),
        findsOneWidget,
      );
    });
  });

  group('SharedWorkspaceHeader & Quota States', () {
    testWidgets('renders available quota state', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          extraOverrides: [
            userQuotaProvider.overrideWith(
              (ref) async => const UserQuota(
                usedTokens: 25000,
                limitTokens: 50000,
                periodName: 'Monthly',
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue as guest'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Token quota: 25,000 / 50,000'),
        findsOneWidget,
      );
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('renders warning quota state (>= 80%)', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          extraOverrides: [
            userQuotaProvider.overrideWith(
              (ref) async => const UserQuota(
                usedTokens: 42500,
                limitTokens: 50000,
                periodName: 'Monthly',
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue as guest'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Token quota: 42,500 / 50,000'),
        findsOneWidget,
      );
      expect(find.textContaining('85%'), findsOneWidget);
      expect(find.textContaining('Quota warning'), findsOneWidget);
    });

    testWidgets('renders exceeded quota state', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          extraOverrides: [
            userQuotaProvider.overrideWith(
              (ref) async => const UserQuota(
                usedTokens: 50000,
                limitTokens: 50000,
                periodName: 'Monthly',
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue as guest'));
      await tester.pumpAndSettle();

      expect(find.text('Quota exceeded'), findsOneWidget);
    });

    testWidgets('renders error/unavailable quota state', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          extraOverrides: [
            userQuotaProvider.overrideWith(
              (ref) async => throw Exception('Quota server unreachable'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue as guest'));
      await tester.pumpAndSettle();

      expect(find.text('Quota unavailable'), findsOneWidget);
    });
  });
}
