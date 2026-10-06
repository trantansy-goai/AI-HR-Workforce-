import 'package:flutter/material.dart';
import 'package:flutter_project_base/app/app.dart';
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

  Future<void> signInAsGuest(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1260, 3600);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();
  }

  group('Workspace 5-Tab Navigation', () {
    testWidgets(
      'all five main tabs exist and Timeline is the default landing tab',
      (tester) async {
        await signInAsGuest(tester);

        // Verify all 5 tab destinations are present in bottom navigation
        expect(find.text('Timeline'), findsWidgets);
        expect(find.text('Chat'), findsWidgets);
        expect(find.text('E-learning'), findsWidgets);
        expect(find.text('Document'), findsWidgets);
        expect(find.text('My Profile'), findsWidgets);

        // Verify Timeline is active by default
        expect(
          find.text('GOAI Mobile Phase 1 Milestone Reached'),
          findsOneWidget,
        );
      },
    );

    testWidgets('switching between all 5 branches works cleanly', (
      tester,
    ) async {
      await signInAsGuest(tester);

      // 1. Switch to Chat tab
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();
      expect(find.text('AI AGENTS'), findsOneWidget);
      expect(find.text('OTHER'), findsOneWidget);

      // 2. Switch to E-learning tab
      await tester.tap(find.text('E-learning'));
      await tester.pumpAndSettle();
      expect(find.text('Courses & Training'), findsOneWidget);
      expect(find.text('Certification Tests'), findsOneWidget);

      // 3. Switch to Document tab
      await tester.tap(find.text('Document'));
      await tester.pumpAndSettle();
      expect(find.text('Knowledge Documents'), findsOneWidget);
      expect(find.text('Company Security Guidelines 2026'), findsOneWidget);

      // 4. Switch to My Profile tab
      await tester.tap(find.text('My Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Workspace & Actions'), findsOneWidget);
      expect(find.text('Pending Approvals'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // 5. Switch back to Timeline
      await tester.tap(find.text('Timeline'));
      await tester.pumpAndSettle();
      expect(
        find.text('GOAI Mobile Phase 1 Milestone Reached'),
        findsOneWidget,
      );
    });
  });

  group('Chat Discovery, Agents & History', () {
    testWidgets('Chat root presents AI AGENTS and OTHER categories', (
      tester,
    ) async {
      await signInAsGuest(tester);
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();

      expect(find.text('AI AGENTS'), findsOneWidget);
      expect(find.text('Mock Assistant'), findsOneWidget);
      expect(find.text('HR Assistant'), findsOneWidget);
      expect(find.text('Legal Assistant'), findsOneWidget);

      expect(find.text('OTHER'), findsOneWidget);
      expect(find.text('BLOCKED'), findsOneWidget);
      expect(find.text('Customer Support'), findsOneWidget);
      expect(find.text('Product Team'), findsOneWidget);
    });

    testWidgets('Agent -> History -> Start new conversation', (tester) async {
      await signInAsGuest(tester);
      await tester.tap(find.text('Chat'));
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
      await tester.tap(find.text('Chat'));
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

  group('E-Learning Hub with Courses and Certification Tests', () {
    testWidgets('switches between Courses and Tests tabs', (tester) async {
      await signInAsGuest(tester);
      await tester.tap(find.text('E-learning'));
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

  group('Notification Navigation & Secondary Approval Access', () {
    testWidgets(
      'header notification icon navigates to Notification list and deep links to Approvals',
      (tester) async {
        await signInAsGuest(tester);

        // Tap notification bell in header
        await tester.tap(find.byIcon(Icons.notifications_outlined).first);
        await tester.pumpAndSettle();

        expect(find.text('Notifications'), findsOneWidget);
        expect(find.text('Pending Approval Request'), findsOneWidget);

        // Tap approval notification tile (deepLink: /home/approvals)
        await tester.tap(find.text('Pending Approval Request'));
        await tester.pumpAndSettle();

        expect(find.text('Pending Approvals'), findsOneWidget);
        expect(
          find.text('Quota Expansion Request (100k Tokens)'),
          findsOneWidget,
        );
      },
    );

    testWidgets('My Profile navigates to Approvals', (tester) async {
      await signInAsGuest(tester);
      await tester.tap(find.text('My Profile'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pending Approvals'));
      await tester.pumpAndSettle();

      expect(find.text('Pending Approvals'), findsOneWidget);
      expect(
        find.text('Quota Expansion Request (100k Tokens)'),
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
      expect(find.textContaining('85% (Quota warning)'), findsOneWidget);
    });

    testWidgets('renders exceeded quota state', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          extraOverrides: [
            userQuotaProvider.overrideWith(
              (ref) async => const UserQuota(
                usedTokens: 55000,
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
              (ref) async => throw Exception('Network timeout'),
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
