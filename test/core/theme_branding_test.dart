import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/app/app.dart';
import 'package:goai_mobile/app/pages.dart';
import 'package:goai_mobile/core/theme/app_theme.dart';
import 'package:goai_mobile/core/theme/app_tokens.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('GoAI Brand Colors & Theme', () {
    test('defines official sampled GoAI brand colors', () {
      expect(AppBrandColors.primaryBlue, const Color(0xFF0E3CAF));
      expect(AppBrandColors.secondaryGold, const Color(0xFFD99F37));
    });

    test('applies the brand blue as theme primary in light mode', () {
      final theme = const AppTheme().light;
      expect(AppHrPalette.accent, AppBrandColors.primaryBlue);
      expect(theme.colorScheme.primary, AppBrandColors.primaryBlue);
      expect(theme.colorScheme.secondary, AppBrandColors.secondaryGold);
    });

    test('uses the GO AI HR canvas, white app bars and bordered cards', () {
      final theme = const AppTheme().light;
      expect(theme.scaffoldBackgroundColor, AppHrPalette.background);
      expect(theme.appBarTheme.backgroundColor, AppHrPalette.surface);
      expect(theme.cardTheme.color, AppHrPalette.surface);
      final cardShape = theme.cardTheme.shape! as RoundedRectangleBorder;
      expect(cardShape.side.color, AppHrPalette.border);
    });

    test('configures bottom navigation bar styling with brand colors', () {
      final theme = const AppTheme().light;
      final navTheme = theme.navigationBarTheme;
      expect(navTheme.backgroundColor, theme.colorScheme.surface);

      final selectedIcon = navTheme.iconTheme?.resolve({WidgetState.selected});
      final unselectedIcon = navTheme.iconTheme?.resolve({});
      expect(selectedIcon?.color, AppHrPalette.accent);
      expect(unselectedIcon?.color, theme.colorScheme.onSurfaceVariant);

      final selectedText = navTheme.labelTextStyle?.resolve({
        WidgetState.selected,
      });
      final unselectedText = navTheme.labelTextStyle?.resolve({});
      expect(selectedText?.color, AppHrPalette.accent);
      expect(selectedText?.fontWeight, FontWeight.w600);
      expect(unselectedText?.color, theme.colorScheme.onSurfaceVariant);
    });

    test('configures button and tab bar themes with primary blue', () {
      final theme = const AppTheme().light;
      expect(
        theme.filledButtonTheme.style?.backgroundColor?.resolve({}),
        AppHrPalette.accent,
      );
      expect(
        theme.outlinedButtonTheme.style?.foregroundColor?.resolve({}),
        AppHrPalette.accent,
      );
      expect(
        theme.textButtonTheme.style?.foregroundColor?.resolve({}),
        AppHrPalette.accent,
      );
      expect(theme.tabBarTheme.labelColor, AppHrPalette.accent);
      expect(theme.tabBarTheme.indicatorColor, AppHrPalette.accent);
      expect(theme.progressIndicatorTheme.color, AppHrPalette.accent);
    });
  });

  group('Splash Screen Branding', () {
    testWidgets('renders clean white background and centered GoAI logo', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SplashPage()));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final image = tester.widget<Image>(imageFinder);
      expect(image.fit, BoxFit.contain);
      expect(image.image, isA<AssetImage>());
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/goai_logo.png');
    });
  });

  group('Force Light Mode', () {
    testWidgets(
      'renders light theme when platform brightness is Brightness.light',
      (tester) async {
        tester.platformDispatcher.platformBrightnessTestValue =
            Brightness.light;
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

        await tester.pumpWidget(
          ProviderScope(
            retry: noRetry,
            overrides: baseTestOverrides(),
            child: const App(),
          ),
        );
        await tester.pumpAndSettle();

        final materialApp = tester.widget<MaterialApp>(
          find.byType(MaterialApp),
        );
        expect(materialApp.themeMode, ThemeMode.light);

        // App-level theme (screens such as sign-in may scope their own accent).
        final theme = Theme.of(tester.element(find.byType(Navigator).first));
        expect(theme.brightness, Brightness.light);
        expect(theme.colorScheme.primary, AppHrPalette.accent);
        expect(theme.colorScheme.secondary, AppBrandColors.secondaryGold);
      },
    );

    testWidgets(
      'renders light theme when platform brightness is Brightness.dark',
      (tester) async {
        tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

        await tester.pumpWidget(
          ProviderScope(
            retry: noRetry,
            overrides: baseTestOverrides(),
            child: const App(),
          ),
        );
        await tester.pumpAndSettle();

        final materialApp = tester.widget<MaterialApp>(
          find.byType(MaterialApp),
        );
        expect(materialApp.themeMode, ThemeMode.light);

        // App-level theme (screens such as sign-in may scope their own accent).
        final theme = Theme.of(tester.element(find.byType(Navigator).first));
        expect(theme.brightness, Brightness.light);
        expect(theme.colorScheme.primary, AppHrPalette.accent);
        expect(theme.colorScheme.secondary, AppBrandColors.secondaryGold);
      },
    );
  });
}
