import 'package:flutter/widgets.dart';

/// Spacing scale (logical pixels). Use these instead of magic numbers.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Corner radius scale.
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
}

/// Width breakpoints, following Material 3 window size classes.
enum WindowSize {
  compact,
  medium,
  expanded;

  static WindowSize fromWidth(double width) {
    if (width < ResponsiveBreakpoints.tablet) return WindowSize.compact;
    if (width < ResponsiveBreakpoints.desktop) return WindowSize.medium;
    return WindowSize.expanded;
  }
}

/// Centralized responsive breakpoints based on logical width constraints.
abstract final class ResponsiveBreakpoints {
  /// Handset breakpoint (phones < 600dp).
  static const double compact = 0;

  /// Tablet breakpoint (portrait tablets, foldables >= 600dp).
  static const double tablet = 600;

  /// Wide tablet breakpoint (landscape tablets, split views >= 840dp).
  static const double wideTablet = 840;

  /// Large desktop / expanded screen threshold (>= 1200dp).
  static const double desktop = 1200;
}

/// Centralized content width constraints preventing stretched layouts.
abstract final class ContentConstraints {
  /// Standard max width for reading text, articles, settings, and forms (720-760dp).
  static const double reading = 760;

  /// Max width for multi-column dashboards and workspaces (1000-1140dp).
  static const double dashboard = 1100;

  /// Max width for chat conversation container (760-840dp).
  static const double chat = 800;

  /// Max width for focused dialogs and cards.
  static const double dialog = 560;
}

/// Centralized responsive padding tokens.
abstract final class ResponsivePadding {
  static const EdgeInsets compact = EdgeInsets.all(AppSpacing.md);
  static const EdgeInsets tablet = EdgeInsets.all(AppSpacing.xl);
  static const EdgeInsets wideTablet = EdgeInsets.symmetric(
    horizontal: AppSpacing.xxl,
    vertical: AppSpacing.xl,
  );
}

abstract final class AppLayout {
  /// Max width for reading/form content on large screens.
  static const double maxContentWidth = ContentConstraints.reading;
}

/// Centralized brand colors derived directly from the official GoAI logo.
abstract final class AppBrandColors {
  /// Dominant deep blue sampled from the "Go" letters in the official logo.
  /// RGB: (14, 60, 175) -> #0E3CAF.
  /// Contrast ratio on white is 9.15:1 (exceeds WCAG AAA requirement of 7:1).
  static const Color primaryBlue = Color(0xFF0E3CAF);

  /// Secondary brand accent sampled from the "AI" letters in the official logo.
  /// RGB: (217, 159, 55) -> #D99F37.
  /// Used sparingly for branding highlights, badges, and warning accents.
  static const Color secondaryGold = Color(0xFFD99F37);
}
