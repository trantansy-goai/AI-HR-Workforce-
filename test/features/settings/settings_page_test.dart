import 'package:flutter/material.dart';
import 'package:flutter_project_base/features/settings/presentation/settings_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_helpers.dart';

void main() {
  testWidgets(
    'SettingsPage does not show theme selector and preserves language/about sections',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          retry: noRetry,
          overrides: baseTestOverrides(),
          child: testApp(const SettingsPage()),
        ),
      );
      await tester.pumpAndSettle();

      // Theme / appearance must be completely removed
      expect(find.text('Appearance'), findsNothing);
      expect(find.text('Light'), findsNothing);
      expect(find.text('Dark'), findsNothing);
      expect(find.byType(SegmentedButton<ThemeMode>), findsNothing);

      // Language and About must still be present
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('System default'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Tiếng Việt'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('App name'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
      expect(find.text('Environment'), findsOneWidget);
    },
  );
}
