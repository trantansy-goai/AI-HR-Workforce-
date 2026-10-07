import 'package:flutter/material.dart';
import 'package:flutter_project_base/app/pages.dart';
import 'package:flutter_project_base/core/theme/app_theme.dart';
import 'package:flutter_project_base/core/theme/app_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoAI Brand Colors & Theme', () {
    test('defines official sampled GoAI brand colors', () {
      expect(AppBrandColors.primaryBlue, const Color(0xFF0E3CAF));
      expect(AppBrandColors.secondaryGold, const Color(0xFFD99F37));
    });

    test('applies primary blue as theme primary in light mode', () {
      final theme = const AppTheme().light;
      expect(theme.colorScheme.primary, AppBrandColors.primaryBlue);
      expect(theme.colorScheme.secondary, AppBrandColors.secondaryGold);
    });

    test('configures bottom navigation bar styling with brand colors', () {
      final theme = const AppTheme().light;
      final navTheme = theme.navigationBarTheme;
      expect(navTheme.backgroundColor, theme.colorScheme.surface);

      final selectedIcon = navTheme.iconTheme?.resolve({WidgetState.selected});
      final unselectedIcon = navTheme.iconTheme?.resolve({});
      expect(selectedIcon?.color, AppBrandColors.primaryBlue);
      expect(unselectedIcon?.color, theme.colorScheme.onSurfaceVariant);

      final selectedText = navTheme.labelTextStyle?.resolve({
        WidgetState.selected,
      });
      final unselectedText = navTheme.labelTextStyle?.resolve({});
      expect(selectedText?.color, AppBrandColors.primaryBlue);
      expect(selectedText?.fontWeight, FontWeight.w600);
      expect(unselectedText?.color, theme.colorScheme.onSurfaceVariant);
    });

    test('configures button and tab bar themes with primary blue', () {
      final theme = const AppTheme().light;
      expect(
        theme.filledButtonTheme.style?.backgroundColor?.resolve({}),
        AppBrandColors.primaryBlue,
      );
      expect(
        theme.outlinedButtonTheme.style?.foregroundColor?.resolve({}),
        AppBrandColors.primaryBlue,
      );
      expect(
        theme.textButtonTheme.style?.foregroundColor?.resolve({}),
        AppBrandColors.primaryBlue,
      );
      expect(theme.tabBarTheme.labelColor, AppBrandColors.primaryBlue);
      expect(theme.tabBarTheme.indicatorColor, AppBrandColors.primaryBlue);
      expect(theme.progressIndicatorTheme.color, AppBrandColors.primaryBlue);
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
}
