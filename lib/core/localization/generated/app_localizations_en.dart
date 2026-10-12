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
  String get commonEmpty => 'No data';

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
  String get errorRateLimited =>
      'Too many requests. Please wait a moment and try again.';

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
  String get authHeaderTitle => 'GO AI HR';

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
  String get authSsoPrompt => 'Enterprise has SSO? Choose \"Company sign-in\".';

  @override
  String get authSsoButton => 'Company sign-in';

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
  String get authPasswordRequired => 'Please enter your password';

  @override
  String get authChangePassword => 'Change password';

  @override
  String get authCurrentPassword => 'Current password';

  @override
  String get authNewPassword => 'New password';

  @override
  String get authConfirmPassword => 'Confirm new password';

  @override
  String get authPasswordMismatch => 'Passwords do not match';

  @override
  String get authPasswordChanged =>
      'Password changed. Please sign in with your new password.';

  @override
  String get authPasswordRejected =>
      'The current password is wrong or the new password is not accepted.';

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
  String get homeSubtitle => 'GO AI Workforce for employees.';

  @override
  String get homeChatTitle => 'Chat demo';

  @override
  String get homeChatSubtitle => 'Generic chat engine with a mock provider';

  @override
  String get homeSettingsTitle => 'Settings';

  @override
  String get homeSettingsSubtitle => 'Language and app info';

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
  String get chatTranscribing => 'Transcribing your voice note…';

  @override
  String get chatRateGood => 'Good answer';

  @override
  String get chatRateBad => 'Bad answer';

  @override
  String get chatReadAloud => 'Read aloud';

  @override
  String get chatStopReading => 'Stop reading';

  @override
  String get chatActionFailed =>
      'Could not complete the action. Please try again.';

  @override
  String get chatRename => 'Rename';

  @override
  String get chatRenameTitle => 'Rename conversation';

  @override
  String get chatPin => 'Pin';

  @override
  String get chatUnpin => 'Unpin';

  @override
  String get chatDelete => 'Delete';

  @override
  String get chatDeleteConfirmTitle => 'Delete this conversation?';

  @override
  String get chatDeleteConfirmMessage =>
      'It is deleted for you on the app and the website. This cannot be undone.';

  @override
  String get chatPinned => 'Pinned';

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
  String get accountNews => 'Internal News & Bulletins';

  @override
  String get askHrSearchPrompt => 'Type a question… e.g. leave policy';

  @override
  String get askHrPolicyChip => 'Policy';

  @override
  String get askHrFormChip => 'Forms';

  @override
  String get askHrMyRequestsChip => 'My Requests';

  @override
  String get homeAppBarTitle => 'GO AI · HR';

  @override
  String homeHeroGreeting(String name) {
    return 'Hi $name 👋';
  }

  @override
  String get homePendingTasksLead => 'You have ';

  @override
  String homePendingTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
    );
    return '$_temp0';
  }

  @override
  String get homePendingTasksTail => ' to finish this week.';

  @override
  String get homeAskPolicyAction => 'Ask policy';

  @override
  String get homeSendRequestAction => 'Send request';

  @override
  String get homeUpcomingWorkDetail =>
      'Finish onboarding checklist · due 10/10';

  @override
  String get homeNoUpcomingWork => 'Nothing due in the next 30 days';

  @override
  String get homeUpcomingUnavailable => 'Could not load your calendar';

  @override
  String homeUpcomingItem(String title, String when) {
    return '$title · $when';
  }

  @override
  String get homeMyCoursesDetail => 'Basic workplace safety · 12 min left';

  @override
  String get homePendingCaseDetail => 'Waiting for HR · expected 09/10';

  @override
  String get homeQuotaTitle => 'AI token quota';

  @override
  String get homeNewsEmpty => 'No news yet.';

  @override
  String get homeNewsLoading => 'Loading news...';

  @override
  String get askHrTitle => 'How can HR help?';

  @override
  String get askHrSend => 'Send question';

  @override
  String get askHrSampleQuestion => 'I need to see the leave policy.';

  @override
  String get askHrSampleAnswer =>
      'I can summarise the current policy and link the approved version. Do you want the eligibility rules or how to submit a request?';

  @override
  String get askHrPrivacyNotice =>
      'Personal information needs extra verification. Complaints open a confidential case for HR.';

  @override
  String get askHrViewPolicySources => 'View policy & sources';

  @override
  String get askHrAnswerTitle => 'Annual leave policy';

  @override
  String get askHrAnswerBody =>
      'Under the approved policy, you send a request to your manager following the company process. Exact eligibility depends on your contract type and remaining leave balance.';

  @override
  String get askHrSourceEyebrow => 'APPROVED SOURCE';

  @override
  String get askHrSourceTitle => 'Leave policy • version 2.1';

  @override
  String get askHrSourceMeta => 'Effective: 01/09/2026 · Owner: HR';

  @override
  String get askHrSourcePath =>
      'Company document library → accessible version → section 3.2';

  @override
  String get askHrSourceWarning =>
      'No effective version found or conflicting info? Escalate to HR; don\'t treat the answer as definitive policy.';

  @override
  String get askHrOpenSource => 'Open original document';

  @override
  String get askHrCreateRequest => 'Create HR request';

  @override
  String get chatHubTitle => 'Chat list';

  @override
  String get profileChatList => 'Chat list';

  @override
  String get profileChatListSubtitle =>
      'AI assistants & conversation history (temporary)';

  @override
  String get myWorkOnboardingEyebrow => 'ONBOARDING';

  @override
  String get myWorkOnboardingRole => 'Operations staff · Plant A';

  @override
  String get myWorkOnboardingTemplate =>
      'Template: role + location + contract type · approved by HR';

  @override
  String myWorkOnboardingProgress(int done, int total) {
    return '$done/$total items confirmed';
  }

  @override
  String get myWorkOnboardingShowRest => 'Show remaining items';

  @override
  String get myWorkOnboardingCollapse => 'Show less';

  @override
  String get myWorkOnboardingEvidenceNote =>
      '“Checklist complete” records evidence; the official record is updated by the source system after review.';

  @override
  String get myWorkCasesEmpty => 'You have no cases yet.';

  @override
  String myWorkCaseUpdated(String date) {
    return 'Updated $date';
  }

  @override
  String get myWorkStepReceived => 'Received';

  @override
  String get myWorkStepAssigned => 'Assigned';

  @override
  String get myWorkStepInProgress => 'In progress';

  @override
  String get myWorkStepDone => 'Done';

  @override
  String myWorkCaseStatusBody(String date) {
    return 'Expected response $date. You\'ll be notified if more information is needed.';
  }

  @override
  String get myWorkCaseSecureTitle => 'Secure exchange';

  @override
  String get myWorkCaseSecureBody =>
      'View and add details within your own case only.';

  @override
  String get myWorkCaseAddDocs => 'Add documents';

  @override
  String myWorkCaseDocsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Attached $count files to the case',
      one: 'Attached 1 file to the case',
    );
    return '$_temp0';
  }

  @override
  String get myWorkCaseEscalationNote =>
      'Overdue → A0 reminds and escalates to the owner.';

  @override
  String get myWorkNewRequestButton => 'New HR request';

  @override
  String get myWorkNewRequest => 'Send HR request';

  @override
  String get myWorkRequestTypeHint =>
      'Request type: personal information confirmation';

  @override
  String get myWorkRequestTypePersonalInfo =>
      'Personal information confirmation';

  @override
  String get myWorkRequestTypeLeave => 'Leave';

  @override
  String get myWorkRequestTypePolicy => 'Policy & benefits';

  @override
  String get myWorkRequestTypeComplaint => 'Complaint (confidential)';

  @override
  String get myWorkRequestTypeRequired => 'Please choose a request type';

  @override
  String get myWorkRequestDescriptionHint => 'Briefly describe what you need';

  @override
  String get myWorkRequestDescriptionRequired => 'Please describe your request';

  @override
  String get myWorkRequestAttachHint => 'Attach documents (if needed)';

  @override
  String myWorkRequestAttached(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files attached',
      one: '1 file attached',
    );
    return '$_temp0';
  }

  @override
  String get myWorkRequestPrivacyNotice =>
      'Share only what\'s needed. Sensitive information is routed to HR by permission.';

  @override
  String get myWorkRequestSubmit => 'Submit request';

  @override
  String get myWorkRequestAfterTitle => 'After you submit';

  @override
  String get myWorkRequestAfterBody =>
      'You get a case code (e.g. #HR-1042) · expected response: 2 working days · handler: assigned HR.';

  @override
  String get myWorkRequestUrgentNote =>
      'Complaints/urgent: routed straight to the authorised handler, not via your direct manager.';

  @override
  String myWorkRequestSubmitted(String id) {
    return 'Request sent · $id';
  }

  @override
  String get myWorkRoleEmployee => 'Employee';

  @override
  String get myWorkRoleHrAdmin => 'HR / Admin';

  @override
  String get myWorkRoleDemoHint =>
      'Demo mode: choose a role to preview the Work tab';

  @override
  String get hrApprovalsEyebrow => 'FOR AUTHORISED APPROVERS';

  @override
  String get hrApprovalsTitle => 'Awaiting my approval';

  @override
  String get hrApprovalProbationTitle => 'Probation review file';

  @override
  String get hrApprovalProbationMeta => '#PB-238 · Nguyen A · due 11/10';

  @override
  String get hrApprovalProbationBadge => 'Pending';

  @override
  String get hrApprovalChecklistTitle => 'Checklist with exceptions';

  @override
  String get hrApprovalChecklistMeta =>
      '#ON-320 · missing documents · due 09/10';

  @override
  String get hrApprovalChecklistBadge => 'Verify';

  @override
  String get hrApprovalsScopeNote =>
      '2 items · rights follow position, unit, reporting line and authority level.';

  @override
  String get hrApprovalsOpenReview => 'Open review file';

  @override
  String get hrApprovalsNoBulkNote =>
      'There is no “Approve all” for probation decisions.';

  @override
  String get hrProbationTitle => 'Probation review #PB-238';

  @override
  String get hrProbationChecklist => 'Checklist 12/13 items';

  @override
  String get hrProbationTraining => 'Mandatory training: confirmed';

  @override
  String get hrProbationManagerOpinion => 'Manager opinion: needs more input';

  @override
  String get hrProbationMissingEvidence =>
      'Evidence is missing. Request more information before deciding.';

  @override
  String get hrProbationCommentHint => 'Reviewer comments & rationale';

  @override
  String get hrProbationRequestMore => 'Request more information';

  @override
  String get hrProbationEscalate => 'Escalate to HR/Legal';

  @override
  String get hrProbationDecisionNote =>
      'Decision options appear only once conditions are met, rights are correct and you confirm again.';

  @override
  String hrQueueOverdue(int count) {
    return 'Overdue $count';
  }

  @override
  String hrQueuePending(int count) {
    return 'Pending $count';
  }

  @override
  String get hrQueueCase1Title => 'Case #HR-1051';

  @override
  String get hrQueueCase1Meta => 'Complaint · confidential routing · due today';

  @override
  String get hrQueueCase2Title => 'Case #ON-320';

  @override
  String get hrQueueCase2Meta => 'Missing onboarding documents · owner: HR A';

  @override
  String get hrQueueCase3Title => 'Case #TR-102';

  @override
  String get hrQueueCase3Meta => 'Course has no approved content version';

  @override
  String get hrQueueOpenWeb => 'View queue on Web';

  @override
  String get hrQueueMobileNote =>
      'Mobile is for receiving and tracking; routing setup, KB approval and complex investigations use the Web Workspace.';

  @override
  String get learningMyTitle => 'My learning';

  @override
  String learningMandatorySummary(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mandatory courses',
      one: '1 mandatory course',
    );
    return '$_temp0 · due $date';
  }

  @override
  String get learningNoMandatory => 'No mandatory courses pending.';

  @override
  String get learningMandatoryBadge => 'Mandatory';

  @override
  String get learningModuleBadge => 'A7';

  @override
  String learningVideoMinutes(int minutes) {
    return 'Video $minutes min';
  }

  @override
  String learningDocMinutes(int minutes) {
    return 'Reading $minutes min';
  }

  @override
  String learningQuizQuestions(int count) {
    return 'quiz $count questions';
  }

  @override
  String learningDue(String date) {
    return 'due $date';
  }

  @override
  String get learningNotStarted => 'not started';

  @override
  String get learningCompletedStatus => 'completed';

  @override
  String learningProgress(int percent) {
    return 'Progress $percent%';
  }

  @override
  String get learningContinue => 'Continue learning';

  @override
  String get learningStart => 'Start learning';

  @override
  String get learningPolicyNote =>
      'Pass marks, retake limits and certificate validity are approved by the content owner before release.';

  @override
  String get profileNewsTitle => 'Company news';

  @override
  String get profileNewsAll => 'All';

  @override
  String get profileNewsViewFull => 'View full content';

  @override
  String get profileNewsAckNote =>
      'Announcements that need acknowledgement have an “I\'ve read this” button.';

  @override
  String get profileNotificationsTitle => 'My notifications';

  @override
  String get profileAccountSection => 'ACCOUNT';

  @override
  String profileEmployeeMeta(String id) {
    return 'Employee ID: $id · view permitted info';
  }

  @override
  String get profileAccountActions => 'Language / security / sign out';

  @override
  String get profilePushNote =>
      'Push only says “New update”; open the app and authenticate to see sensitive data.';

  @override
  String get profileLanguageSettings => 'Language & settings';

  @override
  String get profileSecurity => 'Security';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String get commonPressBackAgainToExit => 'Press back again to exit';

  @override
  String get notificationOpenHint => 'Tap to view details';

  @override
  String get chatAttachMedia => 'Photos & videos';

  @override
  String get chatAttachFile => 'File';

  @override
  String get chatFileTypeTitle => 'Choose file type';

  @override
  String get chatFileTypePdf => 'PDF';

  @override
  String get chatFileTypeWord => 'Word';

  @override
  String get chatFileTypeExcel => 'Excel';

  @override
  String get chatFileTypePowerPoint => 'PowerPoint';

  @override
  String get chatFileTypeText => 'Text (TXT, CSV)';

  @override
  String get chatFileTypeAll => 'All files';

  @override
  String get chatOpenWith => 'Open with another app';

  @override
  String get chatFileOpenFailed => 'Couldn\'t open this file';

  @override
  String get chatMediaUnavailable => 'Couldn\'t load this content';

  @override
  String get chatMicPermissionTitle => 'Microphone access needed';

  @override
  String get chatMicPermissionMessage =>
      'Allow microphone access in Settings to record voice messages.';

  @override
  String get chatOpenSettings => 'Open settings';

  @override
  String get chatMicPermissionDenied => 'Microphone permission denied';

  @override
  String chatRecording(String duration) {
    return 'Recording · $duration';
  }

  @override
  String get chatVoiceRecord => 'Record voice';

  @override
  String get chatStopRecording => 'Stop and send';

  @override
  String get chatCancelRecording => 'Cancel recording';

  @override
  String get chatPlay => 'Play';

  @override
  String get chatPause => 'Pause';

  @override
  String get chatVoiceNote => 'Voice message';
}
