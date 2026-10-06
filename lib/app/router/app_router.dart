import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/session_status.dart';
import '../../core/navigation/route_access.dart';
import '../../features/approval/presentation/approval_pages.dart';
import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/presentation/sign_in_page.dart';
import '../../features/chat/presentation/agent_conversation_list_page.dart';
import '../../features/chat/presentation/chat_discovery_page.dart';
import '../../features/chat/presentation/conversation_page.dart';
import '../../features/document/presentation/document_pages.dart';
import '../../features/elearning/presentation/elearning_hub_page.dart';
import '../../features/elearning/presentation/learning_pages.dart';
import '../../features/home/presentation/foundation_showcase_page.dart';
import '../../features/home/presentation/timeline_page.dart';
import '../../features/news/presentation/news_pages.dart';
import '../../features/notification/presentation/notification_list_page.dart';
import '../../features/online_test/presentation/test_pages.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../pages.dart';
import 'app_routes.dart';
import 'workspace_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Session status for routing, decoupled from the auth feature's types.
final sessionStatusProvider = Provider<SessionStatus>(
  (ref) => ref.watch(authControllerProvider.select((s) => s.status)),
);

final routerProvider = Provider<GoRouter>((ref) {
  const guard = RouteGuard(
    rules: AppRoutes.access,
    splashPath: AppRoutes.splash,
    signInPath: AppRoutes.signIn,
    homePath: AppRoutes.home,
  );

  // Re-evaluate redirects whenever the session status changes, without
  // rebuilding the router (which would reset navigation state).
  final refresh = ValueNotifier<SessionStatus>(ref.read(sessionStatusProvider));
  ref
    ..listen(sessionStatusProvider, (_, next) => refresh.value = next)
    ..onDispose(refresh.dispose);

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refresh,
    redirect: (context, state) =>
        guard.redirect(status: refresh.value, location: state.uri),
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            WorkspaceShell(navigationShell: navigationShell),
        branches: [
          // Branch 0: Timeline (default landing tab)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const TimelinePage(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: 'news/:newsId',
                    builder: (context, state) =>
                        NewsDetailPage(newsId: state.pathParameters['newsId']!),
                  ),
                ],
              ),
            ],
          ),
          // Branch 1: Chat
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chat,
                builder: (context, state) => const ChatDiscoveryPage(),
                routes: [
                  GoRoute(
                    path: 'agent/:agentId',
                    builder: (context, state) => AgentConversationListPage(
                      agentId: state.pathParameters['agentId']!,
                    ),
                  ),
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: ':conversationId',
                    builder: (context, state) => ConversationPage(
                      conversationId: state.pathParameters['conversationId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: E-learning
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.learning,
                builder: (context, state) => const ELearningHubPage(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: ':courseId',
                    builder: (context, state) => LearningDetailPage(
                      courseId: state.pathParameters['courseId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 3: Documents
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.documents,
                builder: (context, state) => const DocumentListPage(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: ':documentId',
                    builder: (context, state) => DocumentDetailPage(
                      documentId: state.pathParameters['documentId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 4: My Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      // Deep detail & secondary standalone routes on rootNavigatorKey
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/home/tests/:testId',
        builder: (context, state) =>
            TestTakingPage(testId: state.pathParameters['testId']!),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationListPage(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.approvals,
        builder: (context, state) => const ApprovalListPage(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.showcase,
        builder: (context, state) => const FoundationShowcasePage(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
