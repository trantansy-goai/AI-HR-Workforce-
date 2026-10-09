import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/app/app.dart';
import 'package:goai_mobile/app/router/app_router.dart';
import 'package:goai_mobile/features/chat/application/chat_providers.dart';
import 'package:goai_mobile/features/chat/data/providers/mock_chat_provider.dart';
import 'package:goai_mobile/features/chat/domain/chat_provider.dart';

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

      // Home app bar & greeting
      expect(find.text('GO AI · HR'), findsOneWidget);
      expect(find.text('Hi Guest 👋'), findsOneWidget);

      // 5 Main Navigation Tabs exist
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Ask HR'), findsWidgets);
      expect(find.text('My Work'), findsWidgets);
      expect(find.text('Learning'), findsWidgets);
      expect(find.text('Account'), findsWidgets);

      // Default landing tab is Home dashboard showing overview & internal news
      expect(find.text('Thông điệp từ Ban điều hành'), findsOneWidget);
    },
  );

  testWidgets(
    'Ask HR demo: open discovery, agent history, conversation, send & AI reply',
    (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Continue as guest'));
      await tester.pumpAndSettle();

      // Chat list lives under the Account tab for now
      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Language / security / sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Language / security / sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chat list'));
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
    'settings: access from Account, verify light-only mode and switch locale, then sign out',
    (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Continue as guest'));
      await tester.pumpAndSettle();

      // Switch to Account tab
      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();

      expect(find.text('Company news'), findsOneWidget);
      expect(find.text('My notifications'), findsWidgets);

      // Navigate to Settings via the account menu
      await tester.ensureVisible(find.text('Language / security / sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Language / security / sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Language & settings'));
      await tester.pumpAndSettle();

      // Verify theme switching UI is completely removed and light mode is enforced
      expect(find.text('Appearance'), findsNothing);
      expect(find.text('Dark'), findsNothing);
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.light);

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
