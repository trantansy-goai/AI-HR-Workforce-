import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get commonEmpty;

  /// No description provided for @commonErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonErrorTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do this.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested item could not be found.'**
  String get errorNotFound;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Some information is invalid. Please check and try again.'**
  String get errorValidation;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The server had a problem. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorStorage.
  ///
  /// In en, this message translates to:
  /// **'Could not access device storage.'**
  String get errorStorage;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorUnknown;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please verify your account to view your information.'**
  String get authSignInSubtitle;

  /// No description provided for @authHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'GO AI HR'**
  String get authHeaderTitle;

  /// No description provided for @authSecurityBadge.
  ///
  /// In en, this message translates to:
  /// **'SECURITY'**
  String get authSecurityBadge;

  /// No description provided for @authBrandEyebrow.
  ///
  /// In en, this message translates to:
  /// **'GO AI · HR WORKFORCE'**
  String get authBrandEyebrow;

  /// No description provided for @authEmployeeAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee ID or company account'**
  String get authEmployeeAccountLabel;

  /// No description provided for @authEmployeeAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter employee ID or company account'**
  String get authEmployeeAccountHint;

  /// No description provided for @authPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Registered phone number'**
  String get authPhoneNumberLabel;

  /// No description provided for @authPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter registered phone number'**
  String get authPhoneNumberHint;

  /// No description provided for @authSendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get authSendVerificationCode;

  /// No description provided for @authSsoPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enterprise has SSO? Choose \"Company sign-in\".'**
  String get authSsoPrompt;

  /// No description provided for @authSsoButton.
  ///
  /// In en, this message translates to:
  /// **'Company sign-in'**
  String get authSsoButton;

  /// No description provided for @authFirstTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'First-time user'**
  String get authFirstTimeTitle;

  /// No description provided for @authFirstTimeBody.
  ///
  /// In en, this message translates to:
  /// **'HR issues activation code; verify phone number then set PIN on device.'**
  String get authFirstTimeBody;

  /// No description provided for @authSharedDeviceNotice.
  ///
  /// In en, this message translates to:
  /// **'Using a shared phone? Sign out completely after each session.'**
  String get authSharedDeviceNotice;

  /// No description provided for @authAccountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter employee ID or company account'**
  String get authAccountRequired;

  /// No description provided for @authPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter registered phone number'**
  String get authPhoneRequired;

  /// No description provided for @authSecurityDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Security'**
  String get authSecurityDialogTitle;

  /// No description provided for @authSecurityDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session and data are protected with end-to-end encryption complying with enterprise HR security policies.'**
  String get authSecurityDialogMessage;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get authPasswordRequired;

  /// No description provided for @authSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignInButton;

  /// No description provided for @authContinueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get authContinueAsGuest;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {min} characters'**
  String authPasswordTooShort(int min);

  /// No description provided for @authDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: enter any employee ID/phone or continue as guest.'**
  String get authDemoHint;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOut;

  /// No description provided for @authSignOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get authSignOutConfirmTitle;

  /// No description provided for @authSignOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to continue.'**
  String get authSignOutConfirmMessage;

  /// No description provided for @authGuestName.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get authGuestName;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'GO AI Workforce for employees.'**
  String get homeSubtitle;

  /// No description provided for @homeChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat demo'**
  String get homeChatTitle;

  /// No description provided for @homeChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generic chat engine with a mock provider'**
  String get homeChatSubtitle;

  /// No description provided for @homeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettingsTitle;

  /// No description provided for @homeSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Language and app info'**
  String get homeSettingsSubtitle;

  /// No description provided for @homeShowcaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Foundation showcase'**
  String get homeShowcaseTitle;

  /// No description provided for @homeShowcaseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Design system components and states'**
  String get homeShowcaseSubtitle;

  /// No description provided for @homeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeProfileTitle;

  /// No description provided for @homeProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current user and session'**
  String get homeProfileSubtitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAppName.
  ///
  /// In en, this message translates to:
  /// **'App name'**
  String get settingsAppName;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get settingsEnvironment;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileUserId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get profileUserId;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileNoEmail.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get profileNoEmail;

  /// No description provided for @profileGuestBadge.
  ///
  /// In en, this message translates to:
  /// **'Guest session'**
  String get profileGuestBadge;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversations'**
  String get chatTitle;

  /// No description provided for @chatEmptyConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get chatEmptyConversations;

  /// No description provided for @chatEmptyMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Say hello!'**
  String get chatEmptyMessages;

  /// No description provided for @chatComposerHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get chatComposerHint;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatAttach.
  ///
  /// In en, this message translates to:
  /// **'Attach file'**
  String get chatAttach;

  /// No description provided for @chatStop.
  ///
  /// In en, this message translates to:
  /// **'Stop generating'**
  String get chatStop;

  /// No description provided for @chatRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get chatRegenerate;

  /// No description provided for @chatFailed.
  ///
  /// In en, this message translates to:
  /// **'Not sent. Tap to retry.'**
  String get chatFailed;

  /// No description provided for @chatReplyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to {name}'**
  String chatReplyingTo(String name);

  /// No description provided for @chatReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get chatReply;

  /// No description provided for @chatCancelReply.
  ///
  /// In en, this message translates to:
  /// **'Cancel reply'**
  String get chatCancelReply;

  /// No description provided for @chatTyping.
  ///
  /// In en, this message translates to:
  /// **'{name} is typing…'**
  String chatTyping(String name);

  /// No description provided for @chatSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get chatSources;

  /// No description provided for @chatYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get chatYou;

  /// No description provided for @chatDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: include \"/fail\" in a message to simulate a failed send.'**
  String get chatDemoHint;

  /// No description provided for @chatUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get chatUploading;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// No description provided for @notFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The page you are looking for does not exist.'**
  String get notFoundMessage;

  /// No description provided for @notFoundGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get notFoundGoHome;

  /// No description provided for @showcaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Foundation showcase'**
  String get showcaseTitle;

  /// No description provided for @showcaseButtons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get showcaseButtons;

  /// No description provided for @showcasePrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get showcasePrimary;

  /// No description provided for @showcaseSecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get showcaseSecondary;

  /// No description provided for @showcaseTextButton.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get showcaseTextButton;

  /// No description provided for @showcaseInputs.
  ///
  /// In en, this message translates to:
  /// **'Inputs'**
  String get showcaseInputs;

  /// No description provided for @showcaseSampleInput.
  ///
  /// In en, this message translates to:
  /// **'Sample input'**
  String get showcaseSampleInput;

  /// No description provided for @showcaseStates.
  ///
  /// In en, this message translates to:
  /// **'States'**
  String get showcaseStates;

  /// No description provided for @showcaseFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get showcaseFeedback;

  /// No description provided for @showcaseShowDialog.
  ///
  /// In en, this message translates to:
  /// **'Show dialog'**
  String get showcaseShowDialog;

  /// No description provided for @showcaseDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This is a reusable confirmation dialog.'**
  String get showcaseDialogMessage;

  /// No description provided for @showcaseShowSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Show snackbar'**
  String get showcaseShowSnackbar;

  /// No description provided for @showcaseSnackbarMessage.
  ///
  /// In en, this message translates to:
  /// **'This is a reusable snackbar.'**
  String get showcaseSnackbarMessage;

  /// No description provided for @showcaseSendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send in-app notification'**
  String get showcaseSendNotification;

  /// No description provided for @showcaseNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello from the notification center'**
  String get showcaseNotificationTitle;

  /// No description provided for @showcaseNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'In-app notifications are delivered through a replaceable service.'**
  String get showcaseNotificationBody;

  /// No description provided for @showcaseAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get showcaseAttachments;

  /// No description provided for @mainNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainNavHome;

  /// No description provided for @mainNavAskHr.
  ///
  /// In en, this message translates to:
  /// **'Ask HR'**
  String get mainNavAskHr;

  /// No description provided for @mainNavMyWork.
  ///
  /// In en, this message translates to:
  /// **'My Work'**
  String get mainNavMyWork;

  /// No description provided for @mainNavLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get mainNavLearning;

  /// No description provided for @mainNavAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get mainNavAccount;

  /// No description provided for @mainNavTimeline.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainNavTimeline;

  /// No description provided for @mainNavChat.
  ///
  /// In en, this message translates to:
  /// **'Ask HR'**
  String get mainNavChat;

  /// No description provided for @mainNavDocuments.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get mainNavDocuments;

  /// No description provided for @mainNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get mainNavProfile;

  /// No description provided for @headerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise AI Assistant & Employee Workspace'**
  String get headerSubtitle;

  /// No description provided for @headerTokenQuota.
  ///
  /// In en, this message translates to:
  /// **'Token quota'**
  String get headerTokenQuota;

  /// No description provided for @headerQuotaUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Quota unavailable'**
  String get headerQuotaUnavailable;

  /// No description provided for @headerQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'Quota exceeded'**
  String get headerQuotaExceeded;

  /// No description provided for @headerQuotaWarning.
  ///
  /// In en, this message translates to:
  /// **'Quota warning'**
  String get headerQuotaWarning;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationTitle;

  /// No description provided for @notificationEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationEmpty;

  /// No description provided for @chatAiAgents.
  ///
  /// In en, this message translates to:
  /// **'AI & HR AGENTS'**
  String get chatAiAgents;

  /// No description provided for @chatOther.
  ///
  /// In en, this message translates to:
  /// **'OTHER'**
  String get chatOther;

  /// No description provided for @chatHumanBlockedHint.
  ///
  /// In en, this message translates to:
  /// **'Remote human chat is awaiting backend contract (BLOCKED)'**
  String get chatHumanBlockedHint;

  /// No description provided for @chatStartNew.
  ///
  /// In en, this message translates to:
  /// **'Start new conversation'**
  String get chatStartNew;

  /// No description provided for @chatAgentHistory.
  ///
  /// In en, this message translates to:
  /// **'{name} History'**
  String chatAgentHistory(String name);

  /// No description provided for @profileApprovals.
  ///
  /// In en, this message translates to:
  /// **'Pending Approvals'**
  String get profileApprovals;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @elearningCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses & Training'**
  String get elearningCourses;

  /// No description provided for @elearningTests.
  ///
  /// In en, this message translates to:
  /// **'Certification Tests'**
  String get elearningTests;

  /// No description provided for @myWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'My Work'**
  String get myWorkTitle;

  /// No description provided for @myWorkChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Onboarding Checklist'**
  String get myWorkChecklistTitle;

  /// No description provided for @myWorkCasesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Cases & Requests'**
  String get myWorkCasesTitle;

  /// No description provided for @myWorkApprovalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending My Approval'**
  String get myWorkApprovalsTitle;

  /// No description provided for @homeNewsSection.
  ///
  /// In en, this message translates to:
  /// **'COMPANY NEWS'**
  String get homeNewsSection;

  /// No description provided for @homeViewAllNews.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get homeViewAllNews;

  /// No description provided for @homeUpcomingWork.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Work'**
  String get homeUpcomingWork;

  /// No description provided for @homeMyCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get homeMyCourses;

  /// No description provided for @homePendingCase.
  ///
  /// In en, this message translates to:
  /// **'HR Request #HR-1042'**
  String get homePendingCase;

  /// No description provided for @accountNews.
  ///
  /// In en, this message translates to:
  /// **'Internal News & Bulletins'**
  String get accountNews;

  /// No description provided for @askHrSearchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Type a question… e.g. leave policy'**
  String get askHrSearchPrompt;

  /// No description provided for @askHrPolicyChip.
  ///
  /// In en, this message translates to:
  /// **'Policy'**
  String get askHrPolicyChip;

  /// No description provided for @askHrFormChip.
  ///
  /// In en, this message translates to:
  /// **'Forms'**
  String get askHrFormChip;

  /// No description provided for @askHrMyRequestsChip.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get askHrMyRequestsChip;

  /// No description provided for @homeAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'GO AI · HR'**
  String get homeAppBarTitle;

  /// No description provided for @homeHeroGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {name} 👋'**
  String homeHeroGreeting(String name);

  /// No description provided for @homePendingTasksLead.
  ///
  /// In en, this message translates to:
  /// **'You have '**
  String get homePendingTasksLead;

  /// No description provided for @homePendingTasksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task} other{{count} tasks}}'**
  String homePendingTasksCount(int count);

  /// No description provided for @homePendingTasksTail.
  ///
  /// In en, this message translates to:
  /// **' to finish this week.'**
  String get homePendingTasksTail;

  /// No description provided for @homeAskPolicyAction.
  ///
  /// In en, this message translates to:
  /// **'Ask policy'**
  String get homeAskPolicyAction;

  /// No description provided for @homeSendRequestAction.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get homeSendRequestAction;

  /// No description provided for @homeUpcomingWorkDetail.
  ///
  /// In en, this message translates to:
  /// **'Finish onboarding checklist · due 10/10'**
  String get homeUpcomingWorkDetail;

  /// No description provided for @homeMyCoursesDetail.
  ///
  /// In en, this message translates to:
  /// **'Basic workplace safety · 12 min left'**
  String get homeMyCoursesDetail;

  /// No description provided for @homePendingCaseDetail.
  ///
  /// In en, this message translates to:
  /// **'Waiting for HR · expected 09/10'**
  String get homePendingCaseDetail;

  /// No description provided for @homeQuotaTitle.
  ///
  /// In en, this message translates to:
  /// **'AI token quota'**
  String get homeQuotaTitle;

  /// No description provided for @homeNewsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No news yet.'**
  String get homeNewsEmpty;

  /// No description provided for @homeNewsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading news...'**
  String get homeNewsLoading;

  /// No description provided for @askHrTitle.
  ///
  /// In en, this message translates to:
  /// **'How can HR help?'**
  String get askHrTitle;

  /// No description provided for @askHrSend.
  ///
  /// In en, this message translates to:
  /// **'Send question'**
  String get askHrSend;

  /// No description provided for @askHrSampleQuestion.
  ///
  /// In en, this message translates to:
  /// **'I need to see the leave policy.'**
  String get askHrSampleQuestion;

  /// No description provided for @askHrSampleAnswer.
  ///
  /// In en, this message translates to:
  /// **'I can summarise the current policy and link the approved version. Do you want the eligibility rules or how to submit a request?'**
  String get askHrSampleAnswer;

  /// No description provided for @askHrPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Personal information needs extra verification. Complaints open a confidential case for HR.'**
  String get askHrPrivacyNotice;

  /// No description provided for @askHrViewPolicySources.
  ///
  /// In en, this message translates to:
  /// **'View policy & sources'**
  String get askHrViewPolicySources;

  /// No description provided for @askHrAnswerTitle.
  ///
  /// In en, this message translates to:
  /// **'Annual leave policy'**
  String get askHrAnswerTitle;

  /// No description provided for @askHrAnswerBody.
  ///
  /// In en, this message translates to:
  /// **'Under the approved policy, you send a request to your manager following the company process. Exact eligibility depends on your contract type and remaining leave balance.'**
  String get askHrAnswerBody;

  /// No description provided for @askHrSourceEyebrow.
  ///
  /// In en, this message translates to:
  /// **'APPROVED SOURCE'**
  String get askHrSourceEyebrow;

  /// No description provided for @askHrSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave policy • version 2.1'**
  String get askHrSourceTitle;

  /// No description provided for @askHrSourceMeta.
  ///
  /// In en, this message translates to:
  /// **'Effective: 01/09/2026 · Owner: HR'**
  String get askHrSourceMeta;

  /// No description provided for @askHrSourcePath.
  ///
  /// In en, this message translates to:
  /// **'Company document library → accessible version → section 3.2'**
  String get askHrSourcePath;

  /// No description provided for @askHrSourceWarning.
  ///
  /// In en, this message translates to:
  /// **'No effective version found or conflicting info? Escalate to HR; don\'t treat the answer as definitive policy.'**
  String get askHrSourceWarning;

  /// No description provided for @askHrOpenSource.
  ///
  /// In en, this message translates to:
  /// **'Open original document'**
  String get askHrOpenSource;

  /// No description provided for @askHrCreateRequest.
  ///
  /// In en, this message translates to:
  /// **'Create HR request'**
  String get askHrCreateRequest;

  /// No description provided for @chatHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat list'**
  String get chatHubTitle;

  /// No description provided for @profileChatList.
  ///
  /// In en, this message translates to:
  /// **'Chat list'**
  String get profileChatList;

  /// No description provided for @profileChatListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI assistants & conversation history (temporary)'**
  String get profileChatListSubtitle;

  /// No description provided for @myWorkOnboardingEyebrow.
  ///
  /// In en, this message translates to:
  /// **'ONBOARDING'**
  String get myWorkOnboardingEyebrow;

  /// No description provided for @myWorkOnboardingRole.
  ///
  /// In en, this message translates to:
  /// **'Operations staff · Plant A'**
  String get myWorkOnboardingRole;

  /// No description provided for @myWorkOnboardingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Template: role + location + contract type · approved by HR'**
  String get myWorkOnboardingTemplate;

  /// No description provided for @myWorkOnboardingProgress.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} items confirmed'**
  String myWorkOnboardingProgress(int done, int total);

  /// No description provided for @myWorkOnboardingShowRest.
  ///
  /// In en, this message translates to:
  /// **'Show remaining items'**
  String get myWorkOnboardingShowRest;

  /// No description provided for @myWorkOnboardingCollapse.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get myWorkOnboardingCollapse;

  /// No description provided for @myWorkOnboardingEvidenceNote.
  ///
  /// In en, this message translates to:
  /// **'“Checklist complete” records evidence; the official record is updated by the source system after review.'**
  String get myWorkOnboardingEvidenceNote;

  /// No description provided for @myWorkCasesEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no cases yet.'**
  String get myWorkCasesEmpty;

  /// No description provided for @myWorkCaseUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String myWorkCaseUpdated(String date);

  /// No description provided for @myWorkStepReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get myWorkStepReceived;

  /// No description provided for @myWorkStepAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get myWorkStepAssigned;

  /// No description provided for @myWorkStepInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get myWorkStepInProgress;

  /// No description provided for @myWorkStepDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get myWorkStepDone;

  /// No description provided for @myWorkCaseStatusBody.
  ///
  /// In en, this message translates to:
  /// **'Expected response {date}. You\'ll be notified if more information is needed.'**
  String myWorkCaseStatusBody(String date);

  /// No description provided for @myWorkCaseSecureTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure exchange'**
  String get myWorkCaseSecureTitle;

  /// No description provided for @myWorkCaseSecureBody.
  ///
  /// In en, this message translates to:
  /// **'View and add details within your own case only.'**
  String get myWorkCaseSecureBody;

  /// No description provided for @myWorkCaseAddDocs.
  ///
  /// In en, this message translates to:
  /// **'Add documents'**
  String get myWorkCaseAddDocs;

  /// No description provided for @myWorkCaseDocsAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Attached 1 file to the case} other{Attached {count} files to the case}}'**
  String myWorkCaseDocsAdded(int count);

  /// No description provided for @myWorkCaseEscalationNote.
  ///
  /// In en, this message translates to:
  /// **'Overdue → A0 reminds and escalates to the owner.'**
  String get myWorkCaseEscalationNote;

  /// No description provided for @myWorkNewRequestButton.
  ///
  /// In en, this message translates to:
  /// **'New HR request'**
  String get myWorkNewRequestButton;

  /// No description provided for @myWorkNewRequest.
  ///
  /// In en, this message translates to:
  /// **'Send HR request'**
  String get myWorkNewRequest;

  /// No description provided for @myWorkRequestTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Request type: personal information confirmation'**
  String get myWorkRequestTypeHint;

  /// No description provided for @myWorkRequestTypePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal information confirmation'**
  String get myWorkRequestTypePersonalInfo;

  /// No description provided for @myWorkRequestTypeLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get myWorkRequestTypeLeave;

  /// No description provided for @myWorkRequestTypePolicy.
  ///
  /// In en, this message translates to:
  /// **'Policy & benefits'**
  String get myWorkRequestTypePolicy;

  /// No description provided for @myWorkRequestTypeComplaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint (confidential)'**
  String get myWorkRequestTypeComplaint;

  /// No description provided for @myWorkRequestTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a request type'**
  String get myWorkRequestTypeRequired;

  /// No description provided for @myWorkRequestDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Briefly describe what you need'**
  String get myWorkRequestDescriptionHint;

  /// No description provided for @myWorkRequestDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please describe your request'**
  String get myWorkRequestDescriptionRequired;

  /// No description provided for @myWorkRequestAttachHint.
  ///
  /// In en, this message translates to:
  /// **'Attach documents (if needed)'**
  String get myWorkRequestAttachHint;

  /// No description provided for @myWorkRequestAttached.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file attached} other{{count} files attached}}'**
  String myWorkRequestAttached(int count);

  /// No description provided for @myWorkRequestPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Share only what\'s needed. Sensitive information is routed to HR by permission.'**
  String get myWorkRequestPrivacyNotice;

  /// No description provided for @myWorkRequestSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get myWorkRequestSubmit;

  /// No description provided for @myWorkRequestAfterTitle.
  ///
  /// In en, this message translates to:
  /// **'After you submit'**
  String get myWorkRequestAfterTitle;

  /// No description provided for @myWorkRequestAfterBody.
  ///
  /// In en, this message translates to:
  /// **'You get a case code (e.g. #HR-1042) · expected response: 2 working days · handler: assigned HR.'**
  String get myWorkRequestAfterBody;

  /// No description provided for @myWorkRequestUrgentNote.
  ///
  /// In en, this message translates to:
  /// **'Complaints/urgent: routed straight to the authorised handler, not via your direct manager.'**
  String get myWorkRequestUrgentNote;

  /// No description provided for @myWorkRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Request sent · {id}'**
  String myWorkRequestSubmitted(String id);

  /// No description provided for @myWorkRoleEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get myWorkRoleEmployee;

  /// No description provided for @myWorkRoleHrAdmin.
  ///
  /// In en, this message translates to:
  /// **'HR / Admin'**
  String get myWorkRoleHrAdmin;

  /// No description provided for @myWorkRoleDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: choose a role to preview the Work tab'**
  String get myWorkRoleDemoHint;

  /// No description provided for @hrApprovalsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'FOR AUTHORISED APPROVERS'**
  String get hrApprovalsEyebrow;

  /// No description provided for @hrApprovalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Awaiting my approval'**
  String get hrApprovalsTitle;

  /// No description provided for @hrApprovalProbationTitle.
  ///
  /// In en, this message translates to:
  /// **'Probation review file'**
  String get hrApprovalProbationTitle;

  /// No description provided for @hrApprovalProbationMeta.
  ///
  /// In en, this message translates to:
  /// **'#PB-238 · Nguyen A · due 11/10'**
  String get hrApprovalProbationMeta;

  /// No description provided for @hrApprovalProbationBadge.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get hrApprovalProbationBadge;

  /// No description provided for @hrApprovalChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Checklist with exceptions'**
  String get hrApprovalChecklistTitle;

  /// No description provided for @hrApprovalChecklistMeta.
  ///
  /// In en, this message translates to:
  /// **'#ON-320 · missing documents · due 09/10'**
  String get hrApprovalChecklistMeta;

  /// No description provided for @hrApprovalChecklistBadge.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get hrApprovalChecklistBadge;

  /// No description provided for @hrApprovalsScopeNote.
  ///
  /// In en, this message translates to:
  /// **'2 items · rights follow position, unit, reporting line and authority level.'**
  String get hrApprovalsScopeNote;

  /// No description provided for @hrApprovalsOpenReview.
  ///
  /// In en, this message translates to:
  /// **'Open review file'**
  String get hrApprovalsOpenReview;

  /// No description provided for @hrApprovalsNoBulkNote.
  ///
  /// In en, this message translates to:
  /// **'There is no “Approve all” for probation decisions.'**
  String get hrApprovalsNoBulkNote;

  /// No description provided for @hrProbationTitle.
  ///
  /// In en, this message translates to:
  /// **'Probation review #PB-238'**
  String get hrProbationTitle;

  /// No description provided for @hrProbationChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist 12/13 items'**
  String get hrProbationChecklist;

  /// No description provided for @hrProbationTraining.
  ///
  /// In en, this message translates to:
  /// **'Mandatory training: confirmed'**
  String get hrProbationTraining;

  /// No description provided for @hrProbationManagerOpinion.
  ///
  /// In en, this message translates to:
  /// **'Manager opinion: needs more input'**
  String get hrProbationManagerOpinion;

  /// No description provided for @hrProbationMissingEvidence.
  ///
  /// In en, this message translates to:
  /// **'Evidence is missing. Request more information before deciding.'**
  String get hrProbationMissingEvidence;

  /// No description provided for @hrProbationCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Reviewer comments & rationale'**
  String get hrProbationCommentHint;

  /// No description provided for @hrProbationRequestMore.
  ///
  /// In en, this message translates to:
  /// **'Request more information'**
  String get hrProbationRequestMore;

  /// No description provided for @hrProbationEscalate.
  ///
  /// In en, this message translates to:
  /// **'Escalate to HR/Legal'**
  String get hrProbationEscalate;

  /// No description provided for @hrProbationDecisionNote.
  ///
  /// In en, this message translates to:
  /// **'Decision options appear only once conditions are met, rights are correct and you confirm again.'**
  String get hrProbationDecisionNote;

  /// No description provided for @hrQueueOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue {count}'**
  String hrQueueOverdue(int count);

  /// No description provided for @hrQueuePending.
  ///
  /// In en, this message translates to:
  /// **'Pending {count}'**
  String hrQueuePending(int count);

  /// No description provided for @hrQueueCase1Title.
  ///
  /// In en, this message translates to:
  /// **'Case #HR-1051'**
  String get hrQueueCase1Title;

  /// No description provided for @hrQueueCase1Meta.
  ///
  /// In en, this message translates to:
  /// **'Complaint · confidential routing · due today'**
  String get hrQueueCase1Meta;

  /// No description provided for @hrQueueCase2Title.
  ///
  /// In en, this message translates to:
  /// **'Case #ON-320'**
  String get hrQueueCase2Title;

  /// No description provided for @hrQueueCase2Meta.
  ///
  /// In en, this message translates to:
  /// **'Missing onboarding documents · owner: HR A'**
  String get hrQueueCase2Meta;

  /// No description provided for @hrQueueCase3Title.
  ///
  /// In en, this message translates to:
  /// **'Case #TR-102'**
  String get hrQueueCase3Title;

  /// No description provided for @hrQueueCase3Meta.
  ///
  /// In en, this message translates to:
  /// **'Course has no approved content version'**
  String get hrQueueCase3Meta;

  /// No description provided for @hrQueueOpenWeb.
  ///
  /// In en, this message translates to:
  /// **'View queue on Web'**
  String get hrQueueOpenWeb;

  /// No description provided for @hrQueueMobileNote.
  ///
  /// In en, this message translates to:
  /// **'Mobile is for receiving and tracking; routing setup, KB approval and complex investigations use the Web Workspace.'**
  String get hrQueueMobileNote;

  /// No description provided for @learningMyTitle.
  ///
  /// In en, this message translates to:
  /// **'My learning'**
  String get learningMyTitle;

  /// No description provided for @learningMandatorySummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 mandatory course} other{{count} mandatory courses}} · due {date}'**
  String learningMandatorySummary(int count, String date);

  /// No description provided for @learningNoMandatory.
  ///
  /// In en, this message translates to:
  /// **'No mandatory courses pending.'**
  String get learningNoMandatory;

  /// No description provided for @learningMandatoryBadge.
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get learningMandatoryBadge;

  /// No description provided for @learningModuleBadge.
  ///
  /// In en, this message translates to:
  /// **'A7'**
  String get learningModuleBadge;

  /// No description provided for @learningVideoMinutes.
  ///
  /// In en, this message translates to:
  /// **'Video {minutes} min'**
  String learningVideoMinutes(int minutes);

  /// No description provided for @learningDocMinutes.
  ///
  /// In en, this message translates to:
  /// **'Reading {minutes} min'**
  String learningDocMinutes(int minutes);

  /// No description provided for @learningQuizQuestions.
  ///
  /// In en, this message translates to:
  /// **'quiz {count} questions'**
  String learningQuizQuestions(int count);

  /// No description provided for @learningDue.
  ///
  /// In en, this message translates to:
  /// **'due {date}'**
  String learningDue(String date);

  /// No description provided for @learningNotStarted.
  ///
  /// In en, this message translates to:
  /// **'not started'**
  String get learningNotStarted;

  /// No description provided for @learningCompletedStatus.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get learningCompletedStatus;

  /// No description provided for @learningProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress {percent}%'**
  String learningProgress(int percent);

  /// No description provided for @learningContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue learning'**
  String get learningContinue;

  /// No description provided for @learningStart.
  ///
  /// In en, this message translates to:
  /// **'Start learning'**
  String get learningStart;

  /// No description provided for @learningPolicyNote.
  ///
  /// In en, this message translates to:
  /// **'Pass marks, retake limits and certificate validity are approved by the content owner before release.'**
  String get learningPolicyNote;

  /// No description provided for @learningEmptyCourses.
  ///
  /// In en, this message translates to:
  /// **'You have no assigned courses yet.'**
  String get learningEmptyCourses;

  /// No description provided for @profileNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Company news'**
  String get profileNewsTitle;

  /// No description provided for @profileNewsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get profileNewsAll;

  /// No description provided for @profileNewsViewFull.
  ///
  /// In en, this message translates to:
  /// **'View full content'**
  String get profileNewsViewFull;

  /// No description provided for @profileNewsAckNote.
  ///
  /// In en, this message translates to:
  /// **'Announcements that need acknowledgement have an “I\'ve read this” button.'**
  String get profileNewsAckNote;

  /// No description provided for @profileNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'My notifications'**
  String get profileNotificationsTitle;

  /// No description provided for @profileAccountSection.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get profileAccountSection;

  /// No description provided for @profileEmployeeMeta.
  ///
  /// In en, this message translates to:
  /// **'Employee ID: {id} · view permitted info'**
  String profileEmployeeMeta(String id);

  /// No description provided for @profileAccountActions.
  ///
  /// In en, this message translates to:
  /// **'Language / security / sign out'**
  String get profileAccountActions;

  /// No description provided for @profilePushNote.
  ///
  /// In en, this message translates to:
  /// **'Push only says “New update”; open the app and authenticate to see sensitive data.'**
  String get profilePushNote;

  /// No description provided for @profileLanguageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language & settings'**
  String get profileLanguageSettings;

  /// No description provided for @profileSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSecurity;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// No description provided for @notificationOpenHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get notificationOpenHint;

  /// No description provided for @chatAttachMedia.
  ///
  /// In en, this message translates to:
  /// **'Photos & videos'**
  String get chatAttachMedia;

  /// No description provided for @chatAttachFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get chatAttachFile;

  /// No description provided for @chatFileTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose file type'**
  String get chatFileTypeTitle;

  /// No description provided for @chatFileTypePdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get chatFileTypePdf;

  /// No description provided for @chatFileTypeWord.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get chatFileTypeWord;

  /// No description provided for @chatFileTypeExcel.
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get chatFileTypeExcel;

  /// No description provided for @chatFileTypePowerPoint.
  ///
  /// In en, this message translates to:
  /// **'PowerPoint'**
  String get chatFileTypePowerPoint;

  /// No description provided for @chatFileTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text (TXT, CSV)'**
  String get chatFileTypeText;

  /// No description provided for @chatFileTypeAll.
  ///
  /// In en, this message translates to:
  /// **'All files'**
  String get chatFileTypeAll;

  /// No description provided for @chatOpenWith.
  ///
  /// In en, this message translates to:
  /// **'Open with another app'**
  String get chatOpenWith;

  /// No description provided for @chatFileOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open this file'**
  String get chatFileOpenFailed;

  /// No description provided for @chatMediaUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this content'**
  String get chatMediaUnavailable;

  /// No description provided for @chatMicPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone access needed'**
  String get chatMicPermissionTitle;

  /// No description provided for @chatMicPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone access in Settings to record voice messages.'**
  String get chatMicPermissionMessage;

  /// No description provided for @chatOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get chatOpenSettings;

  /// No description provided for @chatMicPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get chatMicPermissionDenied;

  /// No description provided for @chatRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording · {duration}'**
  String chatRecording(String duration);

  /// No description provided for @chatVoiceRecord.
  ///
  /// In en, this message translates to:
  /// **'Record voice'**
  String get chatVoiceRecord;

  /// No description provided for @chatStopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop and send'**
  String get chatStopRecording;

  /// No description provided for @chatCancelRecording.
  ///
  /// In en, this message translates to:
  /// **'Cancel recording'**
  String get chatCancelRecording;

  /// No description provided for @chatPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get chatPlay;

  /// No description provided for @chatPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get chatPause;

  /// No description provided for @chatVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Voice message'**
  String get chatVoiceNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
