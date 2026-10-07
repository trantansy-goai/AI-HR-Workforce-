import '../../core/navigation/route_access.dart';

/// Route paths in one place. Use these constants instead of string literals.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const signIn = '/sign-in';
  static const home = '/home';
  static const askHr = '/home/ask-hr';
  static const chat = askHr;
  static const myWork = '/home/my-work';
  static const learning = '/home/learning';
  static const account = '/home/account';

  /// Chat list parked under Account until it gets a permanent home.
  static const chats = '$account/chats';
  static const askHrAnswer = '$askHr/answer';

  /// Việc tab with the "Gửi yêu cầu HR" dialog opened.
  static const myWorkNewRequest = '$myWork?newRequest=1';
  static const profile = account;
  static const settings = '/home/settings';
  static const showcase = '/home/showcase';
  static const documents = '/home/documents';
  static const tests = '/home/tests';
  static const news = '/home/news';
  static const approvals = '/home/approvals';
  static const notifications = '/home/notifications';

  static String conversation(String id, {String? initialMessage}) => Uri(
    path: '$chats/${Uri.encodeComponent(id)}',
    queryParameters: initialMessage == null ? null : {'q': initialMessage},
  ).toString();
  static String agentHistory(String agentId) =>
      '$chats/agent/${Uri.encodeComponent(agentId)}';
  static String document(String id) => '$documents/${Uri.encodeComponent(id)}';
  static String course(String id) => '$learning/${Uri.encodeComponent(id)}';
  static String test(String id) => '$tests/${Uri.encodeComponent(id)}';
  static String article(String id) => '$news/${Uri.encodeComponent(id)}';

  /// Access rules by path prefix; the most specific prefix wins.
  /// Unlisted paths default to [RouteAccess.signedIn].
  static const access = <String, RouteAccess>{
    splash: RouteAccess.public,
    signIn: RouteAccess.signedOutOnly,
    home: RouteAccess.signedIn,
  };
}
