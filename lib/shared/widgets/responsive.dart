import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

extension ResponsiveX on BuildContext {
  WindowSize get windowSize =>
      WindowSize.fromWidth(MediaQuery.sizeOf(this).width);

  bool get isCompact =>
      MediaQuery.sizeOf(this).width < ResponsiveBreakpoints.tablet;

  bool get isTablet =>
      MediaQuery.sizeOf(this).width >= ResponsiveBreakpoints.tablet;

  bool get isWideTablet =>
      MediaQuery.sizeOf(this).width >= ResponsiveBreakpoints.wideTablet;

  double get screenWidth => MediaQuery.sizeOf(this).width;
}

/// Adaptive layout builder that switches based on available parent constraints
/// rather than device model checks.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.tablet,
    this.wideTablet,
  });

  final WidgetBuilder compact;
  final WidgetBuilder? tablet;
  final WidgetBuilder? wideTablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ResponsiveBreakpoints.wideTablet &&
            wideTablet != null) {
          return wideTablet!(context);
        }
        if (constraints.maxWidth >= ResponsiveBreakpoints.tablet &&
            tablet != null) {
          return tablet!(context);
        }
        return compact(context);
      },
    );
  }
}

/// Centers [child] and caps its width so content stays readable on tablets
/// and desktop, while using the full width on phones.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = AppLayout.maxContentWidth,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
