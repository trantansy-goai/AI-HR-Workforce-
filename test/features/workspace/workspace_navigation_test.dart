import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/app/app.dart';
import 'package:goai_mobile/features/chat/application/chat_providers.dart';
import 'package:goai_mobile/features/chat/data/providers/mock_chat_provider.dart';
import 'package:goai_mobile/features/chat/domain/chat_provider.dart';
import 'package:goai_mobile/features/quota/application/quota_providers.dart';
import 'package:goai_mobile/features/quota/domain/user_quota.dart';

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

  Future<void> openChatList(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(NavigationDestination, 'Account'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Language / security / sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language / security / sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chat list'));
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
        expect(find.text('Thông điệp từ Ban điều hành'), findsOneWidget);
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
      expect(find.text('How can HR help?'), findsOneWidget);
      expect(find.text('View policy & sources'), findsOneWidget);

      // 2. Switch to My Work tab
      await tester.tap(find.widgetWithText(NavigationDestination, 'My Work'));
      await tester.pumpAndSettle();
      expect(find.text('Xác nhận thông tin cá nhân'), findsOneWidget);
      expect(find.text('Operations staff · Plant A'), findsOneWidget);
      expect(find.text('Xác minh hồ sơ cá nhân'), findsOneWidget);

      // 3. Switch to Learning tab
      await tester.tap(find.widgetWithText(NavigationDestination, 'Learning'));
      await tester.pumpAndSettle();
      expect(find.text('Courses & Training'), findsOneWidget);
      expect(find.text('Certification Tests'), findsOneWidget);

      // 4. Switch to Account tab
      await tester.tap(find.widgetWithText(NavigationDestination, 'Account'));
      await tester.pumpAndSettle();
      expect(find.text('Company news'), findsOneWidget);
      expect(find.text('Thông điệp từ Ban điều hành'), findsOneWidget);

      // 5. Switch back to Home
      await tester.tap(find.widgetWithText(NavigationDestination, 'Home'));
      await tester.pumpAndSettle();
      expect(find.text('Thông điệp từ Ban điều hành'), findsOneWidget);
    });
  });

  group('Hỏi HR (M03/M04)', () {
    testWidgets('policy sources -> "Create HR request" opens request dialog', (
      tester,
    ) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Ask HR'));
      await tester.pumpAndSettle();

      expect(find.text('I need to see the leave policy.'), findsOneWidget);
      await tester.tap(find.text('View policy & sources'));
      await tester.pumpAndSettle();

      expect(find.text('Annual leave policy'), findsOneWidget);
      expect(find.text('APPROVED SOURCE'), findsOneWidget);
      expect(find.text('Leave policy • version 2.1'), findsOneWidget);

      await tester.tap(find.text('Create HR request'));
      await tester.pumpAndSettle();

      // Lands on the Việc tab with the M05 request dialog open.
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Send HR request'), findsOneWidget);
      expect(find.text('Operations staff · Plant A'), findsOneWidget);
    });

    testWidgets('typing a question opens an HR conversation with it', (
      tester,
    ) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Ask HR'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'How many leave days?');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('How many leave days?', findRichText: true),
        findsWidgets,
      );
    });
  });

  testWidgets('HR staff get the agent list in the Hỏi HR tab', (tester) async {
    await signInAsGuest(tester);
    await tester.tap(find.widgetWithText(NavigationDestination, 'My Work'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('HR / Admin'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(NavigationDestination, 'Ask HR'));
    await tester.pumpAndSettle();

    expect(find.text('AI & HR AGENTS'), findsOneWidget);
    expect(find.text('I need to see the leave policy.'), findsNothing);
  });

  group('Chat list (Account), Agents & History', () {
    testWidgets('chat list presents AI & HR agents', (tester) async {
      await signInAsGuest(tester);
      await openChatList(tester);

      expect(find.text('AI & HR AGENTS'), findsOneWidget);
      expect(find.text('Mock Assistant'), findsOneWidget);
      expect(find.text('HR Assistant'), findsOneWidget);
      expect(find.text('Legal Assistant'), findsOneWidget);

      expect(find.text('OTHER'), findsOneWidget);
      expect(find.text('BLOCKED'), findsOneWidget);
    });

    testWidgets('Agent -> History -> Start new conversation', (tester) async {
      await signInAsGuest(tester);
      await openChatList(tester);

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
      await openChatList(tester);

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

  group('Việc của tôi by role', () {
    Future<void> openMyWork(WidgetTester tester) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'My Work'));
      await tester.pumpAndSettle();
    }

    testWidgets('employee sees case tracking (M06) and onboarding (M07)', (
      tester,
    ) async {
      await openMyWork(tester);

      expect(find.text('#HR-1042'), findsOneWidget);
      expect(find.text('Đang chờ HR xác minh'), findsOneWidget);
      expect(find.text('Secure exchange'), findsOneWidget);
      expect(find.text('Add documents'), findsOneWidget);

      expect(find.text('ONBOARDING'), findsOneWidget);
      expect(find.text('2/5 items confirmed'), findsOneWidget);
      expect(find.text('Đăng ký tuyến xe đưa đón'), findsNothing);
      await tester.ensureVisible(find.text('Show remaining items'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Show remaining items'));
      await tester.pumpAndSettle();
      expect(find.text('Đăng ký tuyến xe đưa đón'), findsOneWidget);

      // HR/Admin blocks are not part of the employee view.
      expect(find.text('Awaiting my approval'), findsNothing);
    });

    testWidgets('M05 dialog ignores taps outside; close button dismisses', (
      tester,
    ) async {
      await openMyWork(tester);
      await tester.tap(find.text('New HR request'));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('submitting the M05 dialog opens a new case', (tester) async {
      await openMyWork(tester);

      await tester.tap(find.text('New HR request'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Submit request'));
      await tester.pumpAndSettle();
      expect(find.text('Please choose a request type'), findsOneWidget);

      await tester.tap(
        find.text('Request type: personal information confirmation'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Leave').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(TextFormField),
        ),
        'Xin nghỉ phép 2 ngày',
      );
      await tester.tap(find.text('Submit request'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
      expect(find.text('Request sent · #HR-1043'), findsOneWidget);
      expect(find.text('#HR-1043'), findsOneWidget);
      expect(find.text('Xin nghỉ phép 2 ngày'), findsOneWidget);
    });

    testWidgets('HR/Admin sees approvals (M11), probation (M12), queue (M13)', (
      tester,
    ) async {
      await openMyWork(tester);
      await tester.tap(find.text('HR / Admin'));
      await tester.pumpAndSettle();

      expect(find.text('Awaiting my approval'), findsOneWidget);
      expect(find.text('Probation review file'), findsOneWidget);
      expect(find.text('Probation review #PB-238'), findsOneWidget);
      expect(find.text('Case #HR-1051'), findsOneWidget);
      expect(find.text('View queue on Web'), findsOneWidget);

      // Employee blocks are hidden.
      expect(find.text('ONBOARDING'), findsNothing);
      expect(find.text('New HR request'), findsNothing);

      // Decisions aren't wired to a backend yet.
      await tester.ensureVisible(find.text('Escalate to HR/Legal'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Escalate to HR/Legal'));
      await tester.pumpAndSettle();
      expect(find.text('Coming soon'), findsOneWidget);
    });
  });

  group('Học tập (Courses & Online Tests)', () {
    testWidgets('switches between Courses and Tests tabs', (tester) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Learning'));
      await tester.pumpAndSettle();

      // Courses tab active by default: "My learning" (M08)
      expect(find.text('My learning'), findsOneWidget);
      expect(find.text('1 mandatory course · due 12/10'), findsOneWidget);
      expect(find.text('An toàn lao động cơ bản'), findsOneWidget);
      expect(find.text('Mandatory'), findsOneWidget);
      expect(
        find.text('Video 12 min · quiz 8 questions · due 12/10'),
        findsOneWidget,
      );
      expect(find.text('Progress 40%'), findsOneWidget);
      expect(find.text('Continue learning'), findsOneWidget);
      expect(find.text('Quy tắc ứng xử tại nhà máy'), findsOneWidget);
      expect(find.text('Reading 6 min · not started'), findsOneWidget);

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
      await tester.tap(find.byTooltip('Notifications').first);
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Checklist sắp đến hạn'), findsOneWidget);

      // Regression: opening a tab route from the notification list used to
      // push it onto the root navigator and crash with duplicate page keys.
      await tester.tap(find.text('Checklist sắp đến hạn'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Notifications'), findsNothing);
      expect(find.text('Operations staff · Plant A'), findsOneWidget);
    });

    testWidgets('Account tab lists news (M09) and notifications (M10)', (
      tester,
    ) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Account'));
      await tester.pumpAndSettle();

      expect(find.text('Company news'), findsOneWidget);
      expect(find.text('Thông điệp từ Ban điều hành'), findsOneWidget);
      expect(find.text('Lịch khám sức khỏe định kỳ'), findsOneWidget);
      expect(find.text('Chủ sở hữu: HR · 06/10'), findsOneWidget);

      // Filter by the "HR" audience tag.
      await tester.tap(find.text('HR'));
      await tester.pumpAndSettle();
      expect(find.text('Thông điệp từ Ban điều hành'), findsNothing);
      expect(find.text('Lịch khám sức khỏe định kỳ'), findsOneWidget);
      expect(find.text('Cập nhật tuyến xe đưa đón'), findsNothing);

      await tester.ensureVisible(find.text('My notifications'));
      await tester.pumpAndSettle();
      expect(find.text('Khóa học được giao'), findsOneWidget);
      expect(find.text('ACCOUNT'), findsOneWidget);

      // "View full content" opens the news list.
      await tester.ensureVisible(find.text('View full content'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('View full content'));
      await tester.pumpAndSettle();
      expect(find.text('Company News & Updates'), findsOneWidget);
    });

    testWidgets('account menu offers settings, security and sign out', (
      tester,
    ) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Account'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Language / security / sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Language / security / sign out'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Language & settings'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Chat list'), findsOneWidget);

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
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

  group('System back on the workspace tabs', () {
    testWidgets('back on another tab returns to Home', (tester) async {
      await signInAsGuest(tester);
      await tester.tap(find.widgetWithText(NavigationDestination, 'Learning'));
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Upcoming Work'), findsOneWidget);
    });

    testWidgets('Home needs a second back press to exit', (tester) async {
      final calls = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          calls.add(call.method);
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await signInAsGuest(tester);

      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.text('Press back again to exit'), findsOneWidget);
      expect(calls, isNot(contains('SystemNavigator.pop')));

      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(calls, contains('SystemNavigator.pop'));
    });
  });
}
