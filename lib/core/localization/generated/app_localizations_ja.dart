// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonLoading => '読み込み中…';

  @override
  String get commonEmpty => 'データがありません';

  @override
  String get commonErrorTitle => 'エラーが発生しました';

  @override
  String get errorNetwork => 'インターネットに接続されていません。ネットワークを確認して、もう一度お試しください。';

  @override
  String get errorTimeout => 'リクエストがタイムアウトしました。もう一度お試しください。';

  @override
  String get errorUnauthorized => 'セッションの有効期限が切れました。もう一度ログインしてください。';

  @override
  String get errorForbidden => 'この操作を行う権限がありません。';

  @override
  String get errorNotFound => '要求された項目が見つかりません。';

  @override
  String get errorValidation => '一部の情報が正しくありません。確認して、もう一度お試しください。';

  @override
  String get errorRateLimited => 'リクエストが多すぎます。しばらく待ってから、もう一度お試しください。';

  @override
  String get errorServer => 'サーバーで問題が発生しました。しばらくしてから、もう一度お試しください。';

  @override
  String get errorStorage => '端末のストレージにアクセスできません。';

  @override
  String get errorUnknown => '予期しないエラーが発生しました。';

  @override
  String get authSignInTitle => 'おかえりなさい';

  @override
  String get authSignInSubtitle => '情報を表示するには、アカウントを確認してください。';

  @override
  String get authHeaderTitle => 'GO AI HR';

  @override
  String get authSecurityBadge => 'セキュリティ';

  @override
  String get authBrandEyebrow => 'GO AI · HR WORKFORCE';

  @override
  String get authEmployeeAccountLabel => '社員番号または会社アカウント';

  @override
  String get authEmployeeAccountHint => '社員番号または会社アカウントを入力';

  @override
  String get authPhoneNumberLabel => '登録済みの電話番号';

  @override
  String get authPhoneNumberHint => '登録済みの電話番号を入力';

  @override
  String get authSendVerificationCode => '認証コードを送信';

  @override
  String get authSsoPrompt => '企業で SSO をご利用ですか？「会社アカウントでログイン」を選択してください。';

  @override
  String get authSsoButton => '会社アカウントでログイン';

  @override
  String get authFirstTimeTitle => '初めてご利用の方';

  @override
  String get authFirstTimeBody =>
      'HR が有効化コードを発行します。電話番号を確認してから、端末で PIN を設定してください。';

  @override
  String get authSharedDeviceNotice => '共用の端末をお使いですか？ご利用のたびに完全にログアウトしてください。';

  @override
  String get authAccountRequired => '社員番号または会社アカウントを入力してください';

  @override
  String get authPhoneRequired => '登録済みの電話番号を入力してください';

  @override
  String get authSecurityDialogTitle => 'エンタープライズセキュリティ';

  @override
  String get authSecurityDialogMessage =>
      'セッションとデータは、企業の人事情報セキュリティポリシーに準拠したエンドツーエンド暗号化で保護されています。';

  @override
  String get authEmailLabel => 'メールアドレス';

  @override
  String get authPasswordLabel => 'パスワード';

  @override
  String get authPasswordRequired => 'パスワードを入力してください';

  @override
  String get authChangePassword => 'パスワードを変更';

  @override
  String get authCurrentPassword => '現在のパスワード';

  @override
  String get authNewPassword => '新しいパスワード';

  @override
  String get authConfirmPassword => '新しいパスワード（確認）';

  @override
  String get authPasswordMismatch => 'パスワードが一致しません';

  @override
  String get authPasswordChanged => 'パスワードを変更しました。新しいパスワードでログインし直してください。';

  @override
  String get authPasswordRejected => '現在のパスワードが正しくないか、新しいパスワードが要件を満たしていません。';

  @override
  String get authSignInButton => 'ログイン';

  @override
  String get authContinueAsGuest => 'ゲストとして続行';

  @override
  String get authEmailInvalid => '有効なメールアドレスを入力してください';

  @override
  String authPasswordTooShort(int min) {
    return 'パスワードは $min 文字以上で入力してください';
  }

  @override
  String get authDemoHint => 'デモモード：任意の社員番号/電話番号を入力するか、ゲストとして続行してください。';

  @override
  String get authSignOut => 'ログアウト';

  @override
  String get authSignOutConfirmTitle => 'ログアウトしますか？';

  @override
  String get authSignOutConfirmMessage => '続けるには、もう一度ログインする必要があります。';

  @override
  String get authGuestName => 'ゲスト';

  @override
  String get homeTitle => 'ホーム';

  @override
  String homeGreeting(String name) {
    return 'こんにちは、$nameさん';
  }

  @override
  String get homeSubtitle => '従業員向けの GO AI Workforce。';

  @override
  String get homeChatTitle => 'チャットデモ';

  @override
  String get homeChatSubtitle => 'モックプロバイダーを使用した汎用チャットエンジン';

  @override
  String get homeSettingsTitle => '設定';

  @override
  String get homeSettingsSubtitle => '言語とアプリ情報';

  @override
  String get homeShowcaseTitle => '基盤コンポーネント一覧';

  @override
  String get homeShowcaseSubtitle => 'デザインシステムのコンポーネントと状態';

  @override
  String get homeProfileTitle => 'プロフィール';

  @override
  String get homeProfileSubtitle => '現在のユーザーとセッション';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageSystem => 'システムの設定に従う';

  @override
  String get settingsAbout => 'このアプリについて';

  @override
  String get settingsAppName => 'アプリ名';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsEnvironment => '環境';

  @override
  String get settingsAccount => 'アカウント';

  @override
  String get profileTitle => 'プロフィール';

  @override
  String get profileUserId => 'ユーザー ID';

  @override
  String get profileEmail => 'メールアドレス';

  @override
  String get profileNoEmail => '未提供';

  @override
  String get profileGuestBadge => 'ゲストセッション';

  @override
  String get chatTitle => '会話';

  @override
  String get chatEmptyConversations => '会話はまだありません';

  @override
  String get chatEmptyMessages => 'メッセージはまだありません。挨拶してみましょう！';

  @override
  String get chatComposerHint => 'メッセージを入力';

  @override
  String get chatSend => '送信';

  @override
  String get chatAttach => 'ファイルを添付';

  @override
  String get chatStop => '生成を停止';

  @override
  String get chatRegenerate => '再生成';

  @override
  String get chatFailed => '送信できませんでした。タップして再試行してください。';

  @override
  String chatReplyingTo(String name) {
    return '$nameさんに返信中';
  }

  @override
  String get chatReply => '返信';

  @override
  String get chatCancelReply => '返信をキャンセル';

  @override
  String chatTyping(String name) {
    return '$nameさんが入力中…';
  }

  @override
  String get chatSources => '参照元';

  @override
  String get chatTranscribing => '音声をテキストに変換しています…';

  @override
  String get chatRateGood => '良い回答';

  @override
  String get chatRateBad => '良くない回答';

  @override
  String get chatReadAloud => '読み上げ';

  @override
  String get chatStopReading => '読み上げを停止';

  @override
  String get chatActionFailed => '操作を完了できませんでした。もう一度お試しください。';

  @override
  String get chatRename => '名前を変更';

  @override
  String get chatRenameTitle => '会話の名前を変更';

  @override
  String get chatPin => 'ピン留め';

  @override
  String get chatUnpin => 'ピン留めを解除';

  @override
  String get chatDelete => '削除';

  @override
  String get chatDeleteConfirmTitle => 'この会話を削除しますか？';

  @override
  String get chatDeleteConfirmMessage =>
      'この会話は、アプリとウェブサイトの両方で、ご自身の会話一覧から削除されます。この操作は元に戻せません。';

  @override
  String get chatPinned => 'ピン留め済み';

  @override
  String get chatYou => 'あなた';

  @override
  String get chatDemoHint => 'ヒント：メッセージに「/fail」を含めると、送信失敗をシミュレートできます。';

  @override
  String get chatUploading => 'アップロード中…';

  @override
  String get notFoundTitle => 'ページが見つかりません';

  @override
  String get notFoundMessage => 'お探しのページは存在しません。';

  @override
  String get notFoundGoHome => 'ホームへ戻る';

  @override
  String get showcaseTitle => '基盤コンポーネント一覧';

  @override
  String get showcaseButtons => 'ボタン';

  @override
  String get showcasePrimary => 'プライマリ';

  @override
  String get showcaseSecondary => 'セカンダリ';

  @override
  String get showcaseTextButton => 'テキスト';

  @override
  String get showcaseInputs => '入力欄';

  @override
  String get showcaseSampleInput => '入力例';

  @override
  String get showcaseStates => '状態';

  @override
  String get showcaseFeedback => 'フィードバック';

  @override
  String get showcaseShowDialog => 'ダイアログを表示';

  @override
  String get showcaseDialogMessage => '再利用できる確認ダイアログです。';

  @override
  String get showcaseShowSnackbar => 'スナックバーを表示';

  @override
  String get showcaseSnackbarMessage => '再利用できるスナックバーです。';

  @override
  String get showcaseSendNotification => 'アプリ内通知を送信';

  @override
  String get showcaseNotificationTitle => '通知センターからのお知らせ';

  @override
  String get showcaseNotificationBody => 'アプリ内通知は、差し替え可能なサービスを通じて配信されます。';

  @override
  String get showcaseAttachments => '添付ファイル';

  @override
  String get mainNavHome => 'ホーム';

  @override
  String get mainNavAskHr => 'HRに質問';

  @override
  String get mainNavMyWork => 'マイワーク';

  @override
  String get mainNavLearning => '学習';

  @override
  String get mainNavAccount => 'アカウント';

  @override
  String get mainNavTimeline => 'ホーム';

  @override
  String get mainNavChat => 'HRに質問';

  @override
  String get mainNavDocuments => 'ドキュメント';

  @override
  String get mainNavProfile => 'アカウント';

  @override
  String get headerSubtitle => '企業向け AI アシスタント＆従業員ワークスペース';

  @override
  String get headerTokenQuota => 'トークン上限';

  @override
  String get headerQuotaUnavailable => '上限を取得できません';

  @override
  String get headerQuotaExceeded => '上限を超えました';

  @override
  String get headerQuotaWarning => '上限に関する警告';

  @override
  String get notificationTitle => '通知';

  @override
  String get notificationEmpty => '通知はまだありません';

  @override
  String get chatAiAgents => 'AI・HR エージェント';

  @override
  String get chatOther => 'その他';

  @override
  String get chatHumanBlockedHint => '担当者とのチャットはバックエンドの仕様待ちです（BLOCKED）';

  @override
  String get chatStartNew => '新しい会話を開始';

  @override
  String chatAgentHistory(String name) {
    return '$name の会話履歴';
  }

  @override
  String get profileApprovals => '承認待ち';

  @override
  String get profileSettings => '設定';

  @override
  String get elearningCourses => '研修コース';

  @override
  String get elearningTests => '認定テスト';

  @override
  String get myWorkTitle => 'マイワーク';

  @override
  String get myWorkChecklistTitle => 'オンボーディングチェックリスト';

  @override
  String get myWorkCasesTitle => 'マイ案件・申請';

  @override
  String get myWorkApprovalsTitle => '自分の承認待ち';

  @override
  String get homeNewsSection => '最新のお知らせ';

  @override
  String get homeViewAllNews => 'すべて表示';

  @override
  String get homeUpcomingWork => '期限が近いタスク';

  @override
  String get homeMyCourses => 'マイコース';

  @override
  String get homePendingCase => 'HR 申請 #HR-1042';

  @override
  String get accountNews => '社内報・お知らせ';

  @override
  String get askHrSearchPrompt => '質問を入力… 例：休暇規定';

  @override
  String get askHrPolicyChip => '規定';

  @override
  String get askHrFormChip => '申請書式';

  @override
  String get askHrMyRequestsChip => '自分の申請';

  @override
  String get homeAppBarTitle => 'GO AI · HR';

  @override
  String homeHeroGreeting(String name) {
    return 'こんにちは、$nameさん 👋';
  }

  @override
  String get homePendingTasksLead => '今週完了が必要なタスクは ';

  @override
  String homePendingTasksCount(int count) {
    return '$count 件';
  }

  @override
  String get homePendingTasksTail => ' です。';

  @override
  String get homeAskPolicyAction => '規定を質問';

  @override
  String get homeSendRequestAction => '申請を送信';

  @override
  String get homeUpcomingWorkDetail => 'オンボーディングチェックリストを完了 · 期限 10/10';

  @override
  String get homeNoUpcomingWork => '今後 30 日以内に期限のタスクはありません';

  @override
  String get homeUpcomingUnavailable => 'カレンダーを読み込めませんでした';

  @override
  String homeUpcomingItem(String title, String when) {
    return '$title · $when';
  }

  @override
  String get homeMyCoursesDetail => '職場の安全の基礎 · 残り 12 分';

  @override
  String get homePendingCaseDetail => 'HR の回答待ち · 予定 09/10';

  @override
  String get homeQuotaTitle => 'AI トークン上限';

  @override
  String get homeNewsEmpty => 'お知らせはまだありません。';

  @override
  String get homeNewsLoading => 'お知らせを読み込み中…';

  @override
  String get askHrTitle => 'HR にどのようなサポートをご希望ですか？';

  @override
  String get askHrSend => '質問を送信';

  @override
  String get askHrSampleQuestion => '休暇規定を確認したいです。';

  @override
  String get askHrSampleAnswer =>
      '現行の規定を要約し、承認済みの版へのリンクをご案内できます。取得条件と申請方法のどちらを知りたいですか？';

  @override
  String get askHrPrivacyNotice =>
      '個人情報の閲覧には追加の本人確認が必要です。苦情・相談は機密扱いの案件として登録され、HR が対応します。';

  @override
  String get askHrViewPolicySources => '規定と参照元を見る';

  @override
  String get askHrAnswerTitle => '年次休暇規定';

  @override
  String get askHrAnswerBody =>
      '承認済みの規定に基づき、会社の手順に従って上長に申請してください。具体的な取得条件は、契約形態と残りの休暇日数によって異なります。';

  @override
  String get askHrSourceEyebrow => '承認済みの参照元';

  @override
  String get askHrSourceTitle => '休暇規定 • 第 2.1 版';

  @override
  String get askHrSourceMeta => '施行日：01/09/2026 · 管理部門：HR';

  @override
  String get askHrSourcePath => '社内ドキュメントライブラリ → 閲覧可能な版 → 3.2 項';

  @override
  String get askHrSourceWarning =>
      '有効な版が見つからない、または情報が矛盾していますか？HR に確認を依頼し、この回答を確定した規定として扱わないでください。';

  @override
  String get askHrOpenSource => '元のドキュメントを開く';

  @override
  String get askHrCreateRequest => 'HR 申請を作成';

  @override
  String get chatHubTitle => 'チャット一覧';

  @override
  String get profileChatList => 'チャット一覧';

  @override
  String get profileChatListSubtitle => 'AI アシスタントと会話履歴（暫定）';

  @override
  String get myWorkOnboardingEyebrow => 'オンボーディング';

  @override
  String get myWorkOnboardingRole => 'オペレーター · A 工場';

  @override
  String get myWorkOnboardingTemplate => 'テンプレート：職種 + 勤務地 + 契約形態 · HR 承認済み';

  @override
  String myWorkOnboardingProgress(int done, int total) {
    return '$done/$total 項目を確認済み';
  }

  @override
  String get myWorkOnboardingShowRest => '残りの項目を表示';

  @override
  String get myWorkOnboardingCollapse => '折りたたむ';

  @override
  String get myWorkOnboardingEvidenceNote =>
      '「チェックリスト完了」は証跡の記録です。正式な記録は、確認後に元のシステムで更新されます。';

  @override
  String get myWorkCasesEmpty => '案件はまだありません。';

  @override
  String myWorkCaseUpdated(String date) {
    return '$date に更新';
  }

  @override
  String get myWorkStepReceived => '受付済み';

  @override
  String get myWorkStepAssigned => '担当割り当て済み';

  @override
  String get myWorkStepInProgress => '対応中';

  @override
  String get myWorkStepDone => '完了';

  @override
  String myWorkCaseStatusBody(String date) {
    return '$date に回答予定です。追加情報が必要な場合はお知らせします。';
  }

  @override
  String get myWorkCaseSecureTitle => 'セキュアなやり取り';

  @override
  String get myWorkCaseSecureBody => 'ご自身の案件の範囲内でのみ、閲覧と追加ができます。';

  @override
  String get myWorkCaseAddDocs => '書類を追加';

  @override
  String myWorkCaseDocsAdded(int count) {
    return '案件に $count 件のファイルを添付しました';
  }

  @override
  String get myWorkCaseEscalationNote =>
      '期限超過 → A0 が担当者にリマインドし、上位レベルでの対応を依頼します。';

  @override
  String get myWorkNewRequestButton => '新しい HR 申請';

  @override
  String get myWorkNewRequest => 'HR 申請を送信';

  @override
  String get myWorkRequestTypeHint => '申請の種類：個人情報の確認';

  @override
  String get myWorkRequestTypePersonalInfo => '個人情報の確認';

  @override
  String get myWorkRequestTypeLeave => '休暇';

  @override
  String get myWorkRequestTypePolicy => '規定・福利厚生';

  @override
  String get myWorkRequestTypeComplaint => '苦情（機密）';

  @override
  String get myWorkRequestTypeRequired => '申請の種類を選択してください';

  @override
  String get myWorkRequestDescriptionHint => '必要なサポートを簡単に記入してください';

  @override
  String get myWorkRequestDescriptionRequired => '申請内容を記入してください';

  @override
  String get myWorkRequestAttachHint => '書類を添付（必要な場合）';

  @override
  String myWorkRequestAttached(int count) {
    return '$count 件のファイルを添付済み';
  }

  @override
  String get myWorkRequestPrivacyNotice =>
      '必要な内容のみ共有してください。機密性の高い情報は、対応権限を持つ HR 担当者に回付されます。';

  @override
  String get myWorkRequestSubmit => '申請を送信';

  @override
  String get myWorkRequestAfterTitle => '送信後の流れ';

  @override
  String get myWorkRequestAfterBody =>
      '案件番号（例：#HR-1042）が発行されます · 回答予定：2 営業日 · 担当：割り当てられた HR。';

  @override
  String get myWorkRequestUrgentNote => '苦情・緊急案件：直属の上長を経由せず、権限のある担当者へ直接回付されます。';

  @override
  String myWorkRequestSubmitted(String id) {
    return '申請を送信しました · $id';
  }

  @override
  String get myWorkRoleEmployee => '従業員';

  @override
  String get myWorkRoleHrAdmin => 'HR / 管理者';

  @override
  String get myWorkRoleDemoHint => 'デモモード：役割を選んでワークタブをプレビュー';

  @override
  String get hrApprovalsEyebrow => '承認権限を持つ方のみ';

  @override
  String get hrApprovalsTitle => '自分の承認待ち';

  @override
  String get hrApprovalProbationTitle => '試用期間の評価ファイル';

  @override
  String get hrApprovalProbationMeta => '#PB-238 · Nguyễn A · 期限 11/10';

  @override
  String get hrApprovalProbationBadge => '承認待ち';

  @override
  String get hrApprovalChecklistTitle => '例外事項のあるチェックリスト';

  @override
  String get hrApprovalChecklistMeta => '#ON-320 · 書類不足 · 期限 09/10';

  @override
  String get hrApprovalChecklistBadge => '要確認';

  @override
  String get hrApprovalsScopeNote => '2 件 · 権限は職位、所属、報告系統、権限レベルによって決まります。';

  @override
  String get hrApprovalsOpenReview => '評価ファイルを開く';

  @override
  String get hrApprovalsNoBulkNote => '試用期間の判断には「すべて承認」はありません。';

  @override
  String get hrProbationTitle => '試用期間の評価 #PB-238';

  @override
  String get hrProbationChecklist => 'チェックリスト：12/13 項目';

  @override
  String get hrProbationTraining => '必須研修：確認済み';

  @override
  String get hrProbationManagerOpinion => '上長の意見：追加情報が必要';

  @override
  String get hrProbationMissingEvidence => '証跡が不足しています。判断の前に追加情報を依頼してください。';

  @override
  String get hrProbationCommentHint => '承認者のコメントと根拠';

  @override
  String get hrProbationRequestMore => '追加情報を依頼';

  @override
  String get hrProbationEscalate => 'HR／法務に対応を依頼';

  @override
  String get hrProbationDecisionNote =>
      '条件を満たし、ユーザーに適切な承認権限があり、再確認が完了した場合にのみ、判断の選択肢が表示されます。';

  @override
  String hrQueueOverdue(int count) {
    return '期限超過 $count';
  }

  @override
  String hrQueuePending(int count) {
    return '承認待ち $count';
  }

  @override
  String get hrQueueCase1Title => '案件 #HR-1051';

  @override
  String get hrQueueCase1Meta => '苦情 · 機密ルート · 本日期限';

  @override
  String get hrQueueCase2Title => '案件 #ON-320';

  @override
  String get hrQueueCase2Meta => '入社書類の不足 · 担当：HR A';

  @override
  String get hrQueueCase3Title => '案件 #TR-102';

  @override
  String get hrQueueCase3Meta => 'コースに承認済みのコンテンツ版がありません';

  @override
  String get hrQueueOpenWeb => 'ウェブでキューを表示';

  @override
  String get hrQueueMobileNote =>
      'モバイルアプリでは受付と進捗確認を行います。振り分け設定、ナレッジベースの承認、複雑な調査はウェブワークスペースで行ってください。';

  @override
  String get learningMyTitle => '自分の学習';

  @override
  String learningMandatorySummary(int count, String date) {
    return '必須コース $count 件 · 期限 $date';
  }

  @override
  String get learningNoMandatory => '未完了の必須コースはありません。';

  @override
  String get learningMandatoryBadge => '必須';

  @override
  String get learningModuleBadge => 'A7';

  @override
  String learningVideoMinutes(int minutes) {
    return '動画 $minutes 分';
  }

  @override
  String learningDocMinutes(int minutes) {
    return '資料 $minutes 分';
  }

  @override
  String learningQuizQuestions(int count) {
    return 'テスト：$count 問';
  }

  @override
  String learningDue(String date) {
    return '期限 $date';
  }

  @override
  String get learningNotStarted => '未開始';

  @override
  String get learningCompletedStatus => '完了';

  @override
  String learningProgress(int percent) {
    return '進捗 $percent%';
  }

  @override
  String get learningContinue => '学習を続ける';

  @override
  String get learningStart => '学習を始める';

  @override
  String get learningPolicyNote => '合格点、再受験の回数制限、修了証の有効期間は、公開前にコンテンツ責任者が承認します。';

  @override
  String get profileNewsTitle => '社内報';

  @override
  String get profileNewsAll => 'すべて';

  @override
  String get profileNewsViewFull => '全文を表示';

  @override
  String get profileNewsAckNote => '確認が必要なお知らせには「既読にする」ボタンがあります。';

  @override
  String get profileNotificationsTitle => '自分への通知';

  @override
  String get profileAccountSection => 'アカウント';

  @override
  String profileEmployeeMeta(String id) {
    return '社員番号：$id · 閲覧可能な情報を表示';
  }

  @override
  String get profileAccountActions => '言語 / セキュリティ / ログアウト';

  @override
  String get profilePushNote =>
      'プッシュ通知には「新しいお知らせがあります」とだけ表示されます。機密データを確認するには、アプリを開いて認証してください。';

  @override
  String get profileLanguageSettings => '言語と設定';

  @override
  String get profileSecurity => 'セキュリティ';

  @override
  String get commonComingSoon => '近日公開';

  @override
  String get commonPressBackAgainToExit => '戻るボタンをもう一度押すとアプリを終了します';

  @override
  String get notificationOpenHint => 'タップして詳細を表示';

  @override
  String get chatAttachMedia => '写真と動画';

  @override
  String get chatAttachFile => 'ファイル';

  @override
  String get chatFileTypeTitle => 'ファイルの種類を選択';

  @override
  String get chatFileTypePdf => 'PDF';

  @override
  String get chatFileTypeWord => 'Word';

  @override
  String get chatFileTypeExcel => 'Excel';

  @override
  String get chatFileTypePowerPoint => 'PowerPoint';

  @override
  String get chatFileTypeText => 'テキスト（TXT、CSV）';

  @override
  String get chatFileTypeAll => 'すべてのファイル';

  @override
  String get chatOpenWith => '他のアプリで開く';

  @override
  String get chatFileOpenFailed => 'このファイルを開けませんでした';

  @override
  String get chatMediaUnavailable => 'このコンテンツを読み込めませんでした';

  @override
  String get chatMicPermissionTitle => 'マイクへのアクセスが必要です';

  @override
  String get chatMicPermissionMessage =>
      '音声メッセージを録音するには、設定でマイクへのアクセスを許可してください。';

  @override
  String get chatOpenSettings => '設定を開く';

  @override
  String get chatMicPermissionDenied => 'マイクへのアクセスが拒否されました';

  @override
  String chatRecording(String duration) {
    return '録音中 · $duration';
  }

  @override
  String get chatVoiceRecord => '音声を録音';

  @override
  String get chatStopRecording => '停止して送信';

  @override
  String get chatCancelRecording => '録音をキャンセル';

  @override
  String get chatPlay => '再生';

  @override
  String get chatPause => '一時停止';

  @override
  String get chatVoiceNote => '音声メッセージ';
}
