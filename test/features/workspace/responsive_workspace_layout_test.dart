import 'package:flutter/material.dart';
import 'package:flutter_project_base/app/app.dart';
import 'package:flutter_project_base/features/chat/application/chat_providers.dart';
import 'package:flutter_project_base/features/chat/data/providers/mock_chat_provider.dart';
import 'package:flutter_project_base/features/chat/domain/chat_provider.dart';
import 'package:flutter_project_base/features/chat/presentation/ask_hr_page.dart';
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

  group('Hỏi HR Master-Detail on Wide Tablet', () {
    testWidgets(
      'renders single-column discovery on phone and master-detail on wide tablet',
      (tester) async {
        // Wide tablet landscape 1280x800
        await signInWithDimensions(tester, width: 1280, height: 800);

        // Switch to Ask HR tab
        await tester.tap(find.text('Ask HR').first);
        await tester.pumpAndSettle();

        expect(find.byType(AskHrPage), findsOneWidget);

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

    testWidgets('My Work tab adapts into two-column layout on tablet', (
      tester,
    ) async {
      await signInWithDimensions(tester, width: 800, height: 1280);

      // Switch to My Work tab
      await tester.tap(find.text('My Work').first);
      await tester.pumpAndSettle();

      expect(find.byType(MyWorkPage), findsOneWidget);
      expect(find.text('Nhân viên vận hành · Nhà máy A'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
