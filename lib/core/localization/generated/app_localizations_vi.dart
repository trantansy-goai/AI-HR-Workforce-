// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonConfirm => 'Xác nhận';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonLoading => 'Đang tải…';

  @override
  String get commonEmpty => 'Chưa có nội dung';

  @override
  String get commonErrorTitle => 'Đã xảy ra lỗi';

  @override
  String get errorNetwork =>
      'Không có kết nối mạng. Vui lòng kiểm tra và thử lại.';

  @override
  String get errorTimeout =>
      'Yêu cầu mất quá nhiều thời gian. Vui lòng thử lại.';

  @override
  String get errorUnauthorized =>
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';

  @override
  String get errorForbidden => 'Bạn không có quyền thực hiện thao tác này.';

  @override
  String get errorNotFound => 'Không tìm thấy dữ liệu yêu cầu.';

  @override
  String get errorValidation =>
      'Một số thông tin không hợp lệ. Vui lòng kiểm tra lại.';

  @override
  String get errorRateLimited =>
      'Bạn thao tác quá nhanh. Vui lòng đợi một lát rồi thử lại.';

  @override
  String get errorServer => 'Máy chủ gặp sự cố. Vui lòng thử lại sau.';

  @override
  String get errorStorage => 'Không thể truy cập bộ nhớ thiết bị.';

  @override
  String get errorUnknown => 'Đã xảy ra lỗi không mong muốn.';

  @override
  String get authSignInTitle => 'Chào mừng trở lại';

  @override
  String get authSignInSubtitle =>
      'Vui lòng xác nhận tài khoản để xem thông tin của mình.';

  @override
  String get authHeaderTitle => 'GO AI HR';

  @override
  String get authSecurityBadge => 'BẢO MẬT';

  @override
  String get authBrandEyebrow => 'GO AI · HR WORKFORCE';

  @override
  String get authEmployeeAccountLabel => 'Mã nhân viên hoặc tài khoản công ty';

  @override
  String get authEmployeeAccountHint =>
      'Nhập mã nhân viên hoặc tài khoản công ty';

  @override
  String get authPhoneNumberLabel => 'Số điện thoại đã đăng ký';

  @override
  String get authPhoneNumberHint => 'Nhập số điện thoại đã đăng ký';

  @override
  String get authSendVerificationCode => 'Gửi mã xác thực';

  @override
  String get authSsoPrompt =>
      'Doanh nghiệp có SSO? Chọn \"Đăng nhập công ty\".';

  @override
  String get authSsoButton => 'Đăng nhập công ty';

  @override
  String get authFirstTimeTitle => 'Lần đầu sử dụng';

  @override
  String get authFirstTimeBody =>
      'HR cấp mã kích hoạt; xác minh số điện thoại rồi đặt PIN trên thiết bị.';

  @override
  String get authSharedDeviceNotice =>
      'Dùng chung điện thoại? Đăng xuất hoàn toàn sau mỗi phiên.';

  @override
  String get authAccountRequired => 'Vui lòng nhập mã nhân viên hoặc tài khoản';

  @override
  String get authPhoneRequired => 'Vui lòng nhập số điện thoại đã đăng ký';

  @override
  String get authSecurityDialogTitle => 'Bảo mật doanh nghiệp';

  @override
  String get authSecurityDialogMessage =>
      'Phiên làm việc và dữ liệu được bảo vệ bằng mã hóa đầu cuối tuân thủ tiêu chuẩn an toàn thông tin nhân sự doanh nghiệp.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Mật khẩu';

  @override
  String get authPasswordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get authSignInButton => 'Đăng nhập';

  @override
  String get authContinueAsGuest => 'Tiếp tục với tư cách khách';

  @override
  String get authEmailInvalid => 'Vui lòng nhập email hợp lệ';

  @override
  String authPasswordTooShort(int min) {
    return 'Mật khẩu phải có ít nhất $min ký tự';
  }

  @override
  String get authDemoHint =>
      'Chế độ demo: nhập thông tin bất kỳ hoặc tiếp tục với tư cách khách.';

  @override
  String get authSignOut => 'Đăng xuất';

  @override
  String get authSignOutConfirmTitle => 'Đăng xuất?';

  @override
  String get authSignOutConfirmMessage =>
      'Bạn sẽ cần đăng nhập lại để tiếp tục.';

  @override
  String get authGuestName => 'Khách';

  @override
  String get homeTitle => 'Trang chủ';

  @override
  String homeGreeting(String name) {
    return 'Xin chào, $name';
  }

  @override
  String get homeSubtitle => 'GO AI Workforce dành cho nhân viên.';

  @override
  String get homeChatTitle => 'Demo Chat';

  @override
  String get homeChatSubtitle => 'Chat engine tổng quát với provider giả lập';

  @override
  String get homeSettingsTitle => 'Cài đặt';

  @override
  String get homeSettingsSubtitle => 'Ngôn ngữ và thông tin ứng dụng';

  @override
  String get homeShowcaseTitle => 'Trình diễn nền tảng';

  @override
  String get homeShowcaseSubtitle =>
      'Các thành phần và trạng thái của design system';

  @override
  String get homeProfileTitle => 'Hồ sơ';

  @override
  String get homeProfileSubtitle => 'Người dùng và phiên hiện tại';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsLanguageSystem => 'Theo hệ thống';

  @override
  String get settingsAbout => 'Thông tin';

  @override
  String get settingsAppName => 'Tên ứng dụng';

  @override
  String get settingsVersion => 'Phiên bản';

  @override
  String get settingsEnvironment => 'Môi trường';

  @override
  String get settingsAccount => 'Tài khoản';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String get profileUserId => 'Mã người dùng';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileNoEmail => 'Chưa cung cấp';

  @override
  String get profileGuestBadge => 'Phiên khách';

  @override
  String get chatTitle => 'Cuộc trò chuyện';

  @override
  String get chatEmptyConversations => 'Chưa có cuộc trò chuyện nào';

  @override
  String get chatEmptyMessages => 'Chưa có tin nhắn. Hãy gửi lời chào!';

  @override
  String get chatComposerHint => 'Nhập tin nhắn';

  @override
  String get chatSend => 'Gửi';

  @override
  String get chatAttach => 'Đính kèm tệp';

  @override
  String get chatStop => 'Dừng tạo phản hồi';

  @override
  String get chatRegenerate => 'Tạo lại';

  @override
  String get chatFailed => 'Chưa gửi được. Chạm để thử lại.';

  @override
  String chatReplyingTo(String name) {
    return 'Đang trả lời $name';
  }

  @override
  String get chatReply => 'Trả lời';

  @override
  String get chatCancelReply => 'Hủy trả lời';

  @override
  String chatTyping(String name) {
    return '$name đang nhập…';
  }

  @override
  String get chatSources => 'Nguồn tham khảo';

  @override
  String get chatYou => 'Bạn';

  @override
  String get chatDemoHint =>
      'Mẹo: thêm \"/fail\" vào tin nhắn để giả lập gửi thất bại.';

  @override
  String get chatUploading => 'Đang tải lên…';

  @override
  String get notFoundTitle => 'Không tìm thấy trang';

  @override
  String get notFoundMessage => 'Trang bạn tìm kiếm không tồn tại.';

  @override
  String get notFoundGoHome => 'Về trang chủ';

  @override
  String get showcaseTitle => 'Trình diễn nền tảng';

  @override
  String get showcaseButtons => 'Nút bấm';

  @override
  String get showcasePrimary => 'Chính';

  @override
  String get showcaseSecondary => 'Phụ';

  @override
  String get showcaseTextButton => 'Văn bản';

  @override
  String get showcaseInputs => 'Ô nhập liệu';

  @override
  String get showcaseSampleInput => 'Ô nhập mẫu';

  @override
  String get showcaseStates => 'Trạng thái';

  @override
  String get showcaseFeedback => 'Phản hồi';

  @override
  String get showcaseShowDialog => 'Hiện hộp thoại';

  @override
  String get showcaseDialogMessage =>
      'Đây là hộp thoại xác nhận có thể tái sử dụng.';

  @override
  String get showcaseShowSnackbar => 'Hiện snackbar';

  @override
  String get showcaseSnackbarMessage => 'Đây là snackbar có thể tái sử dụng.';

  @override
  String get showcaseSendNotification => 'Gửi thông báo trong ứng dụng';

  @override
  String get showcaseNotificationTitle => 'Xin chào từ trung tâm thông báo';

  @override
  String get showcaseNotificationBody =>
      'Thông báo trong ứng dụng được gửi qua một service có thể thay thế.';

  @override
  String get showcaseAttachments => 'Tệp đính kèm';

  @override
  String get mainNavHome => 'Trang chủ';

  @override
  String get mainNavAskHr => 'Hỏi HR';

  @override
  String get mainNavMyWork => 'Việc của tôi';

  @override
  String get mainNavLearning => 'Học tập';

  @override
  String get mainNavAccount => 'Tài khoản';

  @override
  String get mainNavTimeline => 'Trang chủ';

  @override
  String get mainNavChat => 'Hỏi HR';

  @override
  String get mainNavDocuments => 'Tài liệu';

  @override
  String get mainNavProfile => 'Tài khoản';

  @override
  String get headerSubtitle => 'Trợ lý AI Doanh nghiệp & Không gian làm việc';

  @override
  String get headerTokenQuota => 'Hạn mức token';

  @override
  String get headerQuotaUnavailable => 'Không thể tải hạn mức';

  @override
  String get headerQuotaExceeded => 'Vượt quá hạn mức';

  @override
  String get headerQuotaWarning => 'Cảnh báo hạn mức';

  @override
  String get notificationTitle => 'Thông báo';

  @override
  String get notificationEmpty => 'Chưa có thông báo nào';

  @override
  String get chatAiAgents => 'TRỢ LÝ AI & HR';

  @override
  String get chatOther => 'KHÁC';

  @override
  String get chatHumanBlockedHint =>
      'Chat trực tiếp đang chờ backend tích hợp (BLOCKED)';

  @override
  String get chatStartNew => 'Bắt đầu cuộc trò chuyện mới';

  @override
  String chatAgentHistory(String name) {
    return 'Lịch sử trò chuyện $name';
  }

  @override
  String get profileApprovals => 'Yêu cầu phê duyệt';

  @override
  String get profileSettings => 'Cài đặt';

  @override
  String get elearningCourses => 'Khóa học đào tạo';

  @override
  String get elearningTests => 'Bài kiểm tra chứng chỉ';

  @override
  String get myWorkTitle => 'Việc của tôi';

  @override
  String get myWorkChecklistTitle => 'Checklist hội nhập';

  @override
  String get myWorkCasesTitle => 'Yêu cầu & Case của tôi';

  @override
  String get myWorkApprovalsTitle => 'Chờ tôi phê duyệt';

  @override
  String get homeNewsSection => 'BẢN TIN MỚI';

  @override
  String get homeViewAllNews => 'Xem tất cả';

  @override
  String get homeUpcomingWork => 'Việc sắp đến hạn';

  @override
  String get homeMyCourses => 'Khóa học của tôi';

  @override
  String get homePendingCase => 'Yêu cầu HR #HR-1042';

  @override
  String get accountNews => 'Bản tin nội bộ';

  @override
  String get askHrSearchPrompt =>
      'Nhập câu hỏi… Ví dụ: quy trình xin nghỉ phép';

  @override
  String get askHrPolicyChip => 'Chính sách';

  @override
  String get askHrFormChip => 'Biểu mẫu';

  @override
  String get askHrMyRequestsChip => 'Yêu cầu của tôi';

  @override
  String get homeAppBarTitle => 'GO AI · HR';

  @override
  String homeHeroGreeting(String name) {
    return 'Chào $name 👋';
  }

  @override
  String get homePendingTasksLead => 'Bạn có ';

  @override
  String homePendingTasksCount(int count) {
    return '$count việc';
  }

  @override
  String get homePendingTasksTail => ' cần hoàn thành tuần này.';

  @override
  String get homeAskPolicyAction => 'Hỏi chính sách';

  @override
  String get homeSendRequestAction => 'Gửi yêu cầu';

  @override
  String get homeUpcomingWorkDetail =>
      'Hoàn tất checklist nhận việc · hạn 10/10';

  @override
  String get homeMyCoursesDetail => 'An toàn lao động cơ bản · còn 12 phút';

  @override
  String get homePendingCaseDetail => 'Đang chờ HR phản hồi · dự kiến 09/10';

  @override
  String get homeQuotaTitle => 'Hạn mức AI token';

  @override
  String get homeNewsEmpty => 'Chưa có bản tin nào.';

  @override
  String get homeNewsLoading => 'Đang tải bản tin...';

  @override
  String get askHrTitle => 'Bạn cần HR hỗ trợ gì?';

  @override
  String get askHrSend => 'Gửi câu hỏi';

  @override
  String get askHrSampleQuestion => 'Tôi cần xem quy định nghỉ phép.';

  @override
  String get askHrSampleAnswer =>
      'Tôi có thể tóm tắt quy định hiện hành và dẫn đến bản được phê duyệt. Bạn muốn xem điều kiện hay cách gửi yêu cầu?';

  @override
  String get askHrPrivacyNotice =>
      'Thông tin cá nhân cần xác minh thêm. Khiếu nại sẽ được mở Case bảo mật để HR xử lý.';

  @override
  String get askHrViewPolicySources => 'Xem quy định & nguồn';

  @override
  String get askHrAnswerTitle => 'Quy định nghỉ phép năm';

  @override
  String get askHrAnswerBody =>
      'Theo chính sách đã phê duyệt, bạn gửi yêu cầu đến quản lý theo quy trình của công ty. Điều kiện cụ thể tùy loại hợp đồng và dữ liệu nghỉ còn lại.';

  @override
  String get askHrSourceEyebrow => 'NGUỒN ĐƯỢC DUYỆT';

  @override
  String get askHrSourceTitle => 'Chính sách nghỉ phép • bản 2.1';

  @override
  String get askHrSourceMeta => 'Hiệu lực: 01/09/2026 · Chủ sở hữu: HR';

  @override
  String get askHrSourcePath =>
      'Kho tài liệu công ty → bản có quyền truy cập → mục 3.2';

  @override
  String get askHrSourceWarning =>
      'Không tìm thấy bản hiệu lực hoặc có mâu thuẫn? Chuyển HR xác minh; không trả lời như quy định chắc chắn.';

  @override
  String get askHrOpenSource => 'Mở tài liệu gốc';

  @override
  String get askHrCreateRequest => 'Tạo yêu cầu HR';

  @override
  String get chatHubTitle => 'Danh sách chat';

  @override
  String get profileChatList => 'Danh sách chat';

  @override
  String get profileChatListSubtitle =>
      'Trợ lý AI & lịch sử trò chuyện (tạm thời)';

  @override
  String get myWorkOnboardingEyebrow => 'HỘI NHẬP';

  @override
  String get myWorkOnboardingRole => 'Nhân viên vận hành · Nhà máy A';

  @override
  String get myWorkOnboardingTemplate =>
      'Template: vị trí + địa điểm + loại hợp đồng · đã được HR duyệt';

  @override
  String myWorkOnboardingProgress(int done, int total) {
    return '$done/$total mục đã xác nhận';
  }

  @override
  String get myWorkOnboardingShowRest => 'Xem mục còn lại';

  @override
  String get myWorkOnboardingCollapse => 'Thu gọn';

  @override
  String get myWorkOnboardingEvidenceNote =>
      '“Hoàn tất checklist” là ghi nhận bằng chứng; hồ sơ chính thức do hệ thống nguồn cập nhật sau kiểm tra.';

  @override
  String get myWorkCasesEmpty => 'Bạn chưa có Case nào.';

  @override
  String myWorkCaseUpdated(String date) {
    return 'Cập nhật $date';
  }

  @override
  String get myWorkStepReceived => 'Đã nhận';

  @override
  String get myWorkStepAssigned => 'Đã giao';

  @override
  String get myWorkStepInProgress => 'Đang xử lý';

  @override
  String get myWorkStepDone => 'Hoàn tất';

  @override
  String myWorkCaseStatusBody(String date) {
    return 'Dự kiến phản hồi $date. Nếu cần thêm thông tin, bạn sẽ nhận thông báo.';
  }

  @override
  String get myWorkCaseSecureTitle => 'Trao đổi bảo mật';

  @override
  String get myWorkCaseSecureBody =>
      'Xem và gửi bổ sung trong phạm vi Case của chính bạn.';

  @override
  String get myWorkCaseAddDocs => 'Bổ sung tài liệu';

  @override
  String myWorkCaseDocsAdded(int count) {
    return 'Đã đính kèm $count tệp vào Case';
  }

  @override
  String get myWorkCaseEscalationNote =>
      'Quá hạn → A0 nhắc và chuyển cấp cho người phụ trách.';

  @override
  String get myWorkNewRequestButton => 'Gửi yêu cầu HR mới';

  @override
  String get myWorkNewRequest => 'Gửi yêu cầu HR';

  @override
  String get myWorkRequestTypeHint =>
      'Loại yêu cầu: xác nhận thông tin cá nhân';

  @override
  String get myWorkRequestTypePersonalInfo => 'Xác nhận thông tin cá nhân';

  @override
  String get myWorkRequestTypeLeave => 'Nghỉ phép';

  @override
  String get myWorkRequestTypePolicy => 'Chính sách & phúc lợi';

  @override
  String get myWorkRequestTypeComplaint => 'Khiếu nại (bảo mật)';

  @override
  String get myWorkRequestTypeRequired => 'Vui lòng chọn loại yêu cầu';

  @override
  String get myWorkRequestDescriptionHint => 'Mô tả ngắn việc cần hỗ trợ';

  @override
  String get myWorkRequestDescriptionRequired => 'Vui lòng mô tả ngắn yêu cầu';

  @override
  String get myWorkRequestAttachHint => 'Đính kèm tài liệu (nếu cần)';

  @override
  String myWorkRequestAttached(int count) {
    return '$count tệp đính kèm';
  }

  @override
  String get myWorkRequestPrivacyNotice =>
      'Chỉ chia sẻ nội dung cần thiết. Các thông tin nhạy cảm được chuyển đến HR theo quyền.';

  @override
  String get myWorkRequestSubmit => 'Gửi yêu cầu';

  @override
  String get myWorkRequestAfterTitle => 'Sau khi gửi';

  @override
  String get myWorkRequestAfterBody =>
      'Bạn nhận mã Case (vd. #HR-1042) · thời hạn phản hồi dự kiến: 2 ngày làm việc · người xử lý: HR được phân công.';

  @override
  String get myWorkRequestUrgentNote =>
      'Khiếu nại/khẩn cấp: chuyển thẳng tuyến xử lý có thẩm quyền, không qua quản lý trực tiếp.';

  @override
  String myWorkRequestSubmitted(String id) {
    return 'Đã gửi yêu cầu · $id';
  }

  @override
  String get myWorkRoleEmployee => 'Nhân viên';

  @override
  String get myWorkRoleHrAdmin => 'HR / Admin';

  @override
  String get myWorkRoleDemoHint => 'Chế độ demo: chọn vai trò để xem tab Việc';

  @override
  String get hrApprovalsEyebrow => 'DÀNH CHO NGƯỜI CÓ QUYỀN';

  @override
  String get hrApprovalsTitle => 'Chờ tôi phê duyệt';

  @override
  String get hrApprovalProbationTitle => 'Hồ sơ đánh giá thử việc';

  @override
  String get hrApprovalProbationMeta => '#PB-238 · Nguyễn A · hạn 11/10';

  @override
  String get hrApprovalProbationBadge => 'Chờ duyệt';

  @override
  String get hrApprovalChecklistTitle => 'Checklist có ngoại lệ';

  @override
  String get hrApprovalChecklistMeta => '#ON-320 · thiếu giấy tờ · hạn 09/10';

  @override
  String get hrApprovalChecklistBadge => 'Xác minh';

  @override
  String get hrApprovalsScopeNote =>
      '2 việc · quyền theo vị trí, đơn vị, quan hệ quản lý và mức thẩm quyền.';

  @override
  String get hrApprovalsOpenReview => 'Mở hồ sơ đánh giá';

  @override
  String get hrApprovalsNoBulkNote =>
      'Không có nút “Duyệt tất cả” cho quyết định thử việc.';

  @override
  String get hrProbationTitle => 'Review thử việc #PB-238';

  @override
  String get hrProbationChecklist => 'Checklist 12/13 mục';

  @override
  String get hrProbationTraining => 'Đào tạo bắt buộc: đã xác nhận';

  @override
  String get hrProbationManagerOpinion => 'Ý kiến quản lý: cần bổ sung';

  @override
  String get hrProbationMissingEvidence =>
      'Còn bằng chứng thiếu. Vui lòng yêu cầu bổ sung trước khi quyết định.';

  @override
  String get hrProbationCommentHint => 'Nhận xét & căn cứ của người duyệt';

  @override
  String get hrProbationRequestMore => 'Yêu cầu bổ sung';

  @override
  String get hrProbationEscalate => 'Chuyển HR/Legal xem xét';

  @override
  String get hrProbationDecisionNote =>
      'Các lựa chọn quyết định chỉ xuất hiện sau khi đủ điều kiện, đúng quyền và xác nhận lại.';

  @override
  String hrQueueOverdue(int count) {
    return 'Quá hạn $count';
  }

  @override
  String hrQueuePending(int count) {
    return 'Chờ duyệt $count';
  }

  @override
  String get hrQueueCase1Title => 'Case #HR-1051';

  @override
  String get hrQueueCase1Meta =>
      'Khiếu nại · chuyển tuyến bảo mật · hạn hôm nay';

  @override
  String get hrQueueCase2Title => 'Case #ON-320';

  @override
  String get hrQueueCase2Meta => 'Thiếu giấy tờ nhận việc · chủ sở hữu: HR A';

  @override
  String get hrQueueCase3Title => 'Case #TR-102';

  @override
  String get hrQueueCase3Meta => 'Khóa học chưa có bản nội dung đã duyệt';

  @override
  String get hrQueueOpenWeb => 'Xem hàng đợi trên Web';

  @override
  String get hrQueueMobileNote =>
      'Mobile dùng để nhận và theo dõi; cấu hình tuyến, duyệt KB, điều tra phức tạp dùng Web Workspace.';

  @override
  String get learningMyTitle => 'Học tập của tôi';

  @override
  String learningMandatorySummary(int count, String date) {
    return '$count khóa bắt buộc · hạn $date';
  }

  @override
  String get learningNoMandatory => 'Không có khóa bắt buộc đang chờ.';

  @override
  String get learningMandatoryBadge => 'Bắt buộc';

  @override
  String get learningModuleBadge => 'A7';

  @override
  String learningVideoMinutes(int minutes) {
    return 'Video $minutes phút';
  }

  @override
  String learningDocMinutes(int minutes) {
    return 'Tài liệu $minutes phút';
  }

  @override
  String learningQuizQuestions(int count) {
    return 'bài kiểm tra $count câu';
  }

  @override
  String learningDue(String date) {
    return 'hạn $date';
  }

  @override
  String get learningNotStarted => 'chưa bắt đầu';

  @override
  String get learningCompletedStatus => 'đã hoàn thành';

  @override
  String learningProgress(int percent) {
    return 'Tiến độ $percent%';
  }

  @override
  String get learningContinue => 'Tiếp tục học';

  @override
  String get learningStart => 'Bắt đầu học';

  @override
  String get learningPolicyNote =>
      'Điểm đạt, số lần làm lại và hiệu lực chứng nhận do chủ sở hữu nội dung phê duyệt trước khi phát hành.';

  @override
  String get learningEmptyCourses => 'Bạn chưa được giao khóa học nào.';

  @override
  String get profileNewsTitle => 'Bản tin công ty';

  @override
  String get profileNewsAll => 'Tất cả';

  @override
  String get profileNewsViewFull => 'Xem nội dung đầy đủ';

  @override
  String get profileNewsAckNote =>
      'Thông báo yêu cầu xác nhận sẽ có nút “Tôi đã đọc”.';

  @override
  String get profileNotificationsTitle => 'Thông báo của tôi';

  @override
  String get profileAccountSection => 'TÀI KHOẢN';

  @override
  String profileEmployeeMeta(String id) {
    return 'Mã nhân viên: $id · xem thông tin được phép';
  }

  @override
  String get profileAccountActions => 'Ngôn ngữ / bảo mật / đăng xuất';

  @override
  String get profilePushNote =>
      'Push chỉ nêu “Có cập nhật mới”; mở app và xác thực để xem dữ liệu nhạy cảm.';

  @override
  String get profileLanguageSettings => 'Ngôn ngữ & cài đặt';

  @override
  String get profileSecurity => 'Bảo mật';

  @override
  String get commonComingSoon => 'Tính năng sắp ra mắt';

  @override
  String get notificationOpenHint => 'Chạm để xem chi tiết';

  @override
  String get chatAttachMedia => 'Ảnh/Video';

  @override
  String get chatAttachFile => 'Tệp';

  @override
  String get chatFileTypeTitle => 'Chọn loại tệp';

  @override
  String get chatFileTypePdf => 'PDF';

  @override
  String get chatFileTypeWord => 'Word';

  @override
  String get chatFileTypeExcel => 'Excel';

  @override
  String get chatFileTypePowerPoint => 'PowerPoint';

  @override
  String get chatFileTypeText => 'Văn bản (TXT, CSV)';

  @override
  String get chatFileTypeAll => 'Tất cả tệp';

  @override
  String get chatOpenWith => 'Mở bằng ứng dụng khác';

  @override
  String get chatFileOpenFailed => 'Không mở được tệp này';

  @override
  String get chatMediaUnavailable => 'Không tải được nội dung';

  @override
  String get chatMicPermissionTitle => 'Cần quyền micro';

  @override
  String get chatMicPermissionMessage =>
      'Hãy cho phép dùng micro trong Cài đặt để ghi âm tin nhắn thoại.';

  @override
  String get chatOpenSettings => 'Mở cài đặt';

  @override
  String get chatMicPermissionDenied => 'Chưa có quyền dùng micro';

  @override
  String chatRecording(String duration) {
    return 'Đang ghi âm · $duration';
  }

  @override
  String get chatVoiceRecord => 'Ghi âm';

  @override
  String get chatStopRecording => 'Dừng và gửi';

  @override
  String get chatCancelRecording => 'Hủy ghi âm';

  @override
  String get chatPlay => 'Phát';

  @override
  String get chatPause => 'Tạm dừng';

  @override
  String get chatVoiceNote => 'Tin nhắn thoại';
}
