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
import '../../features/chat/presentation/ask_hr_answer_page.dart';
import '../../features/chat/presentation/chat_hub_page.dart';
import '../../features/chat/presentation/conversation_page.dart';
import '../../features/chat/presentation/hoi_hr_tab.dart';
import '../../features/document/presentation/document_pages.dart';
import '../../features/elearning/presentation/elearning_hub_page.dart';
import '../../features/elearning/presentation/learning_pages.dart';
import '../../features/home/presentation/foundation_showcase_page.dart';
import '../../features/home/presentation/trang_chu_page.dart';
import '../../features/my_work/presentation/my_work_page.dart';
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
  final sub = ref.listen<SessionStatus>(sessionStatusProvider, (_, next) {
    refresh.value = next;
  });
  ref.onDispose(() {
    sub.close();
    refresh.dispose();
  });

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
          // Branch 0: Trang chủ (Workspace Dashboard)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const TrangChuPage(),
              ),
            ],
          ),
          // Branch 1: Hỏi HR
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.askHr,
                builder: (context, state) => const HoiHrTab(),
                routes: [
                  GoRoute(
                    path: 'answer',
                    builder: (context, state) => const AskHrAnswerPage(),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Việc của tôi
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.myWork,
                builder: (context, state) => MyWorkPage(
                  openNewRequest:
                      state.uri.queryParameters['newRequest'] == '1',
                ),
              ),
            ],
          ),
          // Branch 3: Học tập (E-learning & Online Tests)
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
          // Branch 4: Tài khoản (Profile & Account)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'chats',
                    builder: (context, state) => const ChatHubPage(),
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
                          conversationId:
                              state.pathParameters['conversationId']!,
                          initialMessage: state.uri.queryParameters['q'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Deep detail & secondary standalone routes on rootNavigatorKey
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.news,
        builder: (context, state) => const NewsListPage(),
        routes: [
          GoRoute(
            parentNavigatorKey: rootNavigatorKey,
            path: ':newsId',
            builder: (context, state) =>
                NewsDetailPage(newsId: state.pathParameters['newsId']!),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
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
