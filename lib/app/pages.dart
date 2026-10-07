import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/localization/l10n.dart';
import '../shared/widgets/state_views.dart';
import 'router/app_routes.dart';

/// Shown while the session is being restored.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final logoWidth = (screenWidth * 0.6).clamp(200.0, 320.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/goai_logo.png',
          width: logoWidth,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(),
      body: EmptyView(
        icon: Icons.explore_off_outlined,
        title: l10n.notFoundTitle,
        message: l10n.notFoundMessage,
        action: FilledButton(
          onPressed: () => context.go(AppRoutes.home),
          child: Text(l10n.notFoundGoHome),
        ),
      ),
    );
  }
}
