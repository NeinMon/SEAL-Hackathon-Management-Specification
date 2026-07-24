// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get sessionBootstrapMessage => 'サインインセッションを復元しています...';

  @override
  String get statusRegistrationClosing => '登録締切間近';

  @override
  String get statusJudging => '審査中';

  @override
  String get allEventsFilter => 'すべてのイベント';

  @override
  String get myTeamReadyBadge => 'チーム参加済み';

  @override
  String get myTeamPendingBadge => 'チーム未参加';

  @override
  String get weightedScoreHint => '表示スコアはシステムに保存された加重ルーブリック平均です。';

  @override
  String get scorePublishedWithHintSnackBar =>
      'スコアを公開しました。参加者は受信トレイで通知を受け取ります。';

  @override
  String get demoResetTitle => 'デモデータをリセット';

  @override
  String get demoResetDescription =>
      '現在の環境のすべてのユーザー、イベント、チーム、提出、スコアを削除します。ローカルデモのみ。';

  @override
  String get demoResetConfirmLabel => '確認のため RESET と入力';

  @override
  String get demoResetSuccess => 'デモデータをリセットしました。';

  @override
  String get eventSupportHotline => 'チャットまたは通知で運営に連絡';

  @override
  String get demoOnboardingTitle => 'クイックデモガイド';

  @override
  String get demoOnboardingStartButton => 'デモを開始';

  @override
  String get demoOnboardingParticipantTitle => '参加者';

  @override
  String get demoOnboardingParticipantBody =>
      'イベント → チーム → 提出。環境がシードされている場合はデモアカウントを使用。';

  @override
  String get demoOnboardingJudgeTitle => '審査員';

  @override
  String get demoOnboardingJudgeBody =>
      '採点タブ → 提出を選択 → 基準とフィードバックを入力 → スコアを提出。';

  @override
  String get demoOnboardingAlertsTitle => '通知';

  @override
  String get demoOnboardingAlertsBody => '右上のベルアイコン。スコア通知をタップして詳細を表示。';

  @override
  String get appName => 'SEAL Hackathon';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get saveButton => '保存';

  @override
  String get deleteButton => '削除';

  @override
  String get sendButton => '送信';

  @override
  String get doneButton => '完了';

  @override
  String get resetButton => 'リセット';

  @override
  String get updateButton => '更新';

  @override
  String get retryButton => '再試行';

  @override
  String get stayButton => '留まる';

  @override
  String get confirmButton => '確認';

  @override
  String get confirmDelete => '本当に削除しますか？';

  @override
  String get detailsButton => '詳細';

  @override
  String get editButton => '編集';

  @override
  String get inviteButton => '招待';

  @override
  String get allFilter => 'すべて';

  @override
  String get sortLabel => '並び替え';

  @override
  String get unknownLabel => '不明';

  @override
  String get leaderBadge => 'リーダー';

  @override
  String get meLabel => '自分';

  @override
  String get statusActive => '開催中';

  @override
  String get statusUpcoming => '開催予定';

  @override
  String get statusClosed => '終了';

  @override
  String get filterRegistrationOpen => '登録受付中';

  @override
  String get networkOfflineMessage => 'ネットワークに接続されていません。接続を確認して再試行してください。';

  @override
  String get networkError => 'サーバーに接続できません';

  @override
  String get unknownError => 'エラーが発生しました';

  @override
  String get accessDeniedTitle => 'アクセス拒否';

  @override
  String get accessDeniedSubtitle => 'この機能はお使いのロールでは利用できません。';

  @override
  String get accessDeniedDefaultMessage => '適切なアカウントでサインインしてください。';

  @override
  String get backToEventsButton => 'イベントに戻る';

  @override
  String get loginRequiredTitle => 'サインインしてください';

  @override
  String get loginRequiredSubtitle => 'SEAL Hackathonを続けるにはサインインが必要です。';

  @override
  String get goToLoginButton => 'サインインへ';

  @override
  String get supabaseRequiredTitle => 'システムに接続できません';

  @override
  String get supabaseRequiredBody =>
      'データを読み込む準備ができていません。後でもう一度お試しいただくか、運営にお問い合わせください。';

  @override
  String get notLoggedInMessage => 'ログインしていません';

  @override
  String get logoutFailedMessage => 'ログアウトできませんでした。再試行してください。';

  @override
  String get saveSuccess => 'データを保存しました';

  @override
  String get updateSuccess => '更新しました';

  @override
  String get deleteSuccess => '削除しました';

  @override
  String get roleParticipant => '参加者';

  @override
  String get roleJudge => '審査員';

  @override
  String get roleMentor => 'メンター';

  @override
  String get roleOrganizer => '運営';

  @override
  String get eventsNavLabel => 'イベント';

  @override
  String get myHomeNavLabel => 'ホーム';

  @override
  String get teamNavLabel => 'チーム';

  @override
  String get submitNavLabel => '提出';

  @override
  String get judgeNavLabel => '採点';

  @override
  String get dashboardNavLabel => 'ダッシュボード';

  @override
  String get chatNavLabel => 'チャット';

  @override
  String get mapNavLabel => 'マップ';

  @override
  String get eventSubNavOverview => '概要';

  @override
  String get eventScopedSubtitle => 'アクティブなイベント';

  @override
  String get backToEventsAction => 'ホームに戻る';

  @override
  String get backToEventListAction => 'イベント一覧に戻る';

  @override
  String get profileNavLabel => 'プロフィール';

  @override
  String get notificationsNavLabel => '通知';

  @override
  String get accountMenuTooltip => 'アカウントメニュー';

  @override
  String get logoutButton => 'ログアウト';

  @override
  String get helpTooltip => 'ヘルプ';

  @override
  String get helpDialogTitle => 'お困りですか？';

  @override
  String get helpDialogBody => 'サポートデスクまたはチャットで運営にお問い合わせください。';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get registerTitle => 'アカウント作成';

  @override
  String get verifyEmailTitle => 'メール確認';

  @override
  String get loginHeroSubtitle => 'イベント、チーム、提出、採点、メッセージ、会場を一つのアプリで管理。';

  @override
  String get emailLabel => 'メール';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get confirmPasswordLabel => 'パスワード確認';

  @override
  String get fullNameLabel => '氏名';

  @override
  String get universityLabel => '大学';

  @override
  String get otpLabel => 'OTPコード（6桁）';

  @override
  String get registerRoleHint =>
      '新規アカウントは参加者として作成されます。登録後にOTPまたはリンクでメールを確認してください。';

  @override
  String get roleManagedHint => 'ロールはアカウントプロフィールで管理されます。';

  @override
  String get forgotPasswordButton => 'パスワードをお忘れですか？';

  @override
  String get hidePasswordTooltip => 'パスワードを隠す';

  @override
  String get showPasswordTooltip => 'パスワードを表示';

  @override
  String get loginButton => 'ログイン';

  @override
  String get registerButton => '登録';

  @override
  String get confirmOtpButton => 'OTPを確認';

  @override
  String get backToLoginButton => 'サインインに戻る';

  @override
  String get haveAccountButton => 'すでにアカウントをお持ちですか？ログイン';

  @override
  String get createAccountButton => '新規アカウント作成';

  @override
  String get loginSuccess => 'ログインに成功しました';

  @override
  String get loginFailed => 'メールまたはパスワードが正しくありません';

  @override
  String get emailConfirmedWelcomeBack => 'メールが確認されました。おかえりなさい！';

  @override
  String get noPendingVerificationEmail => '確認待ちのメールはありません。';

  @override
  String get registerSuccessPrefix => '登録成功：';

  @override
  String get eventsTitle => 'イベント';

  @override
  String get participantHomeTitle => 'あなたのイベント';

  @override
  String get participantHomeSubtitle => '下のイベントをタップして開始するか、進捗カードから続けてください。';

  @override
  String get participantPickEventTitle => '開始するイベントを選択';

  @override
  String get participantPickEventBody =>
      'まだチームに参加していません。一覧からイベントをタップして詳細を確認し、登録してください。';

  @override
  String get judgeEventListHint => '開催中のイベントをタップして採点キューを開きます。';

  @override
  String get mentorEventListHint => '割り当てられたイベントをタップして参加者とチャットします。';

  @override
  String get allEventsSectionTitle => 'すべてのイベント';

  @override
  String get journeyStepNeedsTeam => 'チーム未参加';

  @override
  String get journeyStepNeedsSubmission => '未提出';

  @override
  String get journeyStepAwaitingScore => '採点待ち';

  @override
  String get journeyStepHasScore => '採点済み';

  @override
  String get journeyStepRegistrationClosed => '登録締切';

  @override
  String get journeyStepMissedSubmission => '提出期限超過';

  @override
  String get journeyNextStepTitle => '次のステップ';

  @override
  String get journeyActionJoinTeam => 'チームを作成または参加';

  @override
  String get journeyActionBrowseEvents => '他のイベントを見る';

  @override
  String get journeyActionContactOrganizer => '運営に連絡';

  @override
  String get journeyActionSubmit => '今すぐ提出';

  @override
  String get journeyActionViewSubmission => '提出を表示';

  @override
  String get journeyActionViewScore => 'スコアを表示';

  @override
  String get journeyActionOpenMap => '会場を表示';

  @override
  String get journeyHelperRegistrationClosed =>
      'チーム登録は締め切られました。他のイベントを探すか運営に連絡してください。';

  @override
  String get journeyHelperMissedSubmission =>
      '提出期限を過ぎました。サポートが必要な場合は運営に連絡してください。';

  @override
  String get submissionReadOnlyScoreTitle => '採点結果';

  @override
  String get notificationActionGoTeams => 'チームへ';

  @override
  String get notificationActionSubmit => '提出';

  @override
  String get notificationActionViewScore => 'スコアを表示';

  @override
  String get notificationActionViewEvent => 'イベントを表示';

  @override
  String get notificationActionOpenJudge => '採点を開く';

  @override
  String get submissionDraftAutoSaving => '下書きを自動保存中';

  @override
  String get clearDraftButton => '下書きを消去';

  @override
  String get draftClearedMessage => '下書きを消去しました。';

  @override
  String get submitWizardStepTeam => 'チームを選択';

  @override
  String get submitWizardStepProject => 'プロジェクト情報';

  @override
  String get submitWizardStepLinks => 'リンクと提出';

  @override
  String get submitWizardNext => '次へ';

  @override
  String get submitWizardBack => '戻る';

  @override
  String get submitWizardReviewTitle => '提出前の確認';

  @override
  String get organizerTodayModeTitle => '今日';

  @override
  String get organizerShowDetailsButton => '詳細を表示';

  @override
  String get organizerHideDetailsButton => '詳細を隠す';

  @override
  String get roleOnboardingSkip => 'スキップ';

  @override
  String get roleOnboardingStart => '開始';

  @override
  String get roleOnboardingParticipantTitle => '参加者へようこそ';

  @override
  String get roleOnboardingParticipantBody =>
      'イベントをタップして開始 → チーム招待を作成または承諾 → 締切前に提出。';

  @override
  String get roleOnboardingJudgeTitle => '審査員へようこそ';

  @override
  String get roleOnboardingJudgeBody => '開催中のイベントを選択 → 採点タブ → 未採点の提出を選択。';

  @override
  String get roleOnboardingOrganizerTitle => '運営へようこそ';

  @override
  String get roleOnboardingOrganizerBody => '未採点作業を追跡し、メンターを割り当て、今日からお知らせを送信。';

  @override
  String get roleOnboardingMentorTitle => 'メンターへようこそ';

  @override
  String get roleOnboardingMentorBody => '割り当てられたイベントを選択 → チャットで参加者に返信。';

  @override
  String get chatMentorRequestTemplate => '運営の方、現在のイベントにメンターを割り当てていただけますか。';

  @override
  String get eventsSubtitle => 'ハッカソン、締切、詳細を追跡。';

  @override
  String get eventSearchHint => '名前、場所、トピックで検索';

  @override
  String get sortStartAsc => '開始日：早い順';

  @override
  String get sortStartDesc => '開始日：遅い順';

  @override
  String get sortTitleAsc => '名前 A → Z';

  @override
  String get sortTitleDesc => '名前 Z → A';

  @override
  String get sortDeadlineAsc => '締切：近い順';

  @override
  String get sortDeadlineDesc => '締切：遅い順';

  @override
  String get noMatchingEvents => '一致するイベントがありません。';

  @override
  String get noEventsYet => 'イベントはまだありません。';

  @override
  String get eventQuickActionsTitle => 'クイックアクション';

  @override
  String get clearSearchAction => '検索をクリア';

  @override
  String get reloadEventsAction => 'イベントを再読み込み';

  @override
  String get registerTeamPill => 'チーム登録';

  @override
  String get registrationClosedPill => '登録締切';

  @override
  String get eventDetailTitle => 'イベント詳細';

  @override
  String get eventDetailSubtitle => 'タイムライン、ルール、会場、リーダーボード。';

  @override
  String get eventDetailLoadingSubtitle => 'イベント情報を読み込み中...';

  @override
  String get eventNotFound => 'イベントが見つかりません';

  @override
  String get rulesTitle => 'ルール';

  @override
  String get prizeTitle => '賞品';

  @override
  String get leaderboardTitle => 'リーダーボード';

  @override
  String get noScoredSubmissionsYet => '採点済みの提出はまだありません。';

  @override
  String get noSubmissionsForEventYet => 'このイベントの提出はまだありません。';

  @override
  String get eventDetailStatsTitle => 'イベント統計';

  @override
  String get eventTeamsMetric => 'チーム';

  @override
  String get eventSubmissionsMetric => '提出';

  @override
  String get eventUnscoredMetric => '未採点';

  @override
  String get organizerShowAllEventsButton => 'すべてのイベントを表示';

  @override
  String get timelineTitle => 'タイムライン';

  @override
  String get timelineRegistration => '登録';

  @override
  String get timelineKickoff => 'キックオフ';

  @override
  String get timelineFinal => '最終';

  @override
  String get openJudgeQueueButton => '未採点を表示';

  @override
  String get openOrganizerDashboardButton => '運営ダッシュボードを開く';

  @override
  String get openMentorChatButton => 'メンターチャットを開く';

  @override
  String get manageTeamButton => 'チームを作成・管理';

  @override
  String get viewMyTeamButton => '自分のチームを表示';

  @override
  String get joinOrCreateTeamButton => 'チームを作成または参加';

  @override
  String get submitForEventButton => 'このイベントに提出';

  @override
  String get myTeamForEventTitle => 'あなたのチーム';

  @override
  String get leaderboardPendingTitle => '未採点';

  @override
  String get awaitingScoreBadge => '採点待ち';

  @override
  String get judgeQueueFilteredSubtitle => '選択イベントの未採点提出。';

  @override
  String get viewVenueButton => '会場を表示';

  @override
  String get eventCreatedSuccess => 'イベントを作成しました。';

  @override
  String get eventUpdatedSuccess => 'イベントを更新しました。';

  @override
  String get teamTitle => 'チーム';

  @override
  String get teamSubtitle => 'チームの作成・参加・管理';

  @override
  String get teamOverviewTitle => 'チーム概要';

  @override
  String get noTeamsYet => 'チームはまだありません';

  @override
  String get teamsAvailable => '参加可能なチーム';

  @override
  String get checkInLabel => 'チェックイン';

  @override
  String get checkInPending => '保留中';

  @override
  String get checkInConfirmed => '確認済み';

  @override
  String get submitProjectButton => 'プロジェクトを提出';

  @override
  String get createTeamButton => 'チームを作成';

  @override
  String get createTeamTitle => 'チームを作成';

  @override
  String get eventLabel => 'イベント';

  @override
  String get teamNameLabel => 'チーム名';

  @override
  String get loadEventsBeforeCreateTeam =>
      'イベントが読み込まれていません。チーム作成前にイベントを読み込んでください。';

  @override
  String get roleViewOnlyTeams => 'このロールはチームの閲覧のみ可能です。';

  @override
  String get emptyTeamsMessage => 'チームがありません。続行するにはチームを作成してください。';

  @override
  String get myTeamsGroup => '自分のチーム';

  @override
  String get otherTeamsGroup => 'その他のチーム';

  @override
  String get teamFullBadge => '満員';

  @override
  String get updateTeamDialogTitle => 'チームを更新';

  @override
  String get leaveTeamDialogTitle => 'チームを脱退しますか？';

  @override
  String get leaveTeamButton => 'チームを脱退';

  @override
  String get joinTeamButton => 'チームに参加';

  @override
  String get inviteMemberTitle => 'メンバーを招待';

  @override
  String get memberEmailLabel => 'メンバーのメール';

  @override
  String get sendInvitationButton => '招待を送信';

  @override
  String get invitationSendingStatus => '招待を送信中...';

  @override
  String get teamInvitationTitle => 'チーム招待';

  @override
  String get teamCreatedNotificationTitle => 'チームを作成しました';

  @override
  String get teamCreatedSuccess => 'チームを作成しました。';

  @override
  String get teamJoinedSuccess => 'チームに参加しました。';

  @override
  String get invitationSentSuccess => '招待を送信しました。';

  @override
  String get invitationAcceptedSuccess => 'チームに参加しました。';

  @override
  String get invitationDeclinedSuccess => '招待を辞退しました。';

  @override
  String get pendingInvitationsTitle => '保留中の招待';

  @override
  String get pendingInvitationsEmpty => 'チーム招待はありません。';

  @override
  String get acceptInvitationButton => '承諾';

  @override
  String get declineInvitationButton => '辞退';

  @override
  String get invitationStatusPending => '保留中';

  @override
  String get invitationStatusAccepted => '承諾済み';

  @override
  String get invitationStatusDeclined => '辞退済み';

  @override
  String get teamUpdatedSuccess => 'チームを更新しました。';

  @override
  String get teamLeftSuccess => 'チームを脱退しました。';

  @override
  String get invalidTeamError => '無効なチームです。';

  @override
  String get inviteUserNotFound => 'このメールのアカウントが見つかりません。';

  @override
  String get invitationAlreadyPending => 'この人には既に保留中の招待があります。';

  @override
  String get alreadyTeamMemberError => '既にこのチームのメンバーです。';

  @override
  String get alreadyOnEventTeamError =>
      'このイベントの別チームに既に参加しています。新しいチームに参加する前に現在のチームを脱退してください。';

  @override
  String get oneTeamPerEventBadge => 'このイベントのチーム参加済み';

  @override
  String get cannotChangeOwnRole => '自分のロールは変更できません。';

  @override
  String get leaveTeamRegistrationClosedError => '登録締切後はチームを脱退できません。';

  @override
  String get invitationNoLongerPending => 'この招待は無効になりました。';

  @override
  String get errorEventContextRequired => 'イベントコンテキストが必要です';

  @override
  String get errorEventEnded => 'イベントが終了しました。チームの作成・参加はできません。';

  @override
  String get errorRegistrationDeadlinePassed => 'このイベントのチーム登録締切を過ぎました。';

  @override
  String get errorSubmissionClosed => 'イベントが終了しました。提出・更新はできません。';

  @override
  String get errorSubmissionNotStarted => 'イベントがまだ開始していません。提出できません。';

  @override
  String get errorJudgingNotStarted => 'イベントがまだ開始していません。採点できません。';

  @override
  String get errorJudgingClosed => 'イベントが終了しました。採点できません。';

  @override
  String get teamInviteOnlyError => 'リーダーの招待でのみチームに参加できます。';

  @override
  String get teamInviteOnlyBadge => '招待制';

  @override
  String get teamInviteOnlyHelper => '招待についてはチームリーダーにお問い合わせください。';

  @override
  String get submissionsRoleGateMessage => '提出は参加者のみ可能です。';

  @override
  String get submitScreenTitle => 'プロジェクト提出';

  @override
  String get submitScreenSubtitle => 'GitHub、デモ動画、説明を送信';

  @override
  String get projectInfoSection => 'プロジェクト情報';

  @override
  String get linksSection => 'リンク';

  @override
  String get descriptionSection => '説明';

  @override
  String get projectNameLabel => 'プロジェクト名';

  @override
  String get githubUrlLabel => 'GitHubリンク';

  @override
  String get demoVideoUrlLabel => 'デモ動画リンク';

  @override
  String get projectDescriptionHint => 'プロジェクトはどんな課題を解決しますか？';

  @override
  String get submissionDescriptionTip => 'ヒント：課題、解決策、主要機能、技術スタック、測定可能なインパクト。';

  @override
  String get joinTeamBeforeSubmit => '提出する前にチームに参加してください';

  @override
  String get updateSubmissionButton => '提出を更新';

  @override
  String get submitProjectAction => '提出';

  @override
  String get needsSubmissionStatus => '提出が必要';

  @override
  String get noProjectSubmittedHelper => 'まだ提出がありません。';

  @override
  String get reviewedStatus => 'レビュー済み';

  @override
  String get reviewedHelper => '審査員がフィードバックを公開しました。';

  @override
  String get submittedStatus => '提出済み';

  @override
  String get submittedHelper => '審査員の採点を待っています。';

  @override
  String get notSubmittedYet => '未提出';

  @override
  String get latestSubmissionTitle => '最新の提出';

  @override
  String get selectTeamToSubmit => '提出するチームを選択または作成してください。';

  @override
  String get goToTeamAction => 'チームへ';

  @override
  String get createTeamNowAction => '今すぐチームを作成';

  @override
  String get teamHasNoSubmission => 'このチームはまだ提出していません。';

  @override
  String get updateHistoryTitle => '更新履歴';

  @override
  String get judgeFeedbackTitle => '審査員フィードバック';

  @override
  String get submissionSavedNotificationTitle => '提出を保存しました';

  @override
  String get submissionCreatedSuccess => '提出しました。';

  @override
  String get submissionUpdatedSuccess => '提出を更新しました。';

  @override
  String get submissionStatusReviewed => 'レビュー済み';

  @override
  String get submissionStatusSubmitted => '提出済み';

  @override
  String get submissionStatusDraft => '下書き';

  @override
  String get submissionDraftRestored => '未送信の下書きを復元しました。';

  @override
  String get chatRoleGateMessage => 'チャットは参加者とメンターが利用できます。';

  @override
  String get chatTitle => 'チャット';

  @override
  String get chatSubtitle => 'メンターまたは運営に連絡';

  @override
  String get chatContactLabel => 'メンターとチャット';

  @override
  String get noChatContactsMessage => 'チャット相手がいません';

  @override
  String get contactOrganizerForMentorAction => 'メッセージをコピー';

  @override
  String get sendMentorRequestAction => 'メンター依頼を送信';

  @override
  String get mentorRequestSentSuccess => 'メンター依頼を送信しました';

  @override
  String get contactOrganizerHint => 'テンプレートをコピーしました。運営に連絡してください';

  @override
  String get chatInputHint => 'メンターに質問...';

  @override
  String get chatRealtimeConnected => 'メッセージを更新中';

  @override
  String get chatRealtimeConnecting => 'チャットを開いています';

  @override
  String get chatRealtimeOffline => 'メッセージを再読み込み';

  @override
  String get reloadChatTooltip => 'チャットを再読み込み';

  @override
  String get messageSentStatus => '送信済み';

  @override
  String get sendMessageTooltip => '送信';

  @override
  String get yourMessageSemantic => '自分のメッセージ';

  @override
  String get deleteMessageTitle => 'メッセージを削除しますか？';

  @override
  String get deleteMessageBody => 'メッセージは会話から削除されます。';

  @override
  String get noMessagesYet => 'メッセージはまだありません。';

  @override
  String get selectConversationBeforeSend => '送信前に会話を選択してください。';

  @override
  String get judgeRoleGateMessage => '採点は審査員のみアクセス可能です。';

  @override
  String get judgeTitle => '採点キュー';

  @override
  String get judgeSubtitle => '提出物を審査してスコアを付ける';

  @override
  String get filterUnscored => '未採点';

  @override
  String get filterScored => '採点済み';

  @override
  String get judgeSearchLabel => '提出またはチームを検索';

  @override
  String get noMatchingSubmissions => '条件に一致する提出物がありません';

  @override
  String get showAllSubmissions => 'すべて表示';

  @override
  String get selectSubmissionTitle => '提出を選択';

  @override
  String get nextUnscoredButton => '次の未採点';

  @override
  String get selectSubmissionToScore => '採点する提出物を選択';

  @override
  String get needsScoringBadge => '採点が必要';

  @override
  String get repositoryButton => 'ソースコード';

  @override
  String get demoButton => 'デモ動画';

  @override
  String get rubricEvaluationTitle => 'ルーブリック';

  @override
  String get feedbackLabel => 'フィードバック';

  @override
  String get updateScoreDialogTitle => '古いスコアを更新しますか？';

  @override
  String get currentScoreLabel => '現在のスコア';

  @override
  String get feedbackReady => '準備完了';

  @override
  String get feedbackMissing => '未入力';

  @override
  String get submitScoreButton => 'スコアを提出';

  @override
  String get updateScoreButton => 'スコアを更新';

  @override
  String get scoringProgressTitle => '採点の進捗';

  @override
  String get scorePublishedNotificationTitle => 'スコアを公開しました';

  @override
  String get scorePublishedSnackBar => '提出のスコアを公開しました。';

  @override
  String get scoreSavedSuccess => 'スコアを保存しました。';

  @override
  String get judgeScoreParticipantHint => '参加者は通知を開いてスコアとフィードバックを確認できます。';

  @override
  String get scoreNotificationDialogTitle => '採点結果';

  @override
  String get announcementNotificationDialogTitle => '運営からのお知らせ';

  @override
  String get viewSubmissionButton => '提出を表示';

  @override
  String get closeDialogButton => '閉じる';

  @override
  String get organizerRoleGateMessage => '運営機能は運営者のみアクセス可能です。';

  @override
  String get organizerTitle => '運営ダッシュボード';

  @override
  String get organizerSubtitle => 'イベント、チーム、提出物を管理';

  @override
  String get sectionOverview => '概要';

  @override
  String get sectionOperations => '運用';

  @override
  String get sectionSubmissions => '提出';

  @override
  String get sectionEvents => 'イベント';

  @override
  String get sectionTeams => 'チーム';

  @override
  String get sendAnnouncementButton => 'お知らせを送信';

  @override
  String get sendAnnouncementDialogTitle => 'お知らせを送信';

  @override
  String get recipientLabel => '受信者';

  @override
  String get notificationTitleLabel => 'タイトル';

  @override
  String get notificationContentLabel => '内容';

  @override
  String get announcementPreviewTitle => 'お知らせのプレビュー';

  @override
  String get confirmSendAnnouncementButton => '送信を確認';

  @override
  String get announcementSendingStatus => 'お知らせを送信中...';

  @override
  String get recipientCountLabel => '受信者数';

  @override
  String get createEventTitle => 'イベントを作成';

  @override
  String get editEventTitle => 'イベントを編集';

  @override
  String get eventFieldTitle => 'タイトル';

  @override
  String get eventFieldDescription => '説明';

  @override
  String get eventFieldLocation => '場所';

  @override
  String get eventFieldBannerUrl => 'バナーURL';

  @override
  String get eventFieldStartDate => '開始日';

  @override
  String get eventFieldEndDate => '終了日';

  @override
  String get eventFieldRegistrationDeadline => '登録締切';

  @override
  String get eventFieldSubmissionDeadline => '提出締切';

  @override
  String get eventFieldSupportHotline => 'サポートホットライン';

  @override
  String get eventFieldOpeningHours => '営業時間';

  @override
  String get eventFieldMaxTeamSize => '最大チーム人数';

  @override
  String get eventFieldRules => 'ルール';

  @override
  String get eventFieldPrize => '賞品';

  @override
  String get eventFieldLatitude => '緯度';

  @override
  String get eventFieldLongitude => '経度';

  @override
  String get selectOnMapButton => 'マップで選択';

  @override
  String get eventStepInfo => '情報';

  @override
  String get eventStepBanner => 'バナー';

  @override
  String get eventStepLocation => '場所';

  @override
  String get eventStepTime => 'スケジュール';

  @override
  String get uploadBannerTooltip => '画像をアップロード';

  @override
  String get uploadBannerButton => '画像をアップロード';

  @override
  String get changeBannerButton => '画像を変更';

  @override
  String get removeBannerButton => '画像を削除';

  @override
  String get bannerUploadSuccess => 'バナーをアップロードしました。';

  @override
  String get uploadBannerFailed => '画像をアップロードできませんでした。Storage設定を確認してください。';

  @override
  String get advancedCoordinatesTitle => '詳細：座標';

  @override
  String get invalidEventDatesSnackBar => 'イベント日付が無効です。形式を確認してください。';

  @override
  String get closeRegistrationTitle => '登録を締め切る';

  @override
  String get closeRegistrationSuccess => '登録を締め切りました';

  @override
  String get recentSubmissionsTitle => '最近の提出';

  @override
  String get noSubmissionsYet => '提出はまだありません。';

  @override
  String get openTeamAction => 'チームを開く';

  @override
  String get teamDetailsTitle => 'チーム詳細';

  @override
  String get noTeamsToView => '表示するチームがありません。';

  @override
  String get leaderboardCopiedSuccess => 'リーダーボードをコピーしました';

  @override
  String get manageUserRolesTitle => 'ユーザーロールを管理';

  @override
  String get createStaffAccountTitle => '審査員/メンターアカウントを作成';

  @override
  String get createStaffAccountButton => 'アカウントを作成';

  @override
  String get createStaffAccountFailed =>
      'アカウントを作成できませんでした。admin-create-user Edge Functionを確認してください。';

  @override
  String get noUsersYet => 'ユーザーはまだいません。';

  @override
  String get changeRoleDialogTitle => 'アカウントロールを変更しますか？';

  @override
  String get exportLeaderboardTitle => 'リーダーボードをエクスポート';

  @override
  String get userRolesTitle => 'ユーザーロール';

  @override
  String get userSearchLabel => '名前またはメールで検索';

  @override
  String get roleFilterLabel => 'ロールでフィルター';

  @override
  String get noMatchingUsers => '一致するアカウントがありません。';

  @override
  String get manageScoreCriteriaTitle => '採点基準を管理';

  @override
  String get manageEventMentorsTitle => 'イベントメンターを割り当て';

  @override
  String get manageEventMentorsDescription => 'ハッカソンごとに参加者をサポートするメンターを選択';

  @override
  String get noEventsForMentorAssignment => 'メンター割り当て可能なイベントがありません。';

  @override
  String get noMentorsAvailableMessage => 'メンターアカウントがありません。先にロールを作成・割り当ててください。';

  @override
  String get mentorAssignmentLoadFailed => '割り当て済みメンターを読み込めませんでした。';

  @override
  String get manageScoreCriteriaDescription => 'イベントごとにカスタムルーブリックを作成';

  @override
  String get addScoreCriterionButton => '基準を追加';

  @override
  String get scoreCriterionLabel => '基準名';

  @override
  String get scoreCriterionDescription => '基準の説明';

  @override
  String get scoreCriteriaSavedSuccess => '採点基準を保存しました。';

  @override
  String get defaultRubricHint =>
      'このイベントはデフォルトルーブリックを使用しています。運営者はカスタムルーブリックを編集・保存できます。';

  @override
  String get useDefaultRubricButton => 'デフォルトルーブリックを使用';

  @override
  String get unscoredMetricLabel => '未採点';

  @override
  String get organizerTodayTasksTitle => '今日のタスク';

  @override
  String get organizerUnscoredTasksLabel => '未採点の提出';

  @override
  String get organizerTeamsNeedMembersLabel => 'メンバー不足のチーム';

  @override
  String get organizerClosingSoonLabel => '登録締切間近';

  @override
  String get organizerSendReminderButton => 'リマインダーを送信';

  @override
  String get organizerAssignMentorButton => 'メンターを割り当て';

  @override
  String get organizerTaskUnscoredLabel => '採点リマインダー';

  @override
  String get organizerTaskTeamsLabel => 'チームリマインダー';

  @override
  String get organizerTaskClosingLabel => '登録リマインダー';

  @override
  String get otherActionsTitle => 'その他のアクション';

  @override
  String get dashboardChartTitle => '採点概要';

  @override
  String get scoredBarLabel => '採点済み';

  @override
  String get unscoredBarLabel => '未採点';

  @override
  String get loadMoreButton => 'もっと読み込む';

  @override
  String get announcementEventLabel => 'イベントをリンク（任意）';

  @override
  String get announcementNoEvent => 'リンクされたイベントなし';

  @override
  String get viewEventFromAnnouncementButton => 'イベントを表示';

  @override
  String get announcementTemplatesLabel => 'クイックテンプレート';

  @override
  String get announcementTemplateJudgingLabel => '審査開始';

  @override
  String get announcementTemplateJudgingTitle => '審査室オープン';

  @override
  String get announcementTemplateJudgingBody =>
      '審査員は採点タブを開いてください。公式審査セッションが開始されました。';

  @override
  String get announcementTemplateDeadlineLabel => '締切';

  @override
  String get announcementTemplateDeadlineTitle => '提出締切のリマインダー';

  @override
  String get announcementTemplateDeadlineBody =>
      '未提出のチームは締切前にGitHub、デモ動画、説明を完成させてください。';

  @override
  String get announcementTemplateKickoffLabel => 'キックオフ';

  @override
  String get announcementTemplateKickoffTitle => 'ハッカソンキックオフ';

  @override
  String get announcementTemplateKickoffBody =>
      'SEAL Innovation Hackathon 2026へようこそ。スケジュールとルールはイベントタブをご確認ください。';

  @override
  String get newScoreSnackBar => '新しいスコアがあります';

  @override
  String get openInboxAction => '通知を表示';

  @override
  String get inboxTitle => '受信トレイ';

  @override
  String get inboxSubtitle => 'スコア、チーム、イベントの通知';

  @override
  String get inboxEmpty => '通知はまだありません';

  @override
  String get reloadInboxAction => '再読み込み';

  @override
  String get unreadGroup => '未読';

  @override
  String get readGroup => '既読';

  @override
  String get markAsReadAction => '既読にする';

  @override
  String get deleteNotificationTitle => '通知を削除しますか？';

  @override
  String get deleteNotificationBody => 'この項目は一覧から削除されます。';

  @override
  String get profileTitle => 'プロフィール';

  @override
  String get profileSubtitle => 'アカウントとセキュリティ設定';

  @override
  String get noActiveSession => 'アクティブなセッションがありません。';

  @override
  String get roleLabel => 'ロール';

  @override
  String get accountInfoTitle => 'アカウント情報';

  @override
  String get saveProfileButton => 'プロフィールを保存';

  @override
  String get profileUpdatedSuccess => 'プロフィールを更新しました';

  @override
  String get profileSecurityTitle => 'セキュリティ';

  @override
  String get profileSecuritySubtitle =>
      '登録メールにパスワードリセットメールを送信。メール変更は運営にお問い合わせください。';

  @override
  String get themeModeTitle => '外観';

  @override
  String get themeModeDark => 'ダーク';

  @override
  String get themeModeLight => 'ライト';

  @override
  String get themeModeSystem => 'システム';

  @override
  String get languageTitle => '言語';

  @override
  String get languageVi => 'ベトナム語';

  @override
  String get languageEn => '英語';

  @override
  String get languageJa => '日本語';

  @override
  String get sessionSectionTitle => 'セッション';

  @override
  String get logoutDescription => 'サインアウトするとローカル状態がクリアされ、サインイン画面に戻ります。';

  @override
  String get mapTitle => '会場マップ';

  @override
  String get mapSubtitle => 'イベント会場とアクセス情報';

  @override
  String get noVenueYet => '会場情報はまだありません';

  @override
  String get addressLabel => '住所';

  @override
  String get openingHoursLabel => '営業時間';

  @override
  String get hotlineLabel => 'ホットライン';

  @override
  String get coordinatesLabel => '座標';

  @override
  String get defaultOpeningHours => '08:00 - 18:00';

  @override
  String get defaultHotline => '0900 000 000';

  @override
  String get copyAddressButton => '住所をコピー';

  @override
  String get addressCopiedSuccess => '住所をコピーしました';

  @override
  String get openMapsButton => 'マップで開く';

  @override
  String get openExternalMapsTitle => '外部マップを開きますか？';

  @override
  String get openExternalMapsBody => 'SEAL Hackathonを一時的に離れてマップを開きます。';

  @override
  String get mapPickerTitle => 'イベント場所を選択';

  @override
  String get mapPickerInstruction => 'マップをドラッグしてピンをイベント場所に置いてください';

  @override
  String get openMapsFailed => 'このデバイスでマップを開けませんでした。';

  @override
  String get validationEmailRequired => 'メールを入力してください。';

  @override
  String get validationEmailInvalid => '有効なメールを入力してください。';

  @override
  String get validationPasswordRequired => 'パスワードを入力してください。';

  @override
  String get validationPasswordMinLength => 'パスワードは6文字以上必要です。';

  @override
  String get validationConfirmPasswordRequired => 'パスワードを確認してください。';

  @override
  String get validationPasswordMismatch => 'パスワードが一致しません。';

  @override
  String get validationOtpRequired => 'メールのOTPを入力してください。';

  @override
  String get validationOtpInvalid => 'OTPは6桁である必要があります。';

  @override
  String get validationFullNameRequired => '氏名を入力してください。';

  @override
  String get validationFullNameMinLength => '氏名は2文字以上必要です。';

  @override
  String get validationUniversityRequired => '大学を入力してください。';

  @override
  String get validationUniversityMinLength => '大学名は2文字以上必要です。';

  @override
  String get validationSupabaseNotReady => 'システムに接続できません。後でもう一度お試しください。';

  @override
  String get validationTeamNameRequired => 'チーム名を入力してください。';

  @override
  String get validationTeamNameMinLength => 'チーム名は2文字以上必要です。';

  @override
  String get validationInviteEmailInvalid => '有効なメンバーメールを入力してください。';

  @override
  String get validationProjectNameRequired => 'プロジェクト名を入力してください。';

  @override
  String get validationProjectNameMinLength => 'プロジェクト名は2文字以上必要です。';

  @override
  String get validationDescriptionRequired => 'プロジェクト説明を入力してください。';

  @override
  String get validationDescriptionMinLength => '説明は10文字以上必要です。';

  @override
  String get validationJoinTeamBeforeSubmit => '提出前にチームを作成または参加してください。';

  @override
  String get eventNotLoadedForSubmit =>
      'チームのイベント情報を読み込めませんでした。イベントを再読み込みしてください。';

  @override
  String get validationChatMessageRequired => 'メッセージは空にできません。';

  @override
  String get validationNotificationTitleRequired => '通知タイトルを入力してください。';

  @override
  String get validationNotificationBodyRequired => '通知本文を入力してください。';

  @override
  String get validationNotificationTypeInvalid => '無効な通知タイプです。';

  @override
  String get validationRecipientLabel => '受信者';

  @override
  String get validationEventTitleRequired => 'イベントタイトルを入力してください。';

  @override
  String get validationEventTitleMinLength => 'イベントタイトルは2文字以上必要です。';

  @override
  String get validationEventLocationRequired => 'イベントの場所を入力してください。';

  @override
  String get validationEventLocationMinLength => '場所は2文字以上必要です。';

  @override
  String get validationLatitudeRequired => '緯度を入力してください。';

  @override
  String get validationLatitudeInvalid => '緯度は有効な数値である必要があります。';

  @override
  String get validationLatitudeRange => '緯度は-90から90の間である必要があります。';

  @override
  String get validationLongitudeRequired => '経度を入力してください。';

  @override
  String get validationLongitudeInvalid => '経度は有効な数値である必要があります。';

  @override
  String get validationLongitudeRange => '経度は-180から180の間である必要があります。';

  @override
  String get validationMaxTeamSizeRequired => '最大チーム人数を入力してください。';

  @override
  String get validationMaxTeamSizeInvalid => '最大チーム人数は有効な整数である必要があります。';

  @override
  String get validationEndAfterStart => '終了日は開始日より後である必要があります。';

  @override
  String get validationDeadlineBeforeEnd => '登録締切はイベント終了後にできません。';

  @override
  String get validationSubmissionAfterStart => '提出締切はイベント開始後である必要があります。';

  @override
  String get validationSubmissionBeforeEnd => '提出締切はイベント終了後にできません。';

  @override
  String get validationScoreRange => 'スコアは0から10の間である必要があります。';

  @override
  String get validationScoreCriteriaRequired => '採点基準が少なくとも1つ必要です。';

  @override
  String get validationScoreCriteriaLimit => 'イベントあたり最大8つの採点基準。';

  @override
  String get validationScoreCriteriaLabelRequired => '基準名を入力してください。';

  @override
  String get validationScoreCriteriaDuplicate =>
      '重複する基準IDがあります。削除して再度追加してください。';

  @override
  String get validationScoreCriteriaWeight => '基準の重みは0より大きい必要があります。';

  @override
  String get validationNoSubmissionSelected => '採点する提出が選択されていません。';

  @override
  String get validationInvalidJudgeSession => '無効な審査員セッションです。';

  @override
  String get validationFeedbackRequired => 'スコア提出前にフィードバックを入力してください。';

  @override
  String get validationInvalidRole => '無効なロールです。';

  @override
  String get validationUserLabel => 'ユーザー';

  @override
  String get validationBannerUrlLabel => 'バナーURL';

  @override
  String get openLinkTooltip => 'リンクを開いて確認';

  @override
  String get openLinkFailed => 'このリンクを開けませんでした。';

  @override
  String get openExternalLinkFailed => 'このデバイスでリンクを開けませんでした。';

  @override
  String get reloadTeamsTooltip => 'チームを再読み込み';

  @override
  String get reloadJudgeQueueTooltip => 'キューを再読み込み';

  @override
  String get reloadDashboardTooltip => 'ダッシュボードを再読み込み';

  @override
  String get judgePreviewOnlyMessage => 'プレビューモード — 審査員アカウントでログインして採点してください';

  @override
  String get judgeQueueSortLabel => '未採点キューの並び替え';

  @override
  String get sortNewestFirst => '新しい順';

  @override
  String get sortProjectName => 'プロジェクト名';

  @override
  String get sortTeamName => 'チーム';

  @override
  String get sortAverageScore => '平均スコア';

  @override
  String get judgeSubmissionToScoreLabel => '採点する提出';

  @override
  String get unknownTeamLabel => '不明なチーム';

  @override
  String get teamNotLoadedYet => 'チーム未読み込み';

  @override
  String get eventNotLoadedYet => 'イベント未読み込み';

  @override
  String get averageScoreAbbrev => '平均';

  @override
  String get judgeReviewReminder =>
      'スコア提出前にソースコード、デモ品質、実装の深さ、プロダクトインパクトを確認してください。';

  @override
  String get rubricTechnicalLabel => '技術的深さ';

  @override
  String get rubricTechnicalDescription => 'アーキテクチャ、正確性、信頼性、実装の深さ。';

  @override
  String get rubricUiLabel => 'ユーザー体験';

  @override
  String get rubricUiDescription => 'モバイルフロー、明確さ、アクセシビリティ、仕上げ。';

  @override
  String get rubricInnovationLabel => '革新性';

  @override
  String get rubricInnovationDescription => '新規性、インパクト、有用なAI/自動化、プロダクト適合。';

  @override
  String get decreaseScoreTooltip => '減らす';

  @override
  String get increaseScoreTooltip => '増やす';

  @override
  String get editEventMenuItem => 'イベントを編集';

  @override
  String get closeRegistrationMenuItem => '登録を締め切る';

  @override
  String get closeRegistrationConfirmButton => '締め切る';

  @override
  String get notificationActionsTooltip => '通知オプション';

  @override
  String get eventActionsTooltip => 'イベントアクション';

  @override
  String get submissionsMetricLabel => '提出';

  @override
  String get scoresMetricLabel => 'スコア数';

  @override
  String get systemStatusTitle => 'システム状態';

  @override
  String get systemStatusSubtitle => 'データ読み込みと同期を追跡。';

  @override
  String get chatSuggestionSubmission => '提出について質問';

  @override
  String get chatSuggestionGithub => 'GitHubリンクのレビューを依頼';

  @override
  String get chatSuggestionChecklist => '提出チェックリスト';

  @override
  String get emailPrefix => 'メール：';

  @override
  String get averageScoreTitle => '平均スコア';

  @override
  String get judgeQueueTitle => '未採点キュー';

  @override
  String get judgeQueueWaitingSuffix => ' 件の未採点提出';

  @override
  String get exportLeaderboardDescription => 'リーダーボードデータをクリップボードにコピー';

  @override
  String get userRolesDescription => 'アカウントロールを表示・更新';

  @override
  String get databaseConnectedLabel => 'データ準備完了';

  @override
  String get databaseMissingLabel => 'データなし';

  @override
  String get operationsDataLabel => '運用データ';

  @override
  String get syncingLabel => '同期中';

  @override
  String get stateReadyLabel => '準備完了';

  @override
  String get notLoggedInShortLabel => '未サインイン';

  @override
  String get noApiErrorsLabel => 'データ読み込みエラーなし';

  @override
  String get systemStatusSemanticLabel => 'システム運用状態';

  @override
  String get profileFullNameFieldSemantic => 'プロフィール氏名フィールド';

  @override
  String get profileUniversityFieldSemantic => 'プロフィール大学フィールド';

  @override
  String get errorInvalidCredentials =>
      'メールまたはパスワードが正しくありません。登録済みのメールを使用するか「新規アカウント作成」をタップしてください。';

  @override
  String get errorEmailNotConfirmed => 'メールが確認されていません。受信トレイまたは迷惑メールを確認してください。';

  @override
  String get errorInvalidOtp => 'OTPが無効または期限切れです。有効化メールを再送信してください。';

  @override
  String get errorConnectionTimeout => '接続がタイムアウトしました。ネットワークを確認して再試行してください。';

  @override
  String get errorRlsPermissionDenied => 'この操作を実行する権限がありません。';

  @override
  String get errorDuplicateRecord => 'このデータは既に存在します。再読み込みして既存レコードを更新してください。';

  @override
  String get errorCheckConstraint => '無効なデータです。入力を確認して再試行してください。';

  @override
  String get otpHelpText => 'OTPは有効化メールに記載されています。受信トレイまたは迷惑メールをご確認ください。';

  @override
  String teamOverviewForEvent(String title) {
    return 'チーム — $title';
  }

  @override
  String scopedTeamsAvailable(int count) {
    return 'このイベントに$countチーム';
  }

  @override
  String pendingInvitationsCount(int count) {
    return '$count件の保留中招待';
  }

  @override
  String eventScheduleHours(String start, String end) {
    return '$start - $end';
  }

  @override
  String activationEmailSent(String email) {
    return '有効化メールを$emailに送信しました。リンクを開くか下に6桁のOTPを入力してください。';
  }

  @override
  String emailActivatedWelcome(String email) {
    return 'メールが有効化されました。$email、ようこそ！';
  }

  @override
  String passwordResetEmailSent(String email) {
    return 'パスワードリセットリンクを$emailに送信しました。受信トレイまたは迷惑メールをご確認ください。';
  }

  @override
  String registerSuccess(String email) {
    return '$emailで登録が完了しました。';
  }

  @override
  String organizerFocusEventSubtitle(String title) {
    return '$titleでフィルタリング中。';
  }

  @override
  String submissionEventLabel(String title) {
    return 'イベント：$title';
  }

  @override
  String judgeQueueForEventTitle(String title) {
    return '採点：$title';
  }

  @override
  String openEventSemanticLabel(String title) {
    return 'イベント$titleを開く';
  }

  @override
  String registerBeforeDate(String date) {
    return '$dateまでに登録';
  }

  @override
  String registrationClosedByDate(String date) {
    return '$dateに登録締切';
  }

  @override
  String registrationOpenUntilDate(String date) {
    return '$dateまで登録受付中';
  }

  @override
  String maxMembersChip(int count) {
    return '最大$count人';
  }

  @override
  String leaderPrefix(String name) {
    return 'リーダー：$name';
  }

  @override
  String memberCountLabel(int count) {
    return '$count人';
  }

  @override
  String teamSemanticLabel(String name, String memberCount, String leader) {
    return 'チーム $name、$memberCount人、リーダー：$leader';
  }

  @override
  String inviteTeamPrefix(String name) {
    return 'チーム：$name';
  }

  @override
  String leaveTeamDialogBody(String teamName) {
    return '$teamNameを脱退します。登録締切後は再参加できません。';
  }

  @override
  String teamInvitationBody(String teamName) {
    return '$teamNameに招待されています。チームタブで確認し、空きがあれば参加してください。';
  }

  @override
  String invitedByLabel(String name) {
    return '招待者：$name';
  }

  @override
  String teamCreatedNotificationBody(String teamName, String eventTitle) {
    return '$teamNameが$eventTitleに参加しました。';
  }

  @override
  String alreadyOnEventTeamNamedError(String teamName) {
    return 'このイベントでは既にチーム$teamNameに参加しています。';
  }

  @override
  String teamFullForEventError(String teamName) {
    return '$teamNameはこのイベントで満員です。';
  }

  @override
  String submissionSavedNotificationBody(String projectName) {
    return '$projectNameが正常に提出されました。';
  }

  @override
  String chatEventScopedSubtitle(String eventTitle) {
    return 'イベント$eventTitleの会話';
  }

  @override
  String mentorRequestNotificationTitle(String participantName) {
    return 'メンター依頼：$participantName';
  }

  @override
  String todayTimestamp(String time) {
    return '今日、$time';
  }

  @override
  String scoreOutOfTenLabel(String score) {
    return '$score/10';
  }

  @override
  String scoreWeightLabel(String weight) {
    return '重み x$weight';
  }

  @override
  String updateScoreDialogBody(String projectName) {
    return '$projectNameの以前のスコアが置き換えられます。';
  }

  @override
  String closeRegistrationBody(String title) {
    return '$titleの登録締切が現在時刻に設定されます。';
  }

  @override
  String announcementSentSuccess(int count) {
    return '$count人のユーザーにお知らせを送信しました。';
  }

  @override
  String announcementRolePreview(String role) {
    return '送信先：$role';
  }

  @override
  String recipientCountValue(int count) {
    return '$countアカウント';
  }

  @override
  String changeRoleDialogBody(String name, String role) {
    return '$nameを$roleに割り当てます。';
  }

  @override
  String roleUpdatedSuccess(String name) {
    return '$nameのロールを更新しました。';
  }

  @override
  String cannotChangeOwnRoleSubtitle(String email) {
    return '$email\n自分のロールは変更できません。';
  }

  @override
  String sendPasswordResetTo(String email) {
    return '$emailにパスワードリセットリンクを送信';
  }

  @override
  String mapPickerCoordinates(String latitude, String longitude) {
    return '座標：$latitude、$longitude';
  }

  @override
  String coordinatesPreview(String latitude, String longitude) {
    return '$latitude、$longitude';
  }

  @override
  String staffAccountCreatedSuccess(String name) {
    return '$nameのアカウントを作成しました。';
  }

  @override
  String mentorAssignmentSavedSuccess(int count) {
    return 'イベントに$count人のメンターを割り当てました。';
  }

  @override
  String organizerTaskUnscoredTitle(String eventTitle) {
    return '採点リマインダー — $eventTitle';
  }

  @override
  String organizerTaskUnscoredBody(int count) {
    return '$count件の提出がまだ未採点です。本日中に採点を完了してください。';
  }

  @override
  String organizerTaskTeamsTitle(String eventTitle) {
    return 'チームリマインダー — $eventTitle';
  }

  @override
  String organizerTaskTeamsBody(int count) {
    return '$countチームがまだメンバー不足です。締切前に参加者を招待してください。';
  }

  @override
  String organizerTaskClosingTitle(String eventTitle) {
    return '登録締切 — $eventTitle';
  }

  @override
  String organizerTaskClosingBody(int count) {
    return '$countイベントが3日以内に登録締切です。早めに登録を完了してください。';
  }

  @override
  String organizerNotificationSuggestions(int count) {
    return '$count件のおすすめお知らせ';
  }

  @override
  String journeyScoreSummary(String score) {
    return '平均スコア：$score';
  }

  @override
  String submissionDraftSavedAt(String time) {
    return '下書き保存：$time';
  }

  @override
  String validationSearchMaxLength(int max) {
    return '検索キーワードは最大$max文字です。';
  }

  @override
  String validationInvalidUser(String label) {
    return '$labelが無効です。';
  }

  @override
  String validationFieldRequired(String label) {
    return '$labelを入力してください。';
  }

  @override
  String validationInvalidUrl(String label) {
    return '$labelは有効なhttp/https URLである必要があります。';
  }

  @override
  String validationTeamNameMaxLength(int max) {
    return 'チーム名は最大$max文字です。';
  }

  @override
  String validationProjectNameMaxLength(int max) {
    return 'プロジェクト名は最大$max文字です。';
  }

  @override
  String validationDescriptionMaxLength(int max) {
    return '説明は最大$max文字です。';
  }

  @override
  String validationChatMessageMaxLength(int max) {
    return 'メッセージは最大$max文字です。';
  }

  @override
  String validationNotificationTitleMaxLength(int max) {
    return 'タイトルは最大$max文字です。';
  }

  @override
  String validationNotificationBodyMaxLength(int max) {
    return '本文は最大$max文字です。';
  }

  @override
  String validationFeedbackMaxLength(int max) {
    return 'フィードバックは最大$max文字です。';
  }

  @override
  String validationMaxTeamSizeRange(int min, int max) {
    return '最大チーム人数は$minから$maxの間である必要があります。';
  }

  @override
  String validationDateTimeFormat(String label, String format) {
    return '$labelは$format形式を使用してください（例：2026-06-15 09:00）。';
  }

  @override
  String submissionQueueCountLabel(int count) {
    return 'このキューに$count件の提出';
  }

  @override
  String scoreCountLabel(int count) {
    return '$count件のスコア';
  }

  @override
  String scoringProgressSemantic(int scored, int unscored) {
    return '採点進捗：$scored件採点済み、$unscored件未採点';
  }

  @override
  String memberCountWithLimit(int current, int limit) {
    return '$current/$limit人';
  }

  @override
  String apiErrorCountLabel(int count) {
    return '$count件のエラー';
  }

  @override
  String judgeQueueWaitingLabel(int count) {
    return '$count件の未採点提出';
  }

  @override
  String scoreSliderSemantic(String label, String value, String description) {
    return '$label $value点。$description';
  }

  @override
  String messageTimestampSemantic(String senderLabel, String time) {
    return '$senderLabel、$time';
  }
}
