import 'package:flutter/material.dart';
import 'package:flutter_project_base/app/app.dart';
import 'package:flutter_project_base/features/chat/application/chat_providers.dart';
import 'package:flutter_project_base/features/chat/data/providers/mock_chat_provider.dart';
import 'package:flutter_project_base/features/chat/domain/chat_provider.dart';
import 'package:flutter_project_base/features/chat/presentation/chat_hub_page.dart';
import 'package:flutter_project_base/features/elearning/presentation/elearning_hub_page.dart';
import 'package:flutter_project_base/features/home/presentation/trang_chu_page.dart';
import 'package:flutter_project_base/features/my_work/presentation/my_work_page.dart';
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

  Future<void> signInWithDimensions(
    WidgetTester tester, {
    required double width,
    required double height,
    double pixelRatio = 1.0,
    List<Override> extraOverrides = const [],
  }) async {
    tester.view.physicalSize = Size(width * pixelRatio, height * pixelRatio);
    tester.view.devicePixelRatio = pixelRatio;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildTestApp(extraOverrides: extraOverrides));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();
  }

  group('Adaptive Navigation Pass (Phone vs Tablet)', () {
    testWidgets(
      'phone width (< 600dp) uses NavigationBar with exact 5 destinations',
      (tester) async {
        // Phone ~390x844
        await signInWithDimensions(tester, width: 390, height: 844);

        expect(find.byType(NavigationBar), findsOneWidget);
        expect(find.byType(NavigationRail), findsNothing);

        // Verify exact 5 destinations
        expect(find.text('Home'), findsWidgets);
        expect(find.text('Ask HR'), findsWidgets);
        expect(find.text('My Work'), findsWidgets);
        expect(find.text('Learning'), findsWidgets);
        expect(find.text('Account'), findsWidgets);
      },
    );

    testWidgets(
      'tablet width (>= 600dp) uses NavigationRail with exact 5 destinations & logo',
      (tester) async {
        // Tablet portrait 800x1280
        await signInWithDimensions(tester, width: 800, height: 1280);

        expect(find.byType(NavigationRail), findsOneWidget);
        expect(find.byType(NavigationBar), findsNothing);

        // Verify exact 5 destinations
        expect(find.text('Home'), findsWidgets);
        expect(find.text('Ask HR'), findsWidgets);
        expect(find.text('My Work'), findsWidgets);
        expect(find.text('Learning'), findsWidgets);
        expect(find.text('Account'), findsWidgets);

        // Verify GoAI logo in NavigationRail leading
        expect(
          find.descendant(
            of: find.byType(NavigationRail),
            matching: find.byType(Image),
          ),
          findsOneWidget,
        );
      },
    );
  });

  group('Trang Chủ Responsive Composition', () {
    testWidgets('renders compact layout at phone width without overflow', (
      tester,
    ) async {
      await signInWithDimensions(tester, width: 360, height: 800);

      expect(find.byType(TrangChuPage), findsOneWidget);
      expect(find.text('Upcoming Work'), findsOneWidget);
      expect(find.text('My Courses'), findsOneWidget);
      expect(find.text('HR Request #HR-1042'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('COMPANY NEWS'), 200);
      expect(find.text('COMPANY NEWS'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders multi-column composition at tablet width (800x1280)', (
      tester,
    ) async {
      await signInWithDimensions(tester, width: 800, height: 1280);

      expect(find.byType(TrangChuPage), findsOneWidget);
      expect(find.text('Upcoming Work'), findsOneWidget);
      expect(find.text('My Courses'), findsOneWidget);
      expect(find.text('HR Request #HR-1042'), findsOneWidget);
      expect(find.text('COMPANY NEWS'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  });

  group('Trang Chủ mockup elements', () {
    testWidgets('phone shows header, summary, quick actions and quota', (
      tester,
    ) async {
      await signInWithDimensions(tester, width: 360, height: 800);

      expect(find.text('GO AI · HR'), findsOneWidget);
      expect(find.text('Hi Guest 👋'), findsOneWidget);
      expect(
        find.text('You have 2 tasks to finish this week.', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Ask policy'), findsOneWidget);
      expect(find.text('Send request'), findsOneWidget);
      expect(find.text('AI token quota'), findsOneWidget);
      expect(find.text('A3'), findsOneWidget);
      expect(find.text('A7'), findsOneWidget);
      expect(find.text('A0'), findsOneWidget);
    });

    testWidgets('"Ask policy" opens the Ask HR tab', (tester) async {
      await signInWithDimensions(tester, width: 360, height: 800);

      await tester.tap(find.text('Ask policy'));
      await tester.pumpAndSettle();

      expect(find.text('How can HR help?'), findsOneWidget);
    });

    testWidgets('landscape tablet (1280x800) lays cards out in a row', (
      tester,
    ) async {
      await signInWithDimensions(tester, width: 1280, height: 800);

      expect(tester.takeException(), isNull);
      final work = tester.getTopLeft(find.text('Upcoming Work'));
      final courses = tester.getTopLeft(find.text('My Courses'));
      final request = tester.getTopLeft(find.text('HR Request #HR-1042'));
      expect(courses.dy, work.dy);
      expect(request.dy, work.dy);
      expect(courses.dx, greaterThan(work.dx));
      expect(request.dx, greaterThan(courses.dx));
    });
  });

  group('Chat list Master-Detail on Wide Tablet', () {
    testWidgets(
      'chat list (under Account) renders master-detail on wide tablet',
      (tester) async {
        // Wide tablet landscape 1280x800
        await signInWithDimensions(tester, width: 1280, height: 800);

        // Account tab -> Chat list
        await tester.tap(find.text('Account').first);
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Language / security / sign out'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Language / security / sign out'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Chat list'));
        await tester.pumpAndSettle();

        expect(find.byType(ChatHubPage), findsOneWidget);

        // On wide tablet: master pane has agents, detail pane has empty placeholder or chat
        expect(find.text('AI & HR AGENTS'), findsOneWidget);
        expect(find.text('HR Assistant'), findsOneWidget);
        expect(find.text('Chọn trợ lý AI để bắt đầu'), findsOneWidget);

        // Tap HR Assistant in master pane -> activates detail conversation
        await tester.tap(find.text('HR Assistant').first);
        await tester.pumpAndSettle();

        // Conversation composer is rendered in the detail pane
        expect(find.byIcon(Icons.send), findsOneWidget);

        expect(tester.takeException(), isNull);
      },
    );
  });

  group('Học Tập & Việc Của Tôi Responsive Grid', () {
    testWidgets('Learning tab adapts with course cards and test cards', (
      tester,
    ) async {
      await signInWithDimensions(tester, width: 800, height: 1280);

      // Switch to Learning tab
      await tester.tap(find.text('Learning').first);
      await tester.pumpAndSettle();

      expect(find.byType(ELearningHubPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('My Work tab stacks its blocks in one list on tablet', (
      tester,
    ) async {
      await signInWithDimensions(tester, width: 800, height: 1280);

      // Switch to My Work tab
      await tester.tap(find.text('My Work').first);
      await tester.pumpAndSettle();

      expect(find.byType(MyWorkPage), findsOneWidget);
      expect(find.text('Operations staff · Plant A'), findsOneWidget);
      final caseTitle = tester.getTopLeft(
        find.text('Xác nhận thông tin cá nhân'),
      );
      final onboarding = tester.getTopLeft(find.text('ONBOARDING'));
      expect(onboarding.dy, greaterThan(caseTitle.dy));
      expect(onboarding.dx, closeTo(caseTitle.dx, 40));
      expect(tester.takeException(), isNull);
    });
  });
}
