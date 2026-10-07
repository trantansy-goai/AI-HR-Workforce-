import 'package:flutter/material.dart';

import 'app_tokens.dart';

/// Corner radius used by inputs, buttons and notice boxes in the HR mockups.
const hrBoxRadius = BorderRadius.all(Radius.circular(10));

/// Scopes the GO AI HR mockups' brand-blue accent, white inputs and 10dp radii to
/// a screen so shared widgets (AppButton, AppTextField) pick them up.
/// Wrap the screen in `Theme(data: hrScopedTheme(Theme.of(context)))`.
ThemeData hrScopedTheme(ThemeData base) {
  final scheme = base.colorScheme.copyWith(
    primary: AppHrPalette.accent,
    onPrimary: Colors.white,
    secondaryContainer: AppHrPalette.accentSoft,
    onSecondaryContainer: AppHrPalette.accent,
    surface: AppHrPalette.surface,
    onSurface: AppHrPalette.ink,
    onSurfaceVariant: AppHrPalette.inkMuted,
  );
  const buttonText = TextStyle(fontSize: 15, fontWeight: FontWeight.w800);
  OutlineInputBorder outline(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: hrBoxRadius,
        borderSide: BorderSide(color: color, width: width),
      );

  return base.copyWith(
    colorScheme: scheme,
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      filled: true,
      fillColor: AppHrPalette.surface,
      hintStyle: const TextStyle(color: AppHrPalette.inkMuted, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 15,
      ),
      border: outline(AppHrPalette.border),
      enabledBorder: outline(AppHrPalette.border),
      disabledBorder: outline(AppHrPalette.divider),
      focusedBorder: outline(AppHrPalette.accent, 1.5),
      errorBorder: outline(scheme.error),
      focusedErrorBorder: outline(scheme.error, 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: const RoundedRectangleBorder(borderRadius: hrBoxRadius),
        textStyle: buttonText,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppHrPalette.accent,
        minimumSize: const Size(64, 48),
        side: const BorderSide(color: AppHrPalette.border),
        shape: const RoundedRectangleBorder(borderRadius: hrBoxRadius),
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppHrPalette.accent,
        textStyle: buttonText,
      ),
    ),
  );
}
