import 'package:flutter/material.dart';
import 'package:flutter_project_base/app/app.dart';
import 'package:flutter_project_base/app/router/app_router.dart';
import 'package:flutter_project_base/features/chat/application/chat_providers.dart';
import 'package:flutter_project_base/features/chat/data/providers/mock_chat_provider.dart';
import 'package:flutter_project_base/features/chat/domain/chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_helpers.dart';

/// End-to-end smoke tests of the real app widget with in-memory
/// infrastructure: bootstrap, routing guards, auth, 5-tab workspace shell,
/// ask HR agent discovery/history, my work, and settings.
void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    // Phone-sized viewport.
    tester.view.physicalSize = const Size(1260, 3600);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
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
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'boots to sign-in and enters home as guest on Home/Trang chủ dashboard',
    (tester) async {
      await pumpApp(tester);
      expect(find.text('Welcome back'), findsOneWidget);

      await tester.tap(find.text('Continue as guest'));
      await tester.pumpAndSettle();

      // Shared Header
      expect(find.text('Hello, Guest'), findsOneWidget);
      expect(
        find.text('Enterprise AI Assistant & Employee Workspace'),
        findsOneWidget,
      );

      // 5 Main Navigation Tabs exist
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Ask HR'), findsWidgets);
      expect(find.text('My Work'), findsWidgets);
      expect(find.text('Learning'), findsWidgets);
      expect(find.text('Account'), findsWidgets);

      // Default landing tab is Home dashboard showing overview & internal news
      expect(
        find.text('GOAI Mobile Phase 1 Milestone Reached'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Ask HR demo: open discovery, agent history, conversation, send & AI reply',
    (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Continue as guest'));
      await tester.pumpAndSettle();

      // Switch to Ask HR tab
      await tester.tap(find.text('Ask HR'));
      await tester.pumpAndSettle();

      // Agents are visible
      expect(find.text('AI & HR AGENTS'), findsOneWidget);
      expect(find.text('Mock Assistant'), findsOneWidget);
      expect(find.text('HR Assistant'), findsOneWidget);

      // Select Agent -> Conversation History
      await tester.tap(find.text('Mock Assistant'));
      await tester.pumpAndSettle();
      expect(find.text('Mock Assistant History'), findsOneWidget);
      expect(find.text('Start new conversation'), findsOneWidget);

      // Select History Item -> Chat Detail
      await tester.tap(find.widgetWithText(ListTile, 'Mock Assistant'));
      await tester.pumpAndSettle();

      // Immersive conversation detail: composer active
      await tester.enterText(find.byType(TextField), 'Hello bot');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Hello bot', findRichText: true),
        findsWidgets,
        reason: 'sent bubble (and quoted in the reply)',
      );
      expect(
        find.textContaining('streamed by MockChatProvider', findRichText: true),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'settings: access from Account, switch theme/locale, then sign out',
    (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Continue as guest'));
      await tester.pumpAndSettle();

      // Switch to Account tab
      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();

      expect(find.text('Internal News & Bulletins'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Navigate to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);

      await tester.tap(find.text('Tiếng Việt'));
      await tester.pumpAndSettle();
      expect(find.text('Cài đặt'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Đăng xuất'), 200);
      await tester.tap(find.text('Đăng xuất'));
      await tester.pumpAndSettle();
      // Confirm dialog.
      await tester.tap(find.widgetWithText(FilledButton, 'Đăng xuất'));
      await tester.pumpAndSettle();
      expect(find.text('Chào mừng trở lại'), findsOneWidget);
    },
  );

  testWidgets('unknown routes show the not-found page', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    ProviderScope.containerOf(context).read(routerProvider).go('/nope');
    await tester.pumpAndSettle();
    expect(find.text('Page not found'), findsOneWidget);
  });
}
