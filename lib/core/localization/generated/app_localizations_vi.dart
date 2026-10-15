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
  String get commonEmpty => 'Không có dữ liệu';

  @override
  String get commonErrorTitle => 'Đã xảy ra lỗi';

  @override
  String get errorNetwork =>
      'Không có kết nối mạng. Vui lòng kiểm tra và thử lại.';

  @override
  String get errorTimeout => 'Yêu cầu đã quá thời gian chờ. Vui lòng thử lại.';

  @override
  String get errorUnauthorized =>
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';

  @override
  String get errorForbidden => 'Bạn không có quyền thực hiện thao tác này.';

  @override
  String get errorNotFound => 'Không tìm thấy nội dung yêu cầu.';

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
      'Vui lòng xác thực tài khoản để xem thông tin của bạn.';

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
      'Công ty có đăng nhập một lần (SSO)? Chọn “Đăng nhập công ty”.';

  @override
  String get authSsoButton => 'Đăng nhập công ty';

  @override
  String get authFirstTimeTitle => 'Lần đầu sử dụng';

  @override
  String get authFirstTimeBody =>
      'HR cấp mã kích hoạt. Hãy xác minh số điện thoại rồi đặt mã PIN trên thiết bị.';

  @override
  String get authSharedDeviceNotice =>
      'Dùng chung điện thoại? Đăng xuất hoàn toàn sau mỗi phiên.';

  @override
  String get authAccountRequired =>
      'Vui lòng nhập mã nhân viên hoặc tài khoản công ty';

  @override
  String get authPhoneRequired => 'Vui lòng nhập số điện thoại đã đăng ký';

  @override
  String get authSecurityDialogTitle => 'Bảo mật doanh nghiệp';

  @override
  String get authSecurityDialogMessage =>
      'Phiên làm việc và dữ liệu của bạn được bảo vệ bằng mã hóa đầu cuối theo chính sách bảo mật nhân sự của doanh nghiệp.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Mật khẩu';

  @override
  String get authPasswordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get authChangePassword => 'Đổi mật khẩu';

  @override
  String get authCurrentPassword => 'Mật khẩu hiện tại';

  @override
  String get authNewPassword => 'Mật khẩu mới';

  @override
  String get authConfirmPassword => 'Nhập lại mật khẩu mới';

  @override
  String get authPasswordMismatch => 'Mật khẩu nhập lại không khớp';

  @override
  String get authPasswordChanged =>
      'Đã đổi mật khẩu. Vui lòng đăng nhập lại bằng mật khẩu mới.';

  @override
  String get authPasswordRejected =>
      'Mật khẩu hiện tại không đúng hoặc mật khẩu mới chưa đạt yêu cầu.';

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
      'Chế độ demo: nhập mã nhân viên/số điện thoại bất kỳ hoặc tiếp tục với tư cách khách.';

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
  String get homeChatTitle => 'Trò chuyện thử nghiệm';

  @override
  String get homeChatSubtitle => 'Công cụ trò chuyện dùng dịch vụ giả lập';

  @override
  String get homeSettingsTitle => 'Cài đặt';

  @override
  String get homeSettingsSubtitle => 'Ngôn ngữ và thông tin ứng dụng';

  @override
  String get homeShowcaseTitle => 'Giới thiệu các thành phần giao diện';

  @override
  String get homeShowcaseSubtitle =>
      'Các thành phần và trạng thái của hệ thống thiết kế';

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
  String get profileGuestBadge => 'Phiên dùng của khách';

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
  String get chatTranscribing => 'Đang chuyển giọng nói thành chữ…';

  @override
  String get chatRateGood => 'Câu trả lời tốt';

  @override
  String get chatRateBad => 'Câu trả lời chưa tốt';

  @override
  String get chatReadAloud => 'Đọc thành tiếng';

  @override
  String get chatStopReading => 'Dừng đọc';

  @override
  String get chatActionFailed => 'Không thực hiện được. Vui lòng thử lại.';

  @override
  String get chatRename => 'Đổi tên';

  @override
  String get chatRenameTitle => 'Đổi tên cuộc trò chuyện';

  @override
  String get chatPin => 'Ghim';

  @override
  String get chatUnpin => 'Bỏ ghim';

  @override
  String get chatDelete => 'Xóa';

  @override
  String get chatDeleteConfirmTitle => 'Xóa cuộc trò chuyện này?';

  @override
  String get chatDeleteConfirmMessage =>
      'Cuộc trò chuyện sẽ bị xóa khỏi danh sách của bạn trên cả ứng dụng và website. Không thể hoàn tác thao tác này.';

  @override
  String get chatPinned => 'Đã ghim';

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
  String get showcaseTitle => 'Giới thiệu các thành phần giao diện';

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
  String get showcaseShowSnackbar => 'Hiện thanh thông báo ngắn';

  @override
  String get showcaseSnackbarMessage =>
      'Đây là thanh thông báo ngắn có thể tái sử dụng.';

  @override
  String get showcaseSendNotification => 'Gửi thông báo trong ứng dụng';

  @override
  String get showcaseNotificationTitle => 'Xin chào từ trung tâm thông báo';

  @override
  String get showcaseNotificationBody =>
      'Thông báo trong ứng dụng được gửi qua một dịch vụ có thể thay thế.';

  @override
  String get showcaseAttachments => 'Tệp đính kèm';

  @override
  String get mainNavHome => 'Trang chủ';

  @override
  String get mainNavAskHr => 'Hỏi HR';

  @override
  String get mainNavMyWork => 'Công việc của tôi';

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
  String get headerSubtitle =>
      'Trợ lý AI doanh nghiệp và không gian làm việc cho nhân viên';

  @override
  String get headerTokenQuota => 'Hạn mức token';

  @override
  String get headerQuotaUnavailable => 'Không tải được hạn mức';

  @override
  String get headerQuotaExceeded => 'Đã vượt hạn mức';

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
    return 'Lịch sử trò chuyện với $name';
  }

  @override
  String get profileApprovals => 'Yêu cầu chờ phê duyệt';

  @override
  String get profileSettings => 'Cài đặt';

  @override
  String get elearningCourses => 'Khóa học và đào tạo';

  @override
  String get elearningTests => 'Bài kiểm tra chứng chỉ';

  @override
  String get myWorkTitle => 'Công việc của tôi';

  @override
  String get myWorkChecklistTitle => 'Danh sách công việc hội nhập';

  @override
  String get myWorkCasesTitle => 'Hồ sơ và yêu cầu của tôi';

  @override
  String get myWorkApprovalsTitle => 'Chờ tôi phê duyệt';

  @override
  String get homeNewsSection => 'BẢN TIN CÔNG TY';

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
  String get askHrSearchPrompt => 'Nhập câu hỏi… Ví dụ: quy định nghỉ phép';

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
      'Hoàn tất danh sách công việc nhận việc · hạn 10/10';

  @override
  String get homeNoUpcomingWork => 'Không có việc đến hạn trong 30 ngày tới';

  @override
  String get homeUpcomingUnavailable => 'Không tải được lịch';

  @override
  String homeUpcomingItem(String title, String when) {
    return '$title · $when';
  }

  @override
  String get homeMyCoursesDetail => 'An toàn lao động cơ bản · còn 12 phút';

  @override
  String get homePendingCaseDetail => 'Đang chờ HR phản hồi · dự kiến 09/10';

  @override
  String get homeQuotaTitle => 'Hạn mức token AI';

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
      'Cần xác minh thêm khi truy cập thông tin cá nhân. Khiếu nại được lập thành hồ sơ bảo mật để HR xử lý.';

  @override
  String get askHrViewPolicySources => 'Xem quy định và nguồn tham khảo';

  @override
  String get askHrAnswerTitle => 'Quy định nghỉ phép năm';

  @override
  String get askHrAnswerBody =>
      'Theo chính sách đã phê duyệt, bạn gửi yêu cầu đến quản lý theo quy trình công ty. Điều kiện cụ thể tùy thuộc loại hợp đồng và số ngày phép còn lại.';

  @override
  String get askHrSourceEyebrow => 'NGUỒN ĐƯỢC DUYỆT';

  @override
  String get askHrSourceTitle => 'Chính sách nghỉ phép • bản 2.1';

  @override
  String get askHrSourceMeta => 'Hiệu lực: 01/09/2026 · Phụ trách: HR';

  @override
  String get askHrSourcePath =>
      'Kho tài liệu công ty → bản có quyền truy cập → mục 3.2';

  @override
  String get askHrSourceWarning =>
      'Không tìm thấy phiên bản còn hiệu lực hoặc có thông tin mâu thuẫn? Hãy chuyển HR xác minh; không xem câu trả lời là quy định đã được xác nhận.';

  @override
  String get askHrOpenSource => 'Mở tài liệu gốc';

  @override
  String get askHrCreateRequest => 'Tạo yêu cầu HR';

  @override
  String get chatHubTitle => 'Danh sách trò chuyện';

  @override
  String get profileChatList => 'Danh sách trò chuyện';

  @override
  String get profileChatListSubtitle =>
      'Trợ lý AI và lịch sử trò chuyện (tạm thời)';

  @override
  String get myWorkOnboardingEyebrow => 'HỘI NHẬP';

  @override
  String get myWorkOnboardingRole => 'Nhân viên vận hành · Nhà máy A';

  @override
  String get myWorkOnboardingTemplate =>
      'Mẫu: vị trí + địa điểm + loại hợp đồng · đã được HR duyệt';

  @override
  String myWorkOnboardingProgress(int done, int total) {
    return '$done/$total mục đã xác nhận';
  }

  @override
  String get myWorkOnboardingShowRest => 'Xem các mục còn lại';

  @override
  String get myWorkOnboardingCollapse => 'Thu gọn';

  @override
  String get myWorkOnboardingEvidenceNote =>
      '“Hoàn tất danh sách công việc” ghi nhận minh chứng; hồ sơ chính thức được hệ thống nguồn cập nhật sau khi kiểm tra.';

  @override
  String get myWorkCasesEmpty => 'Bạn chưa có hồ sơ nào.';

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
      'Bạn chỉ được xem và bổ sung thông tin trong hồ sơ của mình.';

  @override
  String get myWorkCaseAddDocs => 'Bổ sung tài liệu';

  @override
  String myWorkCaseDocsAdded(int count) {
    return 'Đã đính kèm $count tệp vào hồ sơ';
  }

  @override
  String get myWorkCaseEscalationNote =>
      'Quá hạn → A0 nhắc việc và chuyển yêu cầu xử lý ở cấp cao hơn đến người phụ trách.';

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
  String get myWorkRequestTypePolicy => 'Chính sách và phúc lợi';

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
      'Chỉ chia sẻ thông tin cần thiết. Thông tin nhạy cảm được chuyển đến HR có quyền xử lý.';

  @override
  String get myWorkRequestSubmit => 'Gửi yêu cầu';

  @override
  String get myWorkRequestAfterTitle => 'Sau khi gửi';

  @override
  String get myWorkRequestAfterBody =>
      'Bạn nhận mã hồ sơ (ví dụ: #HR-1042) · thời gian phản hồi dự kiến: 2 ngày làm việc · người xử lý: HR được phân công.';

  @override
  String get myWorkRequestUrgentNote =>
      'Khiếu nại/yêu cầu khẩn cấp được chuyển thẳng đến người có thẩm quyền xử lý, không qua quản lý trực tiếp.';

  @override
  String myWorkRequestSubmitted(String id) {
    return 'Đã gửi yêu cầu · $id';
  }

  @override
  String get myWorkRoleEmployee => 'Nhân viên';

  @override
  String get myWorkRoleHrAdmin => 'HR / Quản trị viên';

  @override
  String get myWorkRoleDemoHint =>
      'Chế độ demo: chọn vai trò để xem trước thẻ Công việc của tôi';

  @override
  String get hrApprovalsEyebrow => 'DÀNH CHO NGƯỜI CÓ THẨM QUYỀN PHÊ DUYỆT';

  @override
  String get hrApprovalsTitle => 'Chờ tôi phê duyệt';

  @override
  String get hrApprovalProbationTitle => 'Hồ sơ đánh giá thử việc';

  @override
  String get hrApprovalProbationMeta => '#PB-238 · Nguyễn A · hạn 11/10';

  @override
  String get hrApprovalProbationBadge => 'Chờ duyệt';

  @override
  String get hrApprovalChecklistTitle => 'Danh sách công việc có ngoại lệ';

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
  String get hrProbationTitle => 'Đánh giá thử việc #PB-238';

  @override
  String get hrProbationChecklist => 'Danh sách kiểm tra: 12/13 mục';

  @override
  String get hrProbationTraining => 'Đào tạo bắt buộc: đã xác nhận';

  @override
  String get hrProbationManagerOpinion =>
      'Ý kiến của quản lý: cần bổ sung thông tin';

  @override
  String get hrProbationMissingEvidence =>
      'Còn thiếu minh chứng. Vui lòng yêu cầu bổ sung thông tin trước khi quyết định.';

  @override
  String get hrProbationCommentHint => 'Nhận xét và căn cứ của người phê duyệt';

  @override
  String get hrProbationRequestMore => 'Yêu cầu bổ sung';

  @override
  String get hrProbationEscalate => 'Chuyển HR/Pháp chế xem xét';

  @override
  String get hrProbationDecisionNote =>
      'Các lựa chọn quyết định chỉ hiển thị khi đã đủ điều kiện, người dùng có đúng thẩm quyền và đã xác nhận lại.';

  @override
  String hrQueueOverdue(int count) {
    return 'Quá hạn $count';
  }

  @override
  String hrQueuePending(int count) {
    return 'Chờ duyệt $count';
  }

  @override
  String get hrQueueCase1Title => 'Hồ sơ #HR-1051';

  @override
  String get hrQueueCase1Meta =>
      'Khiếu nại · chuyển xử lý bảo mật · hạn hôm nay';

  @override
  String get hrQueueCase2Title => 'Hồ sơ #ON-320';

  @override
  String get hrQueueCase2Meta => 'Thiếu giấy tờ nhận việc · phụ trách: HR A';

  @override
  String get hrQueueCase3Title => 'Hồ sơ #TR-102';

  @override
  String get hrQueueCase3Meta => 'Khóa học chưa có bản nội dung đã duyệt';

  @override
  String get hrQueueOpenWeb => 'Xem hàng đợi trên Web';

  @override
  String get hrQueueMobileNote =>
      'Ứng dụng di động dùng để tiếp nhận và theo dõi. Cấu hình luồng xử lý, duyệt kho kiến thức và điều tra phức tạp được thực hiện trên không gian làm việc bản web.';

  @override
  String get learningMyTitle => 'Học tập của tôi';

  @override
  String learningMandatorySummary(int count, String date) {
    return '$count khóa học bắt buộc · hạn $date';
  }

  @override
  String get learningNoMandatory =>
      'Không có khóa học bắt buộc nào chưa hoàn thành.';

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
    return 'Bài kiểm tra: $count câu';
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
      'Điểm đạt, giới hạn số lần làm lại và thời hạn hiệu lực chứng nhận do người phụ trách nội dung phê duyệt trước khi phát hành.';

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
      'Thông báo đẩy chỉ hiển thị “Có cập nhật mới”. Hãy mở ứng dụng và xác thực để xem dữ liệu nhạy cảm.';

  @override
  String get profileLanguageSettings => 'Ngôn ngữ và cài đặt';

  @override
  String get profileSecurity => 'Bảo mật';

  @override
  String get commonComingSoon => 'Tính năng sắp ra mắt';

  @override
  String get commonPressBackAgainToExit =>
      'Nhấn nút Quay lại lần nữa để thoát ứng dụng';

  @override
  String get notificationOpenHint => 'Chạm để xem chi tiết';

  @override
  String get chatAttachMedia => 'Ảnh và video';

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
  String get chatMicPermissionTitle => 'Cần quyền truy cập micro';

  @override
  String get chatMicPermissionMessage =>
      'Hãy cho phép dùng micro trong Cài đặt để ghi âm tin nhắn thoại.';

  @override
  String get chatOpenSettings => 'Mở cài đặt';

  @override
  String get chatMicPermissionDenied => 'Quyền truy cập micro đã bị từ chối';

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
