// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonClose => 'Close';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonEmpty => 'Nothing here yet';

  @override
  String get commonErrorTitle => 'Something went wrong';

  @override
  String get errorNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorTimeout => 'The request took too long. Please try again.';

  @override
  String get errorUnauthorized =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorForbidden => 'You don\'t have permission to do this.';

  @override
  String get errorNotFound => 'The requested item could not be found.';

  @override
  String get errorValidation =>
      'Some information is invalid. Please check and try again.';

  @override
  String get errorServer => 'The server had a problem. Please try again later.';

  @override
  String get errorStorage => 'Could not access device storage.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String get authSignInTitle => 'Welcome back';

  @override
  String get authSignInSubtitle =>
      'Please verify your account to view your information.';

  @override
  String get authSecurityBadge => 'SECURITY';

  @override
  String get authBrandEyebrow => 'GO AI · HR WORKFORCE';

  @override
  String get authEmployeeAccountLabel => 'Employee ID or company account';

  @override
  String get authEmployeeAccountHint => 'Enter employee ID or company account';

  @override
  String get authPhoneNumberLabel => 'Registered phone number';

  @override
  String get authPhoneNumberHint => 'Enter registered phone number';

  @override
  String get authSendVerificationCode => 'Send verification code';

  @override
  String get authSsoPrompt => 'Enterprise has SSO?';

  @override
  String get authSsoButton => 'Company sign-in';

  @override
  String get authSsoBlockedMessage =>
      'Enterprise SSO login is awaiting backend infrastructure connection (BLOCKED).';

  @override
  String get authFirstTimeTitle => 'First-time user';

  @override
  String get authFirstTimeBody =>
      'HR issues activation code; verify phone number then set PIN on device.';

  @override
  String get authSharedDeviceNotice =>
      'Using a shared phone? Sign out completely after each session.';

  @override
  String get authAccountRequired =>
      'Please enter employee ID or company account';

  @override
  String get authPhoneRequired => 'Please enter registered phone number';

  @override
  String get authSecurityDialogTitle => 'Enterprise Security';

  @override
  String get authSecurityDialogMessage =>
      'Your session and data are protected with end-to-end encryption complying with enterprise HR security policies.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authSignInButton => 'Sign in';

  @override
  String get authContinueAsGuest => 'Continue as guest';

  @override
  String get authEmailInvalid => 'Enter a valid email address';

  @override
  String authPasswordTooShort(int min) {
    return 'Password must be at least $min characters';
  }

  @override
  String get authDemoHint =>
      'Demo mode: enter any employee ID/phone or continue as guest.';

  @override
  String get authSignOut => 'Sign out';

  @override
  String get authSignOutConfirmTitle => 'Sign out?';

  @override
  String get authSignOutConfirmMessage =>
      'You will need to sign in again to continue.';

  @override
  String get authGuestName => 'Guest';

  @override
  String get homeTitle => 'Home';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeSubtitle =>
      'This base app demonstrates reusable foundation modules.';

  @override
  String get homeChatTitle => 'Chat demo';

  @override
  String get homeChatSubtitle => 'Generic chat engine with a mock provider';

  @override
  String get homeSettingsTitle => 'Settings';

  @override
  String get homeSettingsSubtitle => 'Theme, language and app info';

  @override
  String get homeShowcaseTitle => 'Foundation showcase';

  @override
  String get homeShowcaseSubtitle => 'Design system components and states';

  @override
  String get homeProfileTitle => 'Profile';

  @override
  String get homeProfileSubtitle => 'Current user and session';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAppName => 'App name';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsEnvironment => 'Environment';

  @override
  String get settingsAccount => 'Account';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileUserId => 'User ID';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileNoEmail => 'Not provided';

  @override
  String get profileGuestBadge => 'Guest session';

  @override
  String get chatTitle => 'Conversations';

  @override
  String get chatEmptyConversations => 'No conversations yet';

  @override
  String get chatEmptyMessages => 'No messages yet. Say hello!';

  @override
  String get chatComposerHint => 'Type a message';

  @override
  String get chatSend => 'Send';

  @override
  String get chatAttach => 'Attach file';

  @override
  String get chatStop => 'Stop generating';

  @override
  String get chatRegenerate => 'Regenerate';

  @override
  String get chatFailed => 'Not sent. Tap to retry.';

  @override
  String chatReplyingTo(String name) {
    return 'Replying to $name';
  }

  @override
  String get chatReply => 'Reply';

  @override
  String get chatCancelReply => 'Cancel reply';

  @override
  String chatTyping(String name) {
    return '$name is typing…';
  }

  @override
  String get chatSources => 'Sources';

  @override
  String get chatYou => 'You';

  @override
  String get chatDemoHint =>
      'Tip: include \"/fail\" in a message to simulate a failed send.';

  @override
  String get chatUploading => 'Uploading…';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notFoundMessage => 'The page you are looking for does not exist.';

  @override
  String get notFoundGoHome => 'Go to home';

  @override
  String get showcaseTitle => 'Foundation showcase';

  @override
  String get showcaseButtons => 'Buttons';

  @override
  String get showcasePrimary => 'Primary';

  @override
  String get showcaseSecondary => 'Secondary';

  @override
  String get showcaseTextButton => 'Text';

  @override
  String get showcaseInputs => 'Inputs';

  @override
  String get showcaseSampleInput => 'Sample input';

  @override
  String get showcaseStates => 'States';

  @override
  String get showcaseFeedback => 'Feedback';

  @override
  String get showcaseShowDialog => 'Show dialog';

  @override
  String get showcaseDialogMessage => 'This is a reusable confirmation dialog.';

  @override
  String get showcaseShowSnackbar => 'Show snackbar';

  @override
  String get showcaseSnackbarMessage => 'This is a reusable snackbar.';

  @override
  String get showcaseSendNotification => 'Send in-app notification';

  @override
  String get showcaseNotificationTitle => 'Hello from the notification center';

  @override
  String get showcaseNotificationBody =>
      'In-app notifications are delivered through a replaceable service.';

  @override
  String get showcaseAttachments => 'Attachments';

  @override
  String get mainNavHome => 'Home';

  @override
  String get mainNavAskHr => 'Ask HR';

  @override
  String get mainNavMyWork => 'My Work';

  @override
  String get mainNavLearning => 'Learning';

  @override
  String get mainNavAccount => 'Account';

  @override
  String get mainNavTimeline => 'Home';

  @override
  String get mainNavChat => 'Ask HR';

  @override
  String get mainNavDocuments => 'Document';

  @override
  String get mainNavProfile => 'Account';

  @override
  String get headerSubtitle => 'Enterprise AI Assistant & Employee Workspace';

  @override
  String get headerTokenQuota => 'Token quota';

  @override
  String get headerQuotaUnavailable => 'Quota unavailable';

  @override
  String get headerQuotaExceeded => 'Quota exceeded';

  @override
  String get headerQuotaWarning => 'Quota warning';

  @override
  String get notificationTitle => 'Notifications';

  @override
  String get notificationEmpty => 'No notifications yet';

  @override
  String get chatAiAgents => 'AI & HR AGENTS';

  @override
  String get chatOther => 'OTHER';

  @override
  String get chatHumanBlockedHint =>
      'Remote human chat is awaiting backend contract (BLOCKED)';

  @override
  String get chatStartNew => 'Start new conversation';

  @override
  String chatAgentHistory(String name) {
    return '$name History';
  }

  @override
  String get profileApprovals => 'Pending Approvals';

  @override
  String get profileSettings => 'Settings';

  @override
  String get elearningCourses => 'Courses & Training';

  @override
  String get elearningTests => 'Certification Tests';

  @override
  String get myWorkTitle => 'My Work';

  @override
  String get myWorkChecklistTitle => 'Onboarding Checklist';

  @override
  String get myWorkCasesTitle => 'My Cases & Requests';

  @override
  String get myWorkApprovalsTitle => 'Pending My Approval';

  @override
  String get homeNewsSection => 'COMPANY NEWS';

  @override
  String get homeViewAllNews => 'View all';

  @override
  String get homeUpcomingWork => 'Upcoming Work';

  @override
  String get homeMyCourses => 'My Courses';

  @override
  String get homePendingCase => 'HR Request #HR-1042';

  @override
  String homePendingTasksStrip(int count) {
    return 'You have $count tasks to complete this week.';
  }

  @override
  String get accountNews => 'Internal News & Bulletins';

  @override
  String get askHrSearchPrompt => 'Type a question… e.g. leave policy';

  @override
  String get askHrPolicyChip => 'Policy';

  @override
  String get askHrFormChip => 'Forms';

  @override
  String get askHrMyRequestsChip => 'My Requests';
}
