// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get commonOk => '확인';

  @override
  String get commonCancel => '취소';

  @override
  String get commonConfirm => '확인';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonClose => '닫기';

  @override
  String get commonLoading => '불러오는 중…';

  @override
  String get commonEmpty => '데이터가 없습니다';

  @override
  String get commonErrorTitle => '오류가 발생했습니다';

  @override
  String get errorNetwork => '인터넷에 연결되어 있지 않습니다. 네트워크를 확인한 후 다시 시도해 주세요.';

  @override
  String get errorTimeout => '요청 시간이 초과되었습니다. 다시 시도해 주세요.';

  @override
  String get errorUnauthorized => '세션이 만료되었습니다. 다시 로그인해 주세요.';

  @override
  String get errorForbidden => '이 작업을 수행할 권한이 없습니다.';

  @override
  String get errorNotFound => '요청한 항목을 찾을 수 없습니다.';

  @override
  String get errorValidation => '일부 정보가 올바르지 않습니다. 확인 후 다시 시도해 주세요.';

  @override
  String get errorRateLimited => '요청이 너무 많습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get errorServer => '서버에 문제가 발생했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get errorStorage => '기기 저장소에 접근할 수 없습니다.';

  @override
  String get errorUnknown => '예기치 않은 오류가 발생했습니다.';

  @override
  String get authSignInTitle => '다시 오신 것을 환영합니다';

  @override
  String get authSignInSubtitle => '정보를 확인하려면 계정을 인증해 주세요.';

  @override
  String get authHeaderTitle => 'GO AI HR';

  @override
  String get authSecurityBadge => '보안';

  @override
  String get authBrandEyebrow => 'GO AI · HR WORKFORCE';

  @override
  String get authEmployeeAccountLabel => '사번 또는 회사 계정';

  @override
  String get authEmployeeAccountHint => '사번 또는 회사 계정을 입력하세요';

  @override
  String get authPhoneNumberLabel => '등록된 전화번호';

  @override
  String get authPhoneNumberHint => '등록된 전화번호를 입력하세요';

  @override
  String get authSendVerificationCode => '인증 코드 보내기';

  @override
  String get authSsoPrompt => '회사에서 SSO를 사용하나요? \'회사 로그인\'을 선택하세요.';

  @override
  String get authSsoButton => '회사 로그인';

  @override
  String get authFirstTimeTitle => '처음 사용하시나요';

  @override
  String get authFirstTimeBody =>
      'HR에서 활성화 코드를 발급합니다. 전화번호를 인증한 후 기기에서 PIN을 설정하세요.';

  @override
  String get authSharedDeviceNotice => '공용 휴대폰을 사용하나요? 사용 후에는 항상 완전히 로그아웃하세요.';

  @override
  String get authAccountRequired => '사번 또는 회사 계정을 입력해 주세요';

  @override
  String get authPhoneRequired => '등록된 전화번호를 입력해 주세요';

  @override
  String get authSecurityDialogTitle => '기업 보안';

  @override
  String get authSecurityDialogMessage =>
      '세션과 데이터는 기업 인사 정보 보안 정책을 준수하는 종단 간 암호화로 보호됩니다.';

  @override
  String get authEmailLabel => '이메일';

  @override
  String get authPasswordLabel => '비밀번호';

  @override
  String get authPasswordRequired => '비밀번호를 입력해 주세요';

  @override
  String get authChangePassword => '비밀번호 변경';

  @override
  String get authCurrentPassword => '현재 비밀번호';

  @override
  String get authNewPassword => '새 비밀번호';

  @override
  String get authConfirmPassword => '새 비밀번호 확인';

  @override
  String get authPasswordMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get authPasswordChanged => '비밀번호가 변경되었습니다. 새 비밀번호로 다시 로그인해 주세요.';

  @override
  String get authPasswordRejected => '현재 비밀번호가 틀렸거나 새 비밀번호가 요구 사항을 충족하지 않습니다.';

  @override
  String get authSignInButton => '로그인';

  @override
  String get authContinueAsGuest => '게스트로 계속하기';

  @override
  String get authEmailInvalid => '올바른 이메일 주소를 입력해 주세요';

  @override
  String authPasswordTooShort(int min) {
    return '비밀번호는 $min자 이상이어야 합니다';
  }

  @override
  String get authDemoHint => '데모 모드: 아무 사번/전화번호나 입력하거나 게스트로 계속하세요.';

  @override
  String get authSignOut => '로그아웃';

  @override
  String get authSignOutConfirmTitle => '로그아웃하시겠습니까?';

  @override
  String get authSignOutConfirmMessage => '계속하려면 다시 로그인해야 합니다.';

  @override
  String get authGuestName => '게스트';

  @override
  String get homeTitle => '홈';

  @override
  String homeGreeting(String name) {
    return '안녕하세요, $name님';
  }

  @override
  String get homeSubtitle => '직원을 위한 GO AI Workforce.';

  @override
  String get homeChatTitle => '채팅 데모';

  @override
  String get homeChatSubtitle => '모의 제공자를 사용하는 범용 채팅 엔진';

  @override
  String get homeSettingsTitle => '설정';

  @override
  String get homeSettingsSubtitle => '언어 및 앱 정보';

  @override
  String get homeShowcaseTitle => '기본 구성 요소 쇼케이스';

  @override
  String get homeShowcaseSubtitle => '디자인 시스템 구성 요소와 상태';

  @override
  String get homeProfileTitle => '프로필';

  @override
  String get homeProfileSubtitle => '현재 사용자 및 세션';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageSystem => '시스템 기본값';

  @override
  String get settingsAbout => '정보';

  @override
  String get settingsAppName => '앱 이름';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsEnvironment => '환경';

  @override
  String get settingsAccount => '계정';

  @override
  String get profileTitle => '프로필';

  @override
  String get profileUserId => '사용자 ID';

  @override
  String get profileEmail => '이메일';

  @override
  String get profileNoEmail => '제공되지 않음';

  @override
  String get profileGuestBadge => '게스트 세션';

  @override
  String get chatTitle => '대화';

  @override
  String get chatEmptyConversations => '아직 대화가 없습니다';

  @override
  String get chatEmptyMessages => '아직 메시지가 없습니다. 인사를 건네 보세요!';

  @override
  String get chatComposerHint => '메시지 입력';

  @override
  String get chatSend => '보내기';

  @override
  String get chatAttach => '파일 첨부';

  @override
  String get chatStop => '생성 중지';

  @override
  String get chatRegenerate => '다시 생성';

  @override
  String get chatFailed => '전송하지 못했습니다. 탭하여 다시 시도하세요.';

  @override
  String chatReplyingTo(String name) {
    return '$name님에게 답장 중';
  }

  @override
  String get chatReply => '답장';

  @override
  String get chatCancelReply => '답장 취소';

  @override
  String chatTyping(String name) {
    return '$name님이 입력 중…';
  }

  @override
  String get chatSources => '출처';

  @override
  String get chatTranscribing => '음성을 텍스트로 변환하는 중…';

  @override
  String get chatRateGood => '좋은 답변';

  @override
  String get chatRateBad => '아쉬운 답변';

  @override
  String get chatReadAloud => '소리 내어 읽기';

  @override
  String get chatStopReading => '읽기 중지';

  @override
  String get chatActionFailed => '작업을 완료하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get chatRename => '이름 변경';

  @override
  String get chatRenameTitle => '대화 이름 변경';

  @override
  String get chatPin => '고정';

  @override
  String get chatUnpin => '고정 해제';

  @override
  String get chatDelete => '삭제';

  @override
  String get chatDeleteConfirmTitle => '이 대화를 삭제하시겠습니까?';

  @override
  String get chatDeleteConfirmMessage => '앱과 웹사이트에서 모두 삭제되며 되돌릴 수 없습니다.';

  @override
  String get chatPinned => '고정됨';

  @override
  String get chatYou => '나';

  @override
  String get chatDemoHint => '팁: 메시지에 \'/fail\'을 넣으면 전송 실패를 시뮬레이션할 수 있습니다.';

  @override
  String get chatUploading => '업로드 중…';

  @override
  String get notFoundTitle => '페이지를 찾을 수 없습니다';

  @override
  String get notFoundMessage => '찾으시는 페이지가 존재하지 않습니다.';

  @override
  String get notFoundGoHome => '홈으로 이동';

  @override
  String get showcaseTitle => '기본 구성 요소 쇼케이스';

  @override
  String get showcaseButtons => '버튼';

  @override
  String get showcasePrimary => '기본';

  @override
  String get showcaseSecondary => '보조';

  @override
  String get showcaseTextButton => '텍스트';

  @override
  String get showcaseInputs => '입력 필드';

  @override
  String get showcaseSampleInput => '입력 예시';

  @override
  String get showcaseStates => '상태';

  @override
  String get showcaseFeedback => '피드백';

  @override
  String get showcaseShowDialog => '대화 상자 표시';

  @override
  String get showcaseDialogMessage => '재사용 가능한 확인 대화 상자입니다.';

  @override
  String get showcaseShowSnackbar => '스낵바 표시';

  @override
  String get showcaseSnackbarMessage => '재사용 가능한 스낵바입니다.';

  @override
  String get showcaseSendNotification => '앱 내 알림 보내기';

  @override
  String get showcaseNotificationTitle => '알림 센터에서 보낸 인사';

  @override
  String get showcaseNotificationBody => '앱 내 알림은 교체 가능한 서비스를 통해 전달됩니다.';

  @override
  String get showcaseAttachments => '첨부 파일';

  @override
  String get mainNavHome => '홈';

  @override
  String get mainNavAskHr => 'HR 문의';

  @override
  String get mainNavMyWork => '내 업무';

  @override
  String get mainNavLearning => '학습';

  @override
  String get mainNavAccount => '계정';

  @override
  String get mainNavTimeline => '홈';

  @override
  String get mainNavChat => 'HR 문의';

  @override
  String get mainNavDocuments => '문서';

  @override
  String get mainNavProfile => '계정';

  @override
  String get headerSubtitle => '기업 AI 어시스턴트 & 직원 워크스페이스';

  @override
  String get headerTokenQuota => '토큰 할당량';

  @override
  String get headerQuotaUnavailable => '할당량을 불러올 수 없음';

  @override
  String get headerQuotaExceeded => '할당량 초과';

  @override
  String get headerQuotaWarning => '할당량 경고';

  @override
  String get notificationTitle => '알림';

  @override
  String get notificationEmpty => '아직 알림이 없습니다';

  @override
  String get chatAiAgents => 'AI 및 HR 에이전트';

  @override
  String get chatOther => '기타';

  @override
  String get chatHumanBlockedHint => '상담원 채팅은 백엔드 연동 대기 중입니다 (BLOCKED)';

  @override
  String get chatStartNew => '새 대화 시작';

  @override
  String chatAgentHistory(String name) {
    return '$name 대화 기록';
  }

  @override
  String get profileApprovals => '승인 대기';

  @override
  String get profileSettings => '설정';

  @override
  String get elearningCourses => '교육 과정';

  @override
  String get elearningTests => '인증 시험';

  @override
  String get myWorkTitle => '내 업무';

  @override
  String get myWorkChecklistTitle => '온보딩 체크리스트';

  @override
  String get myWorkCasesTitle => '내 케이스 및 요청';

  @override
  String get myWorkApprovalsTitle => '내 승인 대기';

  @override
  String get homeNewsSection => '새 소식';

  @override
  String get homeViewAllNews => '모두 보기';

  @override
  String get homeUpcomingWork => '마감 임박 업무';

  @override
  String get homeMyCourses => '내 과정';

  @override
  String get homePendingCase => 'HR 요청 #HR-1042';

  @override
  String get accountNews => '사내 소식';

  @override
  String get askHrSearchPrompt => '질문을 입력하세요… 예: 휴가 규정';

  @override
  String get askHrPolicyChip => '정책';

  @override
  String get askHrFormChip => '양식';

  @override
  String get askHrMyRequestsChip => '내 요청';

  @override
  String get homeAppBarTitle => 'GO AI · HR';

  @override
  String homeHeroGreeting(String name) {
    return '$name님, 안녕하세요 👋';
  }

  @override
  String get homePendingTasksLead => '이번 주에 완료할 업무가 ';

  @override
  String homePendingTasksCount(int count) {
    return '$count건';
  }

  @override
  String get homePendingTasksTail => ' 있습니다.';

  @override
  String get homeAskPolicyAction => '정책 문의';

  @override
  String get homeSendRequestAction => '요청 보내기';

  @override
  String get homeUpcomingWorkDetail => '온보딩 체크리스트 완료 · 마감 10/10';

  @override
  String get homeNoUpcomingWork => '앞으로 30일 동안 마감 업무가 없습니다';

  @override
  String get homeUpcomingUnavailable => '일정을 불러올 수 없습니다';

  @override
  String homeUpcomingItem(String title, String when) {
    return '$title · $when';
  }

  @override
  String get homeMyCoursesDetail => '기본 산업 안전 · 12분 남음';

  @override
  String get homePendingCaseDetail => 'HR 답변 대기 중 · 예상 09/10';

  @override
  String get homeQuotaTitle => 'AI 토큰 할당량';

  @override
  String get homeNewsEmpty => '아직 소식이 없습니다.';

  @override
  String get homeNewsLoading => '소식을 불러오는 중…';

  @override
  String get askHrTitle => 'HR에 어떤 도움이 필요하신가요?';

  @override
  String get askHrSend => '질문 보내기';

  @override
  String get askHrSampleQuestion => '휴가 규정을 확인하고 싶어요.';

  @override
  String get askHrSampleAnswer =>
      '현행 규정을 요약하고 승인된 버전의 링크를 안내해 드릴 수 있습니다. 신청 자격과 신청 방법 중 무엇이 궁금하신가요?';

  @override
  String get askHrPrivacyNotice =>
      '개인 정보는 추가 확인이 필요합니다. 고충 제기는 HR을 위한 비공개 케이스로 등록됩니다.';

  @override
  String get askHrViewPolicySources => '정책 및 출처 보기';

  @override
  String get askHrAnswerTitle => '연차 휴가 규정';

  @override
  String get askHrAnswerBody =>
      '승인된 규정에 따라 회사 절차대로 관리자에게 신청하세요. 구체적인 자격은 계약 유형과 남은 휴가 일수에 따라 다릅니다.';

  @override
  String get askHrSourceEyebrow => '승인된 출처';

  @override
  String get askHrSourceTitle => '휴가 규정 • 버전 2.1';

  @override
  String get askHrSourceMeta => '시행일: 01/09/2026 · 담당: HR';

  @override
  String get askHrSourcePath => '회사 문서 보관소 → 접근 가능한 버전 → 3.2항';

  @override
  String get askHrSourceWarning =>
      '시행 중인 버전을 찾을 수 없거나 정보가 상충하나요? HR에 확인을 요청하고, 이 답변을 확정된 규정으로 간주하지 마세요.';

  @override
  String get askHrOpenSource => '원본 문서 열기';

  @override
  String get askHrCreateRequest => 'HR 요청 만들기';

  @override
  String get chatHubTitle => '채팅 목록';

  @override
  String get profileChatList => '채팅 목록';

  @override
  String get profileChatListSubtitle => 'AI 어시스턴트 및 대화 기록 (임시)';

  @override
  String get myWorkOnboardingEyebrow => '온보딩';

  @override
  String get myWorkOnboardingRole => '운영 직원 · A 공장';

  @override
  String get myWorkOnboardingTemplate => '템플릿: 직무 + 근무지 + 계약 유형 · HR 승인 완료';

  @override
  String myWorkOnboardingProgress(int done, int total) {
    return '$done/$total개 항목 확인 완료';
  }

  @override
  String get myWorkOnboardingShowRest => '나머지 항목 보기';

  @override
  String get myWorkOnboardingCollapse => '접기';

  @override
  String get myWorkOnboardingEvidenceNote =>
      '\'체크리스트 완료\'는 증빙 기록입니다. 공식 기록은 검토 후 원본 시스템에서 업데이트됩니다.';

  @override
  String get myWorkCasesEmpty => '아직 케이스가 없습니다.';

  @override
  String myWorkCaseUpdated(String date) {
    return '$date 업데이트';
  }

  @override
  String get myWorkStepReceived => '접수됨';

  @override
  String get myWorkStepAssigned => '배정됨';

  @override
  String get myWorkStepInProgress => '처리 중';

  @override
  String get myWorkStepDone => '완료';

  @override
  String myWorkCaseStatusBody(String date) {
    return '$date에 답변 예정입니다. 추가 정보가 필요하면 알림을 보내 드립니다.';
  }

  @override
  String get myWorkCaseSecureTitle => '보안 소통';

  @override
  String get myWorkCaseSecureBody => '본인 케이스 범위 안에서만 확인하고 보완할 수 있습니다.';

  @override
  String get myWorkCaseAddDocs => '서류 추가';

  @override
  String myWorkCaseDocsAdded(int count) {
    return '케이스에 파일 $count개를 첨부했습니다';
  }

  @override
  String get myWorkCaseEscalationNote => '기한 초과 → A0가 알림을 보내고 담당자에게 이관합니다.';

  @override
  String get myWorkNewRequestButton => '새 HR 요청';

  @override
  String get myWorkNewRequest => 'HR 요청 보내기';

  @override
  String get myWorkRequestTypeHint => '요청 유형: 개인 정보 확인';

  @override
  String get myWorkRequestTypePersonalInfo => '개인 정보 확인';

  @override
  String get myWorkRequestTypeLeave => '휴가';

  @override
  String get myWorkRequestTypePolicy => '정책 및 복리후생';

  @override
  String get myWorkRequestTypeComplaint => '고충 제기 (비공개)';

  @override
  String get myWorkRequestTypeRequired => '요청 유형을 선택해 주세요';

  @override
  String get myWorkRequestDescriptionHint => '필요한 도움을 간단히 설명해 주세요';

  @override
  String get myWorkRequestDescriptionRequired => '요청 내용을 입력해 주세요';

  @override
  String get myWorkRequestAttachHint => '서류 첨부 (필요한 경우)';

  @override
  String myWorkRequestAttached(int count) {
    return '파일 $count개 첨부됨';
  }

  @override
  String get myWorkRequestPrivacyNotice =>
      '필요한 내용만 공유하세요. 민감한 정보는 권한에 따라 HR에 전달됩니다.';

  @override
  String get myWorkRequestSubmit => '요청 제출';

  @override
  String get myWorkRequestAfterTitle => '제출 후';

  @override
  String get myWorkRequestAfterBody =>
      '케이스 번호(예: #HR-1042)가 발급됩니다 · 예상 답변 기간: 영업일 기준 2일 · 담당: 배정된 HR.';

  @override
  String get myWorkRequestUrgentNote =>
      '고충/긴급 건: 직속 관리자를 거치지 않고 권한 있는 담당자에게 바로 전달됩니다.';

  @override
  String myWorkRequestSubmitted(String id) {
    return '요청을 보냈습니다 · $id';
  }

  @override
  String get myWorkRoleEmployee => '직원';

  @override
  String get myWorkRoleHrAdmin => 'HR / 관리자';

  @override
  String get myWorkRoleDemoHint => '데모 모드: 역할을 선택해 업무 탭을 미리 보세요';

  @override
  String get hrApprovalsEyebrow => '승인 권한자 전용';

  @override
  String get hrApprovalsTitle => '내 승인 대기';

  @override
  String get hrApprovalProbationTitle => '수습 평가 파일';

  @override
  String get hrApprovalProbationMeta => '#PB-238 · Nguyen A · 마감 11/10';

  @override
  String get hrApprovalProbationBadge => '승인 대기';

  @override
  String get hrApprovalChecklistTitle => '예외가 있는 체크리스트';

  @override
  String get hrApprovalChecklistMeta => '#ON-320 · 서류 누락 · 마감 09/10';

  @override
  String get hrApprovalChecklistBadge => '확인 필요';

  @override
  String get hrApprovalsScopeNote => '2건 · 권한은 직위, 소속, 보고 체계, 권한 수준에 따라 결정됩니다.';

  @override
  String get hrApprovalsOpenReview => '평가 파일 열기';

  @override
  String get hrApprovalsNoBulkNote => '수습 결정에는 \'모두 승인\' 버튼이 없습니다.';

  @override
  String get hrProbationTitle => '수습 평가 #PB-238';

  @override
  String get hrProbationChecklist => '체크리스트 12/13개 항목';

  @override
  String get hrProbationTraining => '필수 교육: 확인 완료';

  @override
  String get hrProbationManagerOpinion => '관리자 의견: 보완 필요';

  @override
  String get hrProbationMissingEvidence => '증빙이 부족합니다. 결정하기 전에 추가 정보를 요청하세요.';

  @override
  String get hrProbationCommentHint => '승인자 의견 및 근거';

  @override
  String get hrProbationRequestMore => '추가 정보 요청';

  @override
  String get hrProbationEscalate => 'HR/법무팀에 이관';

  @override
  String get hrProbationDecisionNote =>
      '결정 옵션은 조건을 충족하고 권한이 맞으며 다시 확인한 후에만 표시됩니다.';

  @override
  String hrQueueOverdue(int count) {
    return '기한 초과 $count';
  }

  @override
  String hrQueuePending(int count) {
    return '승인 대기 $count';
  }

  @override
  String get hrQueueCase1Title => '케이스 #HR-1051';

  @override
  String get hrQueueCase1Meta => '고충 제기 · 비공개 전달 · 오늘 마감';

  @override
  String get hrQueueCase2Title => '케이스 #ON-320';

  @override
  String get hrQueueCase2Meta => '입사 서류 누락 · 담당: HR A';

  @override
  String get hrQueueCase3Title => '케이스 #TR-102';

  @override
  String get hrQueueCase3Meta => '과정에 승인된 콘텐츠 버전이 없습니다';

  @override
  String get hrQueueOpenWeb => '웹에서 대기열 보기';

  @override
  String get hrQueueMobileNote =>
      '모바일은 수신과 추적용입니다. 전달 경로 설정, 지식 베이스 승인, 복잡한 조사는 웹 워크스페이스를 이용하세요.';

  @override
  String get learningMyTitle => '내 학습';

  @override
  String learningMandatorySummary(int count, String date) {
    return '필수 과정 $count개 · 마감 $date';
  }

  @override
  String get learningNoMandatory => '남은 필수 과정이 없습니다.';

  @override
  String get learningMandatoryBadge => '필수';

  @override
  String get learningModuleBadge => 'A7';

  @override
  String learningVideoMinutes(int minutes) {
    return '동영상 $minutes분';
  }

  @override
  String learningDocMinutes(int minutes) {
    return '읽기 $minutes분';
  }

  @override
  String learningQuizQuestions(int count) {
    return '퀴즈 $count문항';
  }

  @override
  String learningDue(String date) {
    return '마감 $date';
  }

  @override
  String get learningNotStarted => '시작 전';

  @override
  String get learningCompletedStatus => '완료';

  @override
  String learningProgress(int percent) {
    return '진행률 $percent%';
  }

  @override
  String get learningContinue => '학습 계속하기';

  @override
  String get learningStart => '학습 시작하기';

  @override
  String get learningPolicyNote =>
      '합격 점수, 재응시 횟수, 수료증 유효 기간은 게시 전에 콘텐츠 책임자가 승인합니다.';

  @override
  String get profileNewsTitle => '회사 소식';

  @override
  String get profileNewsAll => '전체';

  @override
  String get profileNewsViewFull => '전체 내용 보기';

  @override
  String get profileNewsAckNote => '확인이 필요한 공지에는 \'읽었습니다\' 버튼이 있습니다.';

  @override
  String get profileNotificationsTitle => '내 알림';

  @override
  String get profileAccountSection => '계정';

  @override
  String profileEmployeeMeta(String id) {
    return '사번: $id · 허용된 정보 보기';
  }

  @override
  String get profileAccountActions => '언어 / 보안 / 로그아웃';

  @override
  String get profilePushNote =>
      '푸시 알림에는 \'새 업데이트가 있습니다\'만 표시됩니다. 민감한 데이터는 앱을 열고 인증한 후 확인하세요.';

  @override
  String get profileLanguageSettings => '언어 및 설정';

  @override
  String get profileSecurity => '보안';

  @override
  String get commonComingSoon => '곧 제공될 예정입니다';

  @override
  String get commonPressBackAgainToExit => '한 번 더 누르면 앱이 종료됩니다';

  @override
  String get notificationOpenHint => '탭하여 자세히 보기';

  @override
  String get chatAttachMedia => '사진 및 동영상';

  @override
  String get chatAttachFile => '파일';

  @override
  String get chatFileTypeTitle => '파일 형식 선택';

  @override
  String get chatFileTypePdf => 'PDF';

  @override
  String get chatFileTypeWord => 'Word';

  @override
  String get chatFileTypeExcel => 'Excel';

  @override
  String get chatFileTypePowerPoint => 'PowerPoint';

  @override
  String get chatFileTypeText => '텍스트 (TXT, CSV)';

  @override
  String get chatFileTypeAll => '모든 파일';

  @override
  String get chatOpenWith => '다른 앱으로 열기';

  @override
  String get chatFileOpenFailed => '이 파일을 열 수 없습니다';

  @override
  String get chatMediaUnavailable => '이 콘텐츠를 불러올 수 없습니다';

  @override
  String get chatMicPermissionTitle => '마이크 권한이 필요합니다';

  @override
  String get chatMicPermissionMessage => '음성 메시지를 녹음하려면 설정에서 마이크 접근을 허용해 주세요.';

  @override
  String get chatOpenSettings => '설정 열기';

  @override
  String get chatMicPermissionDenied => '마이크 권한이 거부되었습니다';

  @override
  String chatRecording(String duration) {
    return '녹음 중 · $duration';
  }

  @override
  String get chatVoiceRecord => '음성 녹음';

  @override
  String get chatStopRecording => '중지하고 보내기';

  @override
  String get chatCancelRecording => '녹음 취소';

  @override
  String get chatPlay => '재생';

  @override
  String get chatPause => '일시 정지';

  @override
  String get chatVoiceNote => '음성 메시지';
}
