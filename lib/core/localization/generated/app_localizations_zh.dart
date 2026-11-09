// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get commonOk => '确定';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonRetry => '重试';

  @override
  String get commonClose => '关闭';

  @override
  String get commonLoading => '加载中…';

  @override
  String get commonEmpty => '暂无数据';

  @override
  String get commonErrorTitle => '出错了';

  @override
  String get errorNetwork => '无网络连接，请检查网络后重试。';

  @override
  String get errorTimeout => '请求超时，请重试。';

  @override
  String get errorUnauthorized => '登录已过期，请重新登录。';

  @override
  String get errorForbidden => '您没有执行此操作的权限。';

  @override
  String get errorNotFound => '找不到请求的内容。';

  @override
  String get errorValidation => '部分信息无效，请检查后重试。';

  @override
  String get errorRateLimited => '请求过于频繁，请稍后重试。';

  @override
  String get errorServer => '服务器出现问题，请稍后重试。';

  @override
  String get errorStorage => '无法访问设备存储。';

  @override
  String get errorUnknown => '发生意外错误。';

  @override
  String get authSignInTitle => '欢迎回来';

  @override
  String get authSignInSubtitle => '请验证您的账号以查看您的信息。';

  @override
  String get authHeaderTitle => 'GO AI HR';

  @override
  String get authSecurityBadge => '安全保障';

  @override
  String get authBrandEyebrow => 'GO AI · HR WORKFORCE';

  @override
  String get authEmployeeAccountLabel => '工号或公司账号';

  @override
  String get authEmployeeAccountHint => '请输入工号或公司账号';

  @override
  String get authPhoneNumberLabel => '已登记的手机号码';

  @override
  String get authPhoneNumberHint => '请输入已登记的手机号码';

  @override
  String get authSendVerificationCode => '发送验证码';

  @override
  String get authSsoPrompt => '企业已启用 SSO？请选择「公司登录」。';

  @override
  String get authSsoButton => '公司登录';

  @override
  String get authFirstTimeTitle => '首次使用';

  @override
  String get authFirstTimeBody => 'HR 会提供激活码；验证手机号码后，在设备上设置 PIN。';

  @override
  String get authSharedDeviceNotice => '使用共用手机？每次使用后请完全退出登录。';

  @override
  String get authAccountRequired => '请输入工号或公司账号';

  @override
  String get authPhoneRequired => '请输入已登记的手机号码';

  @override
  String get authSecurityDialogTitle => '企业安全';

  @override
  String get authSecurityDialogMessage => '您的会话和数据采用端到端加密保护，符合企业人力资源安全政策。';

  @override
  String get authEmailLabel => '邮箱';

  @override
  String get authPasswordLabel => '密码';

  @override
  String get authPasswordRequired => '请输入密码';

  @override
  String get authChangePassword => '修改密码';

  @override
  String get authCurrentPassword => '当前密码';

  @override
  String get authNewPassword => '新密码';

  @override
  String get authConfirmPassword => '确认新密码';

  @override
  String get authPasswordMismatch => '两次输入的密码不一致';

  @override
  String get authPasswordChanged => '密码已修改，请使用新密码重新登录。';

  @override
  String get authPasswordRejected => '当前密码错误，或新密码不符合要求。';

  @override
  String get authSignInButton => '登录';

  @override
  String get authContinueAsGuest => '以访客身份继续';

  @override
  String get authEmailInvalid => '请输入有效的邮箱地址';

  @override
  String authPasswordTooShort(int min) {
    return '密码至少需要 $min 个字符';
  }

  @override
  String get authDemoHint => '演示模式：输入任意工号/手机号码，或以访客身份继续。';

  @override
  String get authSignOut => '退出登录';

  @override
  String get authSignOutConfirmTitle => '退出登录？';

  @override
  String get authSignOutConfirmMessage => '您需要重新登录才能继续使用。';

  @override
  String get authGuestName => '访客';

  @override
  String get homeTitle => '首页';

  @override
  String homeGreeting(String name) {
    return '您好，$name';
  }

  @override
  String get homeSubtitle => '面向员工的 GO AI Workforce。';

  @override
  String get homeChatTitle => '聊天演示';

  @override
  String get homeChatSubtitle => '使用模拟服务的通用聊天引擎';

  @override
  String get homeSettingsTitle => '设置';

  @override
  String get homeSettingsSubtitle => '语言和应用信息';

  @override
  String get homeShowcaseTitle => '基础组件展示';

  @override
  String get homeShowcaseSubtitle => '设计系统组件与状态';

  @override
  String get homeProfileTitle => '个人资料';

  @override
  String get homeProfileSubtitle => '当前用户和会话';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsAppName => '应用名称';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsEnvironment => '环境';

  @override
  String get settingsAccount => '账号';

  @override
  String get profileTitle => '个人资料';

  @override
  String get profileUserId => '用户 ID';

  @override
  String get profileEmail => '邮箱';

  @override
  String get profileNoEmail => '未提供';

  @override
  String get profileGuestBadge => '访客会话';

  @override
  String get chatTitle => '对话';

  @override
  String get chatEmptyConversations => '暂无对话';

  @override
  String get chatEmptyMessages => '暂无消息，打个招呼吧！';

  @override
  String get chatComposerHint => '输入消息';

  @override
  String get chatSend => '发送';

  @override
  String get chatAttach => '添加附件';

  @override
  String get chatStop => '停止生成';

  @override
  String get chatRegenerate => '重新生成';

  @override
  String get chatFailed => '发送失败，点击重试。';

  @override
  String chatReplyingTo(String name) {
    return '正在回复 $name';
  }

  @override
  String get chatReply => '回复';

  @override
  String get chatCancelReply => '取消回复';

  @override
  String chatTyping(String name) {
    return '$name 正在输入…';
  }

  @override
  String get chatSources => '参考来源';

  @override
  String get chatTranscribing => '正在将语音转为文字…';

  @override
  String get chatRateGood => '回答很好';

  @override
  String get chatRateBad => '回答不好';

  @override
  String get chatReadAloud => '朗读';

  @override
  String get chatStopReading => '停止朗读';

  @override
  String get chatActionFailed => '操作未完成，请重试。';

  @override
  String get chatRename => '重命名';

  @override
  String get chatRenameTitle => '重命名对话';

  @override
  String get chatPin => '置顶';

  @override
  String get chatUnpin => '取消置顶';

  @override
  String get chatDelete => '删除';

  @override
  String get chatDeleteConfirmTitle => '删除此对话？';

  @override
  String get chatDeleteConfirmMessage => '此对话将从您在应用和网站中的对话列表中删除。此操作无法撤销。';

  @override
  String get chatPinned => '已置顶';

  @override
  String get chatYou => '您';

  @override
  String get chatDemoHint => '提示：在消息中加入「/fail」可模拟发送失败。';

  @override
  String get chatUploading => '上传中…';

  @override
  String get notFoundTitle => '页面不存在';

  @override
  String get notFoundMessage => '您访问的页面不存在。';

  @override
  String get notFoundGoHome => '返回首页';

  @override
  String get showcaseTitle => '基础组件展示';

  @override
  String get showcaseButtons => '按钮';

  @override
  String get showcasePrimary => '主要';

  @override
  String get showcaseSecondary => '次要';

  @override
  String get showcaseTextButton => '文本';

  @override
  String get showcaseInputs => '输入框';

  @override
  String get showcaseSampleInput => '示例输入';

  @override
  String get showcaseStates => '状态';

  @override
  String get showcaseFeedback => '反馈';

  @override
  String get showcaseShowDialog => '显示对话框';

  @override
  String get showcaseDialogMessage => '这是一个可复用的确认对话框。';

  @override
  String get showcaseShowSnackbar => '显示提示条';

  @override
  String get showcaseSnackbarMessage => '这是一个可复用的提示条。';

  @override
  String get showcaseSendNotification => '发送应用内通知';

  @override
  String get showcaseNotificationTitle => '来自通知中心的问候';

  @override
  String get showcaseNotificationBody => '应用内通知通过可替换的服务发送。';

  @override
  String get showcaseAttachments => '附件';

  @override
  String get mainNavHome => '首页';

  @override
  String get mainNavAskHr => '问 HR';

  @override
  String get mainNavMyWork => '我的工作';

  @override
  String get mainNavLearning => '学习';

  @override
  String get mainNavAccount => '账号';

  @override
  String get mainNavTimeline => '首页';

  @override
  String get mainNavChat => '问 HR';

  @override
  String get mainNavDocuments => '文档';

  @override
  String get mainNavProfile => '账号';

  @override
  String get headerSubtitle => '企业 AI 助手与员工工作空间';

  @override
  String get headerTokenQuota => 'Token 配额';

  @override
  String get headerQuotaUnavailable => '无法获取配额';

  @override
  String get headerQuotaExceeded => '已超出配额';

  @override
  String get headerQuotaWarning => '配额提醒';

  @override
  String get notificationTitle => '通知';

  @override
  String get notificationEmpty => '暂无通知';

  @override
  String get chatAiAgents => 'AI 与 HR 助手';

  @override
  String get chatOther => '其他';

  @override
  String get chatHumanBlockedHint => '人工在线聊天正在等待后端接口（BLOCKED）';

  @override
  String get chatStartNew => '开始新对话';

  @override
  String chatAgentHistory(String name) {
    return '$name 对话记录';
  }

  @override
  String get profileApprovals => '待审批';

  @override
  String get profileSettings => '设置';

  @override
  String get elearningCourses => '培训课程';

  @override
  String get elearningTests => '认证考试';

  @override
  String get myWorkTitle => '我的工作';

  @override
  String get myWorkChecklistTitle => '入职清单';

  @override
  String get myWorkCasesTitle => '我的案件与申请';

  @override
  String get myWorkApprovalsTitle => '待我审批';

  @override
  String get homeNewsSection => '最新公告';

  @override
  String get homeViewAllNews => '查看全部';

  @override
  String get homeUpcomingWork => '即将到期的工作';

  @override
  String get homeMyCourses => '我的课程';

  @override
  String get homePendingCase => 'HR 申请 #HR-1042';

  @override
  String get accountNews => '内部公告';

  @override
  String get askHrSearchPrompt => '输入问题… 例如：请假制度';

  @override
  String get askHrPolicyChip => '制度政策';

  @override
  String get askHrFormChip => '表单';

  @override
  String get askHrMyRequestsChip => '我的申请';

  @override
  String get homeAppBarTitle => 'GO AI · HR';

  @override
  String homeHeroGreeting(String name) {
    return '你好，$name 👋';
  }

  @override
  String get homePendingTasksLead => '本周您有 ';

  @override
  String homePendingTasksCount(int count) {
    return '$count 项任务';
  }

  @override
  String get homePendingTasksTail => ' 需要完成。';

  @override
  String get homeAskPolicyAction => '咨询制度';

  @override
  String get homeSendRequestAction => '提交申请';

  @override
  String get homeUpcomingWorkDetail => '完成入职清单 · 截止 10/10';

  @override
  String get homeNoUpcomingWork => '未来 30 天内没有到期的工作';

  @override
  String get homeUpcomingUnavailable => '无法加载您的日程';

  @override
  String homeUpcomingItem(String title, String when) {
    return '$title · $when';
  }

  @override
  String get homeMyCoursesDetail => '基础职业安全培训 · 剩余 12 分钟';

  @override
  String get homePendingCaseDetail => '等待 HR 回复 · 预计 09/10';

  @override
  String get homeQuotaTitle => 'AI Token 配额';

  @override
  String get homeNewsEmpty => '暂无公告。';

  @override
  String get homeNewsLoading => '正在加载公告…';

  @override
  String get askHrTitle => '您需要 HR 提供什么帮助？';

  @override
  String get askHrSend => '发送问题';

  @override
  String get askHrSampleQuestion => '我想查看请假制度。';

  @override
  String get askHrSampleAnswer => '我可以为您总结现行制度并提供已批准版本的链接。您想了解申请条件，还是如何提交申请？';

  @override
  String get askHrPrivacyNotice => '访问个人信息需要额外验证。投诉将建立保密案件，交由 HR 处理。';

  @override
  String get askHrViewPolicySources => '查看制度与来源';

  @override
  String get askHrAnswerTitle => '年假制度';

  @override
  String get askHrAnswerBody => '根据已批准的制度，您需按照公司流程向主管提交申请。具体条件取决于您的合同类型和剩余假期。';

  @override
  String get askHrSourceEyebrow => '已批准来源';

  @override
  String get askHrSourceTitle => '请假制度 • 版本 2.1';

  @override
  String get askHrSourceMeta => '生效日期：01/09/2026 · 负责部门：HR';

  @override
  String get askHrSourcePath => '公司文档库 → 您有权访问的版本 → 第 3.2 节';

  @override
  String get askHrSourceWarning => '找不到生效版本或信息有冲突？请转交 HR 核实，不要将此回答视为确定的制度。';

  @override
  String get askHrOpenSource => '打开原始文档';

  @override
  String get askHrCreateRequest => '创建 HR 申请';

  @override
  String get chatHubTitle => '聊天列表';

  @override
  String get profileChatList => '聊天列表';

  @override
  String get profileChatListSubtitle => 'AI 助手与对话记录（临时）';

  @override
  String get myWorkOnboardingEyebrow => '入职';

  @override
  String get myWorkOnboardingRole => '操作员 · A 工厂';

  @override
  String get myWorkOnboardingTemplate => '模板：岗位 + 地点 + 合同类型 · 已由 HR 批准';

  @override
  String myWorkOnboardingProgress(int done, int total) {
    return '已确认 $done/$total 项';
  }

  @override
  String get myWorkOnboardingShowRest => '查看其余项目';

  @override
  String get myWorkOnboardingCollapse => '收起';

  @override
  String get myWorkOnboardingEvidenceNote => '“完成清单”仅记录证明材料；正式档案由源系统在审核后更新。';

  @override
  String get myWorkCasesEmpty => '您还没有任何案件。';

  @override
  String myWorkCaseUpdated(String date) {
    return '更新于 $date';
  }

  @override
  String get myWorkStepReceived => '已受理';

  @override
  String get myWorkStepAssigned => '已分派';

  @override
  String get myWorkStepInProgress => '处理中';

  @override
  String get myWorkStepDone => '已完成';

  @override
  String myWorkCaseStatusBody(String date) {
    return '预计 $date 回复。如需更多信息，您将收到通知。';
  }

  @override
  String get myWorkCaseSecureTitle => '安全沟通';

  @override
  String get myWorkCaseSecureBody => '仅可在您自己的案件范围内查看和补充信息。';

  @override
  String get myWorkCaseAddDocs => '补充文件';

  @override
  String myWorkCaseDocsAdded(int count) {
    return '已向案件添加 $count 个文件';
  }

  @override
  String get myWorkCaseEscalationNote => '逾期 → A0 提醒负责人并将事项升级处理。';

  @override
  String get myWorkNewRequestButton => '新建 HR 申请';

  @override
  String get myWorkNewRequest => '提交 HR 申请';

  @override
  String get myWorkRequestTypeHint => '申请类型：个人信息确认';

  @override
  String get myWorkRequestTypePersonalInfo => '个人信息确认';

  @override
  String get myWorkRequestTypeLeave => '请假';

  @override
  String get myWorkRequestTypePolicy => '制度与福利';

  @override
  String get myWorkRequestTypeComplaint => '投诉（保密）';

  @override
  String get myWorkRequestTypeRequired => '请选择申请类型';

  @override
  String get myWorkRequestDescriptionHint => '简要描述您需要的帮助';

  @override
  String get myWorkRequestDescriptionRequired => '请描述您的申请';

  @override
  String get myWorkRequestAttachHint => '添加附件（如需要）';

  @override
  String myWorkRequestAttached(int count) {
    return '已添加 $count 个附件';
  }

  @override
  String get myWorkRequestPrivacyNotice => '请仅分享必要信息。敏感信息将转交具有相应权限的 HR 处理。';

  @override
  String get myWorkRequestSubmit => '提交申请';

  @override
  String get myWorkRequestAfterTitle => '提交之后';

  @override
  String get myWorkRequestAfterBody =>
      '您将获得案件编号（如 #HR-1042）· 预计回复时间：2 个工作日 · 处理人：指派的 HR。';

  @override
  String get myWorkRequestUrgentNote => '投诉/紧急事项：直接转交有权限的处理人，不经过直属主管。';

  @override
  String myWorkRequestSubmitted(String id) {
    return '申请已提交 · $id';
  }

  @override
  String get myWorkRoleEmployee => '员工';

  @override
  String get myWorkRoleHrAdmin => 'HR / 管理员';

  @override
  String get myWorkRoleDemoHint => '演示模式：选择角色以预览“工作”标签页';

  @override
  String get hrApprovalsEyebrow => '仅限授权审批人员';

  @override
  String get hrApprovalsTitle => '待我审批';

  @override
  String get hrApprovalProbationTitle => '试用期评估档案';

  @override
  String get hrApprovalProbationMeta => '#PB-238 · Nguyễn A · 截止 11/10';

  @override
  String get hrApprovalProbationBadge => '待审批';

  @override
  String get hrApprovalChecklistTitle => '有例外的清单';

  @override
  String get hrApprovalChecklistMeta => '#ON-320 · 缺少文件 · 截止 09/10';

  @override
  String get hrApprovalChecklistBadge => '核实';

  @override
  String get hrApprovalsScopeNote => '2 项 · 权限取决于岗位、部门、汇报关系和授权级别。';

  @override
  String get hrApprovalsOpenReview => '打开评估档案';

  @override
  String get hrApprovalsNoBulkNote => '试用期决定没有“全部批准”按钮。';

  @override
  String get hrProbationTitle => '试用期评估 #PB-238';

  @override
  String get hrProbationChecklist => '清单 12/13 项';

  @override
  String get hrProbationTraining => '必修培训：已确认';

  @override
  String get hrProbationManagerOpinion => '主管意见：需补充信息';

  @override
  String get hrProbationMissingEvidence => '证明材料不完整。请在做决定前要求补充信息。';

  @override
  String get hrProbationCommentHint => '审批人意见与依据';

  @override
  String get hrProbationRequestMore => '要求补充信息';

  @override
  String get hrProbationEscalate => '转交 HR/法务升级处理';

  @override
  String get hrProbationDecisionNote => '只有满足条件、用户具有相应审批权限并再次确认后，才会显示决定选项。';

  @override
  String hrQueueOverdue(int count) {
    return '逾期 $count';
  }

  @override
  String hrQueuePending(int count) {
    return '待审批 $count';
  }

  @override
  String get hrQueueCase1Title => '案件 #HR-1051';

  @override
  String get hrQueueCase1Meta => '投诉 · 保密转交 · 今天到期';

  @override
  String get hrQueueCase2Title => '案件 #ON-320';

  @override
  String get hrQueueCase2Meta => '缺少入职文件 · 负责人：HR A';

  @override
  String get hrQueueCase3Title => '案件 #TR-102';

  @override
  String get hrQueueCase3Meta => '课程尚无已批准的内容版本';

  @override
  String get hrQueueOpenWeb => '在网页端查看队列';

  @override
  String get hrQueueMobileNote => '移动端用于接收和跟进；转交路线配置、知识库审批和复杂调查请使用网页工作台。';

  @override
  String get learningMyTitle => '我的学习';

  @override
  String learningMandatorySummary(int count, String date) {
    return '$count 门必修课程 · 截止 $date';
  }

  @override
  String get learningNoMandatory => '没有待完成的必修课程。';

  @override
  String get learningMandatoryBadge => '必修';

  @override
  String get learningModuleBadge => 'A7';

  @override
  String learningVideoMinutes(int minutes) {
    return '视频 $minutes 分钟';
  }

  @override
  String learningDocMinutes(int minutes) {
    return '阅读 $minutes 分钟';
  }

  @override
  String learningQuizQuestions(int count) {
    return '测验：$count 题';
  }

  @override
  String learningDue(String date) {
    return '截止 $date';
  }

  @override
  String get learningNotStarted => '未开始';

  @override
  String get learningCompletedStatus => '已完成';

  @override
  String learningProgress(int percent) {
    return '进度 $percent%';
  }

  @override
  String get learningContinue => '继续学习';

  @override
  String get learningStart => '开始学习';

  @override
  String get learningPolicyNote => '及格分数、重考次数和证书有效期由内容负责人在发布前批准。';

  @override
  String get profileNewsTitle => '公司公告';

  @override
  String get profileNewsAll => '全部';

  @override
  String get profileNewsViewFull => '查看完整内容';

  @override
  String get profileNewsAckNote => '需要确认的公告会有“我已阅读”按钮。';

  @override
  String get profileNotificationsTitle => '我的通知';

  @override
  String get profileAccountSection => '账号';

  @override
  String profileEmployeeMeta(String id) {
    return '工号：$id · 查看允许的信息';
  }

  @override
  String get profileAccountActions => '语言 / 安全 / 退出登录';

  @override
  String get profilePushNote => '推送通知仅显示“有新动态”；请打开应用并验证身份后查看敏感数据。';

  @override
  String get profileLanguageSettings => '语言与设置';

  @override
  String get profileSecurity => '安全设置';

  @override
  String get commonComingSoon => '即将推出';

  @override
  String get commonPressBackAgainToExit => '再按一次返回键退出应用';

  @override
  String get notificationOpenHint => '点击查看详情';

  @override
  String get chatAttachMedia => '照片和视频';

  @override
  String get chatAttachFile => '文件';

  @override
  String get chatFileTypeTitle => '选择文件类型';

  @override
  String get chatFileTypePdf => 'PDF';

  @override
  String get chatFileTypeWord => 'Word';

  @override
  String get chatFileTypeExcel => 'Excel';

  @override
  String get chatFileTypePowerPoint => 'PowerPoint';

  @override
  String get chatFileTypeText => '文本（TXT、CSV）';

  @override
  String get chatFileTypeAll => '所有文件';

  @override
  String get chatOpenWith => '用其他应用打开';

  @override
  String get chatFileOpenFailed => '无法打开此文件';

  @override
  String get chatMediaUnavailable => '无法加载此内容';

  @override
  String get chatMicPermissionTitle => '需要麦克风权限';

  @override
  String get chatMicPermissionMessage => '请在设置中允许使用麦克风，以录制语音消息。';

  @override
  String get chatOpenSettings => '打开设置';

  @override
  String get chatMicPermissionDenied => '麦克风权限被拒绝';

  @override
  String chatRecording(String duration) {
    return '正在录音 · $duration';
  }

  @override
  String get chatVoiceRecord => '录音';

  @override
  String get chatStopRecording => '停止并发送';

  @override
  String get chatCancelRecording => '取消录音';

  @override
  String get chatPlay => '播放';

  @override
  String get chatPause => '暂停';

  @override
  String get chatVoiceNote => '语音消息';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get commonOk => '確定';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonRetry => '重試';

  @override
  String get commonClose => '關閉';

  @override
  String get commonLoading => '載入中…';

  @override
  String get commonEmpty => '暫無資料';

  @override
  String get commonErrorTitle => '發生錯誤';

  @override
  String get errorNetwork => '沒有網路連線，請檢查網路後再試一次。';

  @override
  String get errorTimeout => '要求逾時，請再試一次。';

  @override
  String get errorUnauthorized => '登入已逾期，請重新登入。';

  @override
  String get errorForbidden => '您沒有執行此操作的權限。';

  @override
  String get errorNotFound => '找不到要求的內容。';

  @override
  String get errorValidation => '部分資訊無效，請檢查後再試一次。';

  @override
  String get errorRateLimited => '要求過於頻繁，請稍後再試。';

  @override
  String get errorServer => '伺服器發生問題，請稍後再試。';

  @override
  String get errorStorage => '無法存取裝置儲存空間。';

  @override
  String get errorUnknown => '發生未預期的錯誤。';

  @override
  String get authSignInTitle => '歡迎回來';

  @override
  String get authSignInSubtitle => '請驗證您的帳號以查看您的資訊。';

  @override
  String get authHeaderTitle => 'GO AI HR';

  @override
  String get authSecurityBadge => '安全防護';

  @override
  String get authBrandEyebrow => 'GO AI · HR WORKFORCE';

  @override
  String get authEmployeeAccountLabel => '員工編號或公司帳號';

  @override
  String get authEmployeeAccountHint => '請輸入員工編號或公司帳號';

  @override
  String get authPhoneNumberLabel => '已登記的手機號碼';

  @override
  String get authPhoneNumberHint => '請輸入已登記的手機號碼';

  @override
  String get authSendVerificationCode => '傳送驗證碼';

  @override
  String get authSsoPrompt => '企業已啟用 SSO？請選擇「公司登入」。';

  @override
  String get authSsoButton => '公司登入';

  @override
  String get authFirstTimeTitle => '首次使用';

  @override
  String get authFirstTimeBody => 'HR 會提供啟用碼；驗證手機號碼後，在裝置上設定 PIN。';

  @override
  String get authSharedDeviceNotice => '使用共用手機？每次使用後請完全登出。';

  @override
  String get authAccountRequired => '請輸入員工編號或公司帳號';

  @override
  String get authPhoneRequired => '請輸入已登記的手機號碼';

  @override
  String get authSecurityDialogTitle => '企業安全';

  @override
  String get authSecurityDialogMessage => '您的工作階段與資料採用端對端加密保護，符合企業人力資源安全政策。';

  @override
  String get authEmailLabel => '電子郵件';

  @override
  String get authPasswordLabel => '密碼';

  @override
  String get authPasswordRequired => '請輸入密碼';

  @override
  String get authChangePassword => '變更密碼';

  @override
  String get authCurrentPassword => '目前密碼';

  @override
  String get authNewPassword => '新密碼';

  @override
  String get authConfirmPassword => '確認新密碼';

  @override
  String get authPasswordMismatch => '兩次輸入的密碼不一致';

  @override
  String get authPasswordChanged => '密碼已變更，請使用新密碼重新登入。';

  @override
  String get authPasswordRejected => '目前密碼錯誤，或新密碼不符合要求。';

  @override
  String get authSignInButton => '登入';

  @override
  String get authContinueAsGuest => '以訪客身分繼續';

  @override
  String get authEmailInvalid => '請輸入有效的電子郵件地址';

  @override
  String authPasswordTooShort(int min) {
    return '密碼至少需要 $min 個字元';
  }

  @override
  String get authDemoHint => '示範模式：輸入任意員工編號／手機號碼，或以訪客身分繼續。';

  @override
  String get authSignOut => '登出';

  @override
  String get authSignOutConfirmTitle => '要登出嗎？';

  @override
  String get authSignOutConfirmMessage => '您需要重新登入才能繼續使用。';

  @override
  String get authGuestName => '訪客';

  @override
  String get homeTitle => '首頁';

  @override
  String homeGreeting(String name) {
    return '您好，$name';
  }

  @override
  String get homeSubtitle => '專為員工打造的 GO AI Workforce。';

  @override
  String get homeChatTitle => '聊天示範';

  @override
  String get homeChatSubtitle => '使用模擬服務的通用聊天引擎';

  @override
  String get homeSettingsTitle => '設定';

  @override
  String get homeSettingsSubtitle => '語言與應用程式資訊';

  @override
  String get homeShowcaseTitle => '基礎元件展示';

  @override
  String get homeShowcaseSubtitle => '設計系統元件與狀態';

  @override
  String get homeProfileTitle => '個人資料';

  @override
  String get homeProfileSubtitle => '目前使用者與工作階段';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLanguageSystem => '依照系統';

  @override
  String get settingsAbout => '關於';

  @override
  String get settingsAppName => '應用程式名稱';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsEnvironment => '環境';

  @override
  String get settingsAccount => '帳號';

  @override
  String get profileTitle => '個人資料';

  @override
  String get profileUserId => '使用者 ID';

  @override
  String get profileEmail => '電子郵件';

  @override
  String get profileNoEmail => '未提供';

  @override
  String get profileGuestBadge => '訪客工作階段';

  @override
  String get chatTitle => '對話';

  @override
  String get chatEmptyConversations => '尚無對話';

  @override
  String get chatEmptyMessages => '尚無訊息，打聲招呼吧！';

  @override
  String get chatComposerHint => '輸入訊息';

  @override
  String get chatSend => '傳送';

  @override
  String get chatAttach => '附加檔案';

  @override
  String get chatStop => '停止產生';

  @override
  String get chatRegenerate => '重新產生';

  @override
  String get chatFailed => '傳送失敗，輕觸以重試。';

  @override
  String chatReplyingTo(String name) {
    return '正在回覆 $name';
  }

  @override
  String get chatReply => '回覆';

  @override
  String get chatCancelReply => '取消回覆';

  @override
  String chatTyping(String name) {
    return '$name 正在輸入…';
  }

  @override
  String get chatSources => '參考來源';

  @override
  String get chatTranscribing => '正在將語音轉為文字…';

  @override
  String get chatRateGood => '回答很好';

  @override
  String get chatRateBad => '回答不好';

  @override
  String get chatReadAloud => '朗讀';

  @override
  String get chatStopReading => '停止朗讀';

  @override
  String get chatActionFailed => '操作未完成，請再試一次。';

  @override
  String get chatRename => '重新命名';

  @override
  String get chatRenameTitle => '重新命名對話';

  @override
  String get chatPin => '釘選';

  @override
  String get chatUnpin => '取消釘選';

  @override
  String get chatDelete => '刪除';

  @override
  String get chatDeleteConfirmTitle => '要刪除此對話嗎？';

  @override
  String get chatDeleteConfirmMessage => '此對話將從您在應用程式與網站中的對話清單中刪除。此操作無法復原。';

  @override
  String get chatPinned => '已釘選';

  @override
  String get chatYou => '您';

  @override
  String get chatDemoHint => '提示：在訊息中加入「/fail」可模擬傳送失敗。';

  @override
  String get chatUploading => '上傳中…';

  @override
  String get notFoundTitle => '找不到頁面';

  @override
  String get notFoundMessage => '您要找的頁面不存在。';

  @override
  String get notFoundGoHome => '返回首頁';

  @override
  String get showcaseTitle => '基礎元件展示';

  @override
  String get showcaseButtons => '按鈕';

  @override
  String get showcasePrimary => '主要';

  @override
  String get showcaseSecondary => '次要';

  @override
  String get showcaseTextButton => '文字';

  @override
  String get showcaseInputs => '輸入欄位';

  @override
  String get showcaseSampleInput => '範例輸入';

  @override
  String get showcaseStates => '狀態';

  @override
  String get showcaseFeedback => '回饋';

  @override
  String get showcaseShowDialog => '顯示對話框';

  @override
  String get showcaseDialogMessage => '這是可重複使用的確認對話框。';

  @override
  String get showcaseShowSnackbar => '顯示提示列';

  @override
  String get showcaseSnackbarMessage => '這是可重複使用的提示列。';

  @override
  String get showcaseSendNotification => '傳送應用程式內通知';

  @override
  String get showcaseNotificationTitle => '來自通知中心的問候';

  @override
  String get showcaseNotificationBody => '應用程式內通知透過可替換的服務傳送。';

  @override
  String get showcaseAttachments => '附件';

  @override
  String get mainNavHome => '首頁';

  @override
  String get mainNavAskHr => '詢問 HR';

  @override
  String get mainNavMyWork => '我的工作';

  @override
  String get mainNavLearning => '學習';

  @override
  String get mainNavAccount => '帳號';

  @override
  String get mainNavTimeline => '首頁';

  @override
  String get mainNavChat => '詢問 HR';

  @override
  String get mainNavDocuments => '文件';

  @override
  String get mainNavProfile => '帳號';

  @override
  String get headerSubtitle => '企業 AI 助理與員工工作空間';

  @override
  String get headerTokenQuota => 'Token 配額';

  @override
  String get headerQuotaUnavailable => '無法取得配額';

  @override
  String get headerQuotaExceeded => '已超出配額';

  @override
  String get headerQuotaWarning => '配額提醒';

  @override
  String get notificationTitle => '通知';

  @override
  String get notificationEmpty => '尚無通知';

  @override
  String get chatAiAgents => 'AI 與 HR 助理';

  @override
  String get chatOther => '其他';

  @override
  String get chatHumanBlockedHint => '真人線上聊天正在等待後端介面（BLOCKED）';

  @override
  String get chatStartNew => '開始新對話';

  @override
  String chatAgentHistory(String name) {
    return '$name 對話紀錄';
  }

  @override
  String get profileApprovals => '待核准';

  @override
  String get profileSettings => '設定';

  @override
  String get elearningCourses => '培訓課程';

  @override
  String get elearningTests => '認證考試';

  @override
  String get myWorkTitle => '我的工作';

  @override
  String get myWorkChecklistTitle => '到職清單';

  @override
  String get myWorkCasesTitle => '我的案件與申請';

  @override
  String get myWorkApprovalsTitle => '待我核准';

  @override
  String get homeNewsSection => '最新公告';

  @override
  String get homeViewAllNews => '查看全部';

  @override
  String get homeUpcomingWork => '即將到期的工作';

  @override
  String get homeMyCourses => '我的課程';

  @override
  String get homePendingCase => 'HR 申請 #HR-1042';

  @override
  String get accountNews => '內部公告';

  @override
  String get askHrSearchPrompt => '輸入問題… 例如：請假制度';

  @override
  String get askHrPolicyChip => '制度政策';

  @override
  String get askHrFormChip => '表單';

  @override
  String get askHrMyRequestsChip => '我的申請';

  @override
  String get homeAppBarTitle => 'GO AI · HR';

  @override
  String homeHeroGreeting(String name) {
    return '你好，$name 👋';
  }

  @override
  String get homePendingTasksLead => '本週您有 ';

  @override
  String homePendingTasksCount(int count) {
    return '$count 項任務';
  }

  @override
  String get homePendingTasksTail => ' 需要完成。';

  @override
  String get homeAskPolicyAction => '詢問制度';

  @override
  String get homeSendRequestAction => '提交申請';

  @override
  String get homeUpcomingWorkDetail => '完成到職清單 · 截止 10/10';

  @override
  String get homeNoUpcomingWork => '未來 30 天內沒有到期的工作';

  @override
  String get homeUpcomingUnavailable => '無法載入您的行事曆';

  @override
  String homeUpcomingItem(String title, String when) {
    return '$title · $when';
  }

  @override
  String get homeMyCoursesDetail => '基礎職業安全訓練 · 剩餘 12 分鐘';

  @override
  String get homePendingCaseDetail => '等待 HR 回覆 · 預計 09/10';

  @override
  String get homeQuotaTitle => 'AI Token 配額';

  @override
  String get homeNewsEmpty => '尚無公告。';

  @override
  String get homeNewsLoading => '正在載入公告…';

  @override
  String get askHrTitle => '您需要 HR 提供什麼協助？';

  @override
  String get askHrSend => '傳送問題';

  @override
  String get askHrSampleQuestion => '我想查看請假制度。';

  @override
  String get askHrSampleAnswer => '我可以為您摘要現行制度並提供已核准版本的連結。您想了解申請條件，還是如何提交申請？';

  @override
  String get askHrPrivacyNotice => '存取個人資訊需進一步驗證身分。申訴將建立保密案件，交由 HR 處理。';

  @override
  String get askHrViewPolicySources => '查看制度與來源';

  @override
  String get askHrAnswerTitle => '年假制度';

  @override
  String get askHrAnswerBody => '根據已核准的制度，您需依照公司流程向主管提交申請。具體條件取決於您的合約類型與剩餘假期。';

  @override
  String get askHrSourceEyebrow => '已核准來源';

  @override
  String get askHrSourceTitle => '請假制度 • 版本 2.1';

  @override
  String get askHrSourceMeta => '生效日期：01/09/2026 · 負責單位：HR';

  @override
  String get askHrSourcePath => '公司文件庫 → 您有權存取的版本 → 第 3.2 節';

  @override
  String get askHrSourceWarning => '找不到生效版本或資訊有衝突？請轉交 HR 確認，勿將此回答視為確定的制度。';

  @override
  String get askHrOpenSource => '開啟原始文件';

  @override
  String get askHrCreateRequest => '建立 HR 申請';

  @override
  String get chatHubTitle => '聊天列表';

  @override
  String get profileChatList => '聊天列表';

  @override
  String get profileChatListSubtitle => 'AI 助理與對話紀錄（暫時）';

  @override
  String get myWorkOnboardingEyebrow => '到職';

  @override
  String get myWorkOnboardingRole => '作業員 · A 工廠';

  @override
  String get myWorkOnboardingTemplate => '範本：職位 + 地點 + 合約類型 · 已由 HR 核准';

  @override
  String myWorkOnboardingProgress(int done, int total) {
    return '已確認 $done/$total 項';
  }

  @override
  String get myWorkOnboardingShowRest => '查看其餘項目';

  @override
  String get myWorkOnboardingCollapse => '收合';

  @override
  String get myWorkOnboardingEvidenceNote => '「完成清單」僅記錄證明資料；正式檔案由來源系統在審核後更新。';

  @override
  String get myWorkCasesEmpty => '您還沒有任何案件。';

  @override
  String myWorkCaseUpdated(String date) {
    return '更新於 $date';
  }

  @override
  String get myWorkStepReceived => '已受理';

  @override
  String get myWorkStepAssigned => '已指派';

  @override
  String get myWorkStepInProgress => '處理中';

  @override
  String get myWorkStepDone => '已完成';

  @override
  String myWorkCaseStatusBody(String date) {
    return '預計 $date 回覆。如需更多資訊，您將收到通知。';
  }

  @override
  String get myWorkCaseSecureTitle => '安全溝通';

  @override
  String get myWorkCaseSecureBody => '僅可在您自己的案件範圍內查看和補充資訊。';

  @override
  String get myWorkCaseAddDocs => '補充文件';

  @override
  String myWorkCaseDocsAdded(int count) {
    return '已向案件新增 $count 個檔案';
  }

  @override
  String get myWorkCaseEscalationNote => '逾期 → A0 提醒負責人並將事項向上呈報處理。';

  @override
  String get myWorkNewRequestButton => '新增 HR 申請';

  @override
  String get myWorkNewRequest => '提交 HR 申請';

  @override
  String get myWorkRequestTypeHint => '申請類型：個人資訊確認';

  @override
  String get myWorkRequestTypePersonalInfo => '個人資訊確認';

  @override
  String get myWorkRequestTypeLeave => '請假';

  @override
  String get myWorkRequestTypePolicy => '制度與福利';

  @override
  String get myWorkRequestTypeComplaint => '申訴（保密）';

  @override
  String get myWorkRequestTypeRequired => '請選擇申請類型';

  @override
  String get myWorkRequestDescriptionHint => '簡要描述您需要的協助';

  @override
  String get myWorkRequestDescriptionRequired => '請描述您的申請';

  @override
  String get myWorkRequestAttachHint => '附加文件（如有需要）';

  @override
  String myWorkRequestAttached(int count) {
    return '已附加 $count 個檔案';
  }

  @override
  String get myWorkRequestPrivacyNotice => '請僅分享必要資訊。敏感資訊將交由具備相應權限的 HR 處理。';

  @override
  String get myWorkRequestSubmit => '提交申請';

  @override
  String get myWorkRequestAfterTitle => '提交之後';

  @override
  String get myWorkRequestAfterBody =>
      '您將取得案件編號（如 #HR-1042）· 預計回覆時間：2 個工作天 · 處理人：指派的 HR。';

  @override
  String get myWorkRequestUrgentNote => '申訴／緊急事項：直接轉交有權限的處理人，不經過直屬主管。';

  @override
  String myWorkRequestSubmitted(String id) {
    return '申請已提交 · $id';
  }

  @override
  String get myWorkRoleEmployee => '員工';

  @override
  String get myWorkRoleHrAdmin => 'HR / 管理員';

  @override
  String get myWorkRoleDemoHint => '示範模式：選擇角色以預覽「工作」分頁';

  @override
  String get hrApprovalsEyebrow => '僅限獲授權的核准人員';

  @override
  String get hrApprovalsTitle => '待我核准';

  @override
  String get hrApprovalProbationTitle => '試用期評估檔案';

  @override
  String get hrApprovalProbationMeta => '#PB-238 · Nguyễn A · 截止 11/10';

  @override
  String get hrApprovalProbationBadge => '待核准';

  @override
  String get hrApprovalChecklistTitle => '有例外的清單';

  @override
  String get hrApprovalChecklistMeta => '#ON-320 · 缺少文件 · 截止 09/10';

  @override
  String get hrApprovalChecklistBadge => '確認';

  @override
  String get hrApprovalsScopeNote => '2 項 · 權限依職位、單位、回報關係與授權層級決定。';

  @override
  String get hrApprovalsOpenReview => '開啟評估檔案';

  @override
  String get hrApprovalsNoBulkNote => '試用期決定沒有「全部核准」按鈕。';

  @override
  String get hrProbationTitle => '試用期評估 #PB-238';

  @override
  String get hrProbationChecklist => '清單 12/13 項';

  @override
  String get hrProbationTraining => '必修培訓：已確認';

  @override
  String get hrProbationManagerOpinion => '主管意見：需補充資訊';

  @override
  String get hrProbationMissingEvidence => '證明資料不完整。請在做決定前要求補充資訊。';

  @override
  String get hrProbationCommentHint => '審核人意見與依據';

  @override
  String get hrProbationRequestMore => '要求補充資訊';

  @override
  String get hrProbationEscalate => '呈交 HR／法務處理';

  @override
  String get hrProbationDecisionNote => '只有符合條件、使用者具備相應核准權限並再次確認後，才會顯示決定選項。';

  @override
  String hrQueueOverdue(int count) {
    return '逾期 $count';
  }

  @override
  String hrQueuePending(int count) {
    return '待核准 $count';
  }

  @override
  String get hrQueueCase1Title => '案件 #HR-1051';

  @override
  String get hrQueueCase1Meta => '申訴 · 保密轉交 · 今日截止';

  @override
  String get hrQueueCase2Title => '案件 #ON-320';

  @override
  String get hrQueueCase2Meta => '缺少到職文件 · 負責人：HR A';

  @override
  String get hrQueueCase3Title => '案件 #TR-102';

  @override
  String get hrQueueCase3Meta => '課程尚無已核准的內容版本';

  @override
  String get hrQueueOpenWeb => '在網頁版查看佇列';

  @override
  String get hrQueueMobileNote => '行動版用於接收與追蹤；處理流程設定、知識庫審核與複雜調查請使用網頁工作區。';

  @override
  String get learningMyTitle => '我的學習';

  @override
  String learningMandatorySummary(int count, String date) {
    return '$count 門必修課程 · 截止 $date';
  }

  @override
  String get learningNoMandatory => '沒有待完成的必修課程。';

  @override
  String get learningMandatoryBadge => '必修';

  @override
  String get learningModuleBadge => 'A7';

  @override
  String learningVideoMinutes(int minutes) {
    return '影片 $minutes 分鐘';
  }

  @override
  String learningDocMinutes(int minutes) {
    return '閱讀 $minutes 分鐘';
  }

  @override
  String learningQuizQuestions(int count) {
    return '測驗：$count 題';
  }

  @override
  String learningDue(String date) {
    return '截止 $date';
  }

  @override
  String get learningNotStarted => '未開始';

  @override
  String get learningCompletedStatus => '已完成';

  @override
  String learningProgress(int percent) {
    return '進度 $percent%';
  }

  @override
  String get learningContinue => '繼續學習';

  @override
  String get learningStart => '開始學習';

  @override
  String get learningPolicyNote => '及格分數、重考次數與證書有效期由內容負責人在發布前核准。';

  @override
  String get profileNewsTitle => '公司公告';

  @override
  String get profileNewsAll => '全部';

  @override
  String get profileNewsViewFull => '查看完整內容';

  @override
  String get profileNewsAckNote => '需要確認的公告會有「我已閱讀」按鈕。';

  @override
  String get profileNotificationsTitle => '我的通知';

  @override
  String get profileAccountSection => '帳號';

  @override
  String profileEmployeeMeta(String id) {
    return '員工編號：$id · 查看允許的資訊';
  }

  @override
  String get profileAccountActions => '語言 / 安全 / 登出';

  @override
  String get profilePushNote => '推播通知僅顯示「有新動態」；請開啟應用程式並驗證身分後查看敏感資料。';

  @override
  String get profileLanguageSettings => '語言與設定';

  @override
  String get profileSecurity => '安全設定';

  @override
  String get commonComingSoon => '即將推出';

  @override
  String get commonPressBackAgainToExit => '再按一次返回鍵即可退出應用程式';

  @override
  String get notificationOpenHint => '輕觸以查看詳情';

  @override
  String get chatAttachMedia => '相片和影片';

  @override
  String get chatAttachFile => '檔案';

  @override
  String get chatFileTypeTitle => '選擇檔案類型';

  @override
  String get chatFileTypePdf => 'PDF';

  @override
  String get chatFileTypeWord => 'Word';

  @override
  String get chatFileTypeExcel => 'Excel';

  @override
  String get chatFileTypePowerPoint => 'PowerPoint';

  @override
  String get chatFileTypeText => '文字（TXT、CSV）';

  @override
  String get chatFileTypeAll => '所有檔案';

  @override
  String get chatOpenWith => '用其他應用程式開啟';

  @override
  String get chatFileOpenFailed => '無法開啟此檔案';

  @override
  String get chatMediaUnavailable => '無法載入此內容';

  @override
  String get chatMicPermissionTitle => '需要麥克風權限';

  @override
  String get chatMicPermissionMessage => '請在設定中允許使用麥克風，以錄製語音訊息。';

  @override
  String get chatOpenSettings => '開啟設定';

  @override
  String get chatMicPermissionDenied => '麥克風權限遭拒';

  @override
  String chatRecording(String duration) {
    return '正在錄音 · $duration';
  }

  @override
  String get chatVoiceRecord => '錄音';

  @override
  String get chatStopRecording => '停止並傳送';

  @override
  String get chatCancelRecording => '取消錄音';

  @override
  String get chatPlay => '播放';

  @override
  String get chatPause => '暫停';

  @override
  String get chatVoiceNote => '語音訊息';
}
