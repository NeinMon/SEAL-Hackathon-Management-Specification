// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get sessionBootstrapMessage => 'Đang khôi phục phiên đăng nhập...';

  @override
  String get statusRegistrationClosing => 'Đăng ký sắp đóng';

  @override
  String get statusJudging => 'Đang chấm';

  @override
  String get allEventsFilter => 'Tất cả sự kiện';

  @override
  String get myTeamReadyBadge => 'Đã có đội';

  @override
  String get myTeamPendingBadge => 'Chưa có đội';

  @override
  String get weightedScoreHint =>
      'Điểm hiển thị là trung bình có trọng số theo rubric và sẽ được lưu vào hệ thống.';

  @override
  String get scorePublishedWithHintSnackBar =>
      'Đã công bố điểm. Thí sinh sẽ nhận thông báo qua hộp thư.';

  @override
  String get demoResetTitle => 'Reset dữ liệu demo';

  @override
  String get demoResetDescription =>
      'Xóa toàn bộ users, events, teams, submissions và scores trên môi trường hiện tại. Chỉ dùng cho demo local.';

  @override
  String get demoResetConfirmLabel => 'Nhập RESET để xác nhận';

  @override
  String get demoResetSuccess => 'Đã reset dữ liệu demo.';

  @override
  String get eventSupportHotline => 'Liên hệ BTC qua Chat hoặc thông báo';

  @override
  String get demoOnboardingTitle => 'Hướng dẫn demo nhanh';

  @override
  String get demoOnboardingStartButton => 'Bắt đầu demo';

  @override
  String get demoOnboardingParticipantTitle => 'Thí sinh';

  @override
  String get demoOnboardingParticipantBody =>
      'Sự kiện → Đội → Nộp bài. Dùng tài khoản demo nếu môi trường đã seed dữ liệu.';

  @override
  String get demoOnboardingJudgeTitle => 'Giám khảo';

  @override
  String get demoOnboardingJudgeBody =>
      'Tab Chấm điểm → chọn bài → nhập tiêu chí và nhận xét → Gửi điểm.';

  @override
  String get demoOnboardingAlertsTitle => 'Thông báo';

  @override
  String get demoOnboardingAlertsBody =>
      'Biểu tượng chuông góc phải. Bấm thông báo điểm để xem chi tiết.';

  @override
  String get appName => 'SEAL Hackathon';

  @override
  String get cancelButton => 'Hủy';

  @override
  String get saveButton => 'Lưu';

  @override
  String get deleteButton => 'Xóa';

  @override
  String get sendButton => 'Gửi';

  @override
  String get doneButton => 'Xong';

  @override
  String get resetButton => 'Reset';

  @override
  String get updateButton => 'Cập nhật';

  @override
  String get retryButton => 'Thử lại';

  @override
  String get stayButton => 'Ở lại';

  @override
  String get confirmButton => 'Xác nhận';

  @override
  String get confirmDelete => 'Bạn có chắc chắn muốn xóa?';

  @override
  String get detailsButton => 'Chi tiết';

  @override
  String get editButton => 'Sửa';

  @override
  String get inviteButton => 'Mời';

  @override
  String get allFilter => 'Tất cả';

  @override
  String get sortLabel => 'Sắp xếp';

  @override
  String get unknownLabel => 'Chưa rõ';

  @override
  String get leaderBadge => 'Trưởng đội';

  @override
  String get meLabel => 'Tôi';

  @override
  String get statusActive => 'Đang mở';

  @override
  String get statusUpcoming => 'Sắp diễn ra';

  @override
  String get statusClosed => 'Đã đóng';

  @override
  String get filterRegistrationOpen => 'Còn đăng ký';

  @override
  String get networkOfflineMessage =>
      'Không có kết nối mạng. Kiểm tra mạng rồi thử lại.';

  @override
  String get networkError => 'Không thể kết nối máy chủ';

  @override
  String get unknownError => 'Đã có lỗi xảy ra';

  @override
  String get accessDeniedTitle => 'Không có quyền truy cập';

  @override
  String get accessDeniedSubtitle =>
      'Tính năng này không khả dụng với vai trò hiện tại.';

  @override
  String get accessDeniedDefaultMessage =>
      'Vui lòng đăng nhập bằng tài khoản phù hợp.';

  @override
  String get backToEventsButton => 'Về sự kiện';

  @override
  String get loginRequiredTitle => 'Vui lòng đăng nhập';

  @override
  String get loginRequiredSubtitle =>
      'Đăng nhập để tiếp tục sử dụng SEAL Hackathon.';

  @override
  String get goToLoginButton => 'Đến màn hình đăng nhập';

  @override
  String get supabaseRequiredTitle => 'Không thể kết nối hệ thống';

  @override
  String get supabaseRequiredBody =>
      'Ứng dụng chưa sẵn sàng để tải dữ liệu. Vui lòng thử lại sau hoặc liên hệ ban tổ chức.';

  @override
  String get notLoggedInMessage => 'Bạn chưa đăng nhập.';

  @override
  String get logoutFailedMessage => 'Không thể đăng xuất. Thử lại.';

  @override
  String get saveSuccess => 'Lưu dữ liệu thành công';

  @override
  String get updateSuccess => 'Cập nhật thành công';

  @override
  String get deleteSuccess => 'Xóa dữ liệu thành công';

  @override
  String get roleParticipant => 'Thí sinh';

  @override
  String get roleJudge => 'Giám khảo';

  @override
  String get roleMentor => 'Cố vấn';

  @override
  String get roleOrganizer => 'Ban tổ chức';

  @override
  String get eventsNavLabel => 'Sự kiện';

  @override
  String get myHomeNavLabel => 'Của tôi';

  @override
  String get teamNavLabel => 'Đội';

  @override
  String get submitNavLabel => 'Nộp bài';

  @override
  String get judgeNavLabel => 'Chấm điểm';

  @override
  String get dashboardNavLabel => 'Tổng quan';

  @override
  String get chatNavLabel => 'Chat';

  @override
  String get mapNavLabel => 'Bản đồ';

  @override
  String get eventSubNavOverview => 'Tổng quan';

  @override
  String get eventScopedSubtitle => 'Sự kiện đang làm việc';

  @override
  String get backToEventsAction => 'Về trang Của tôi';

  @override
  String get backToEventListAction => 'Về danh sách sự kiện';

  @override
  String get profileNavLabel => 'Hồ sơ';

  @override
  String get notificationsNavLabel => 'Thông báo';

  @override
  String get accountMenuTooltip => 'Tài khoản';

  @override
  String get logoutButton => 'Đăng xuất';

  @override
  String get helpTooltip => 'Hỗ trợ';

  @override
  String get helpDialogTitle => 'Cần hỗ trợ?';

  @override
  String get helpDialogBody =>
      'Liên hệ ban tổ chức tại quầy hỗ trợ hoặc gửi tin nhắn trong mục Chat.';

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get registerTitle => 'Tạo tài khoản';

  @override
  String get verifyEmailTitle => 'Kích hoạt email';

  @override
  String get loginHeroSubtitle =>
      'Quản lý sự kiện, đội, bài nộp, chấm điểm, tin nhắn và địa điểm trong một ứng dụng di động.';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get confirmPasswordLabel => 'Nhập lại mật khẩu';

  @override
  String get fullNameLabel => 'Họ tên';

  @override
  String get universityLabel => 'Trường';

  @override
  String get otpLabel => 'Mã OTP (6 số)';

  @override
  String get registerRoleHint =>
      'Tài khoản mới được tạo với vai trò Thí sinh. Sau đăng ký cần kích hoạt email bằng mã OTP.';

  @override
  String get roleManagedHint => 'Vai trò được quản lý theo hồ sơ tài khoản.';

  @override
  String get forgotPasswordButton => 'Quên mật khẩu?';

  @override
  String get hidePasswordTooltip => 'Ẩn mật khẩu';

  @override
  String get showPasswordTooltip => 'Hiện mật khẩu';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get registerButton => 'Đăng ký';

  @override
  String get confirmOtpButton => 'Xác nhận OTP';

  @override
  String get backToLoginButton => 'Quay lại đăng nhập';

  @override
  String get haveAccountButton => 'Tôi đã có tài khoản';

  @override
  String get createAccountButton => 'Tạo tài khoản mới';

  @override
  String get loginSuccess => 'Đăng nhập thành công';

  @override
  String get loginFailed => 'Sai tên đăng nhập hoặc mật khẩu';

  @override
  String get emailConfirmedWelcomeBack =>
      'Email đã được xác nhận. Chào mừng bạn quay lại!';

  @override
  String get noPendingVerificationEmail => 'Không có email đang chờ xác nhận.';

  @override
  String get registerSuccessPrefix => 'Đăng ký thành công với';

  @override
  String get eventsTitle => 'Sự kiện';

  @override
  String get participantHomeTitle => 'Sự kiện của bạn';

  @override
  String get participantHomeSubtitle =>
      'Chạm một sự kiện bên dưới để bắt đầu — hoặc tiếp tục từ thẻ tiến độ.';

  @override
  String get participantPickEventTitle => 'Chọn sự kiện để bắt đầu';

  @override
  String get participantPickEventBody =>
      'Bạn chưa tham gia đội nào. Chạm một sự kiện trong danh sách để xem chi tiết và đăng ký.';

  @override
  String get judgeEventListHint =>
      'Chạm sự kiện đang mở để vào hàng đợi chấm điểm.';

  @override
  String get mentorEventListHint =>
      'Chạm sự kiện được gán để mở chat với thí sinh.';

  @override
  String get allEventsSectionTitle => 'Tất cả sự kiện';

  @override
  String get journeyStepNeedsTeam => 'Chưa có đội';

  @override
  String get journeyStepNeedsSubmission => 'Chưa nộp bài';

  @override
  String get journeyStepAwaitingScore => 'Đang chờ chấm';

  @override
  String get journeyStepHasScore => 'Đã có điểm';

  @override
  String get journeyStepRegistrationClosed => 'Đã đóng đăng ký';

  @override
  String get journeyStepMissedSubmission => 'Hết hạn nộp bài';

  @override
  String get journeyNextStepTitle => 'Bước tiếp theo';

  @override
  String get journeyActionJoinTeam => 'Tạo hoặc tham gia đội';

  @override
  String get journeyActionBrowseEvents => 'Xem sự kiện khác';

  @override
  String get journeyActionContactOrganizer => 'Liên hệ BTC';

  @override
  String get journeyActionSubmit => 'Nộp bài ngay';

  @override
  String get journeyActionViewSubmission => 'Xem bài nộp';

  @override
  String get journeyActionViewScore => 'Xem điểm';

  @override
  String get journeyActionOpenMap => 'Xem địa điểm';

  @override
  String get journeyHelperRegistrationClosed =>
      'Đăng ký đội đã đóng. Xem sự kiện khác hoặc liên hệ ban tổ chức.';

  @override
  String get journeyHelperMissedSubmission =>
      'Đã hết hạn nộp bài. Liên hệ ban tổ chức nếu bạn cần hỗ trợ.';

  @override
  String get submissionReadOnlyScoreTitle => 'Kết quả chấm điểm';

  @override
  String get notificationActionGoTeams => 'Đến Đội';

  @override
  String get notificationActionSubmit => 'Nộp bài';

  @override
  String get notificationActionViewScore => 'Xem điểm';

  @override
  String get notificationActionViewEvent => 'Xem sự kiện';

  @override
  String get notificationActionOpenJudge => 'Mở chấm điểm';

  @override
  String get submissionDraftAutoSaving => 'Đang lưu nháp tự động';

  @override
  String get clearDraftButton => 'Xóa nháp';

  @override
  String get draftClearedMessage => 'Đã xóa bản nháp.';

  @override
  String get submitWizardStepTeam => 'Chọn đội';

  @override
  String get submitWizardStepProject => 'Thông tin dự án';

  @override
  String get submitWizardStepLinks => 'Liên kết & gửi';

  @override
  String get submitWizardNext => 'Tiếp theo';

  @override
  String get submitWizardBack => 'Quay lại';

  @override
  String get submitWizardReviewTitle => 'Xem lại trước khi gửi';

  @override
  String get organizerTodayModeTitle => 'Hôm nay';

  @override
  String get organizerShowDetailsButton => 'Xem chi tiết';

  @override
  String get organizerHideDetailsButton => 'Thu gọn';

  @override
  String get roleOnboardingSkip => 'Bỏ qua';

  @override
  String get roleOnboardingStart => 'Bắt đầu';

  @override
  String get roleOnboardingParticipantTitle => 'Chào thí sinh';

  @override
  String get roleOnboardingParticipantBody =>
      'Chạm một sự kiện để bắt đầu → tạo hoặc nhận lời mời đội → nộp bài trước hạn.';

  @override
  String get roleOnboardingJudgeTitle => 'Chào giám khảo';

  @override
  String get roleOnboardingJudgeBody =>
      'Chọn sự kiện đang mở → vào tab Chấm điểm → chọn bài chưa chấm.';

  @override
  String get roleOnboardingOrganizerTitle => 'Chào ban tổ chức';

  @override
  String get roleOnboardingOrganizerBody =>
      'Theo dõi bài chưa chấm, gán mentor và gửi thông báo từ màn Hôm nay.';

  @override
  String get roleOnboardingMentorTitle => 'Chào cố vấn';

  @override
  String get roleOnboardingMentorBody =>
      'Chọn sự kiện được gán → mở Chat để trả lời thí sinh.';

  @override
  String get chatMentorRequestTemplate =>
      'Xin chào BTC, tôi cần được gán mentor cho sự kiện đang tham gia.';

  @override
  String get eventsSubtitle =>
      'Theo dõi hackathon, deadline và thông tin chi tiết.';

  @override
  String get eventSearchHint => 'Tìm theo tên, địa điểm hoặc chủ đề';

  @override
  String get sortStartAsc => 'Ngày bắt đầu: sớm nhất';

  @override
  String get sortStartDesc => 'Ngày bắt đầu: muộn nhất';

  @override
  String get sortTitleAsc => 'Tên A → Z';

  @override
  String get sortTitleDesc => 'Tên Z → A';

  @override
  String get sortDeadlineAsc => 'Hạn nộp: gần nhất';

  @override
  String get sortDeadlineDesc => 'Hạn nộp: xa nhất';

  @override
  String get noMatchingEvents => 'Không có sự kiện phù hợp.';

  @override
  String get noEventsYet => 'Chưa có sự kiện.';

  @override
  String get eventQuickActionsTitle => 'Hành động nhanh';

  @override
  String get clearSearchAction => 'Xóa tìm kiếm';

  @override
  String get reloadEventsAction => 'Tải lại sự kiện';

  @override
  String get registerTeamPill => 'Đăng ký đội';

  @override
  String get registrationClosedPill => 'Đăng ký đã đóng';

  @override
  String get eventDetailTitle => 'Chi tiết sự kiện';

  @override
  String get eventDetailSubtitle =>
      'Timeline, luật thi, địa điểm và bảng xếp hạng.';

  @override
  String get eventDetailLoadingSubtitle => 'Đang nạp dữ liệu sự kiện.';

  @override
  String get eventNotFound => 'Không tìm thấy sự kiện.';

  @override
  String get rulesTitle => 'Luật thi';

  @override
  String get prizeTitle => 'Giải thưởng';

  @override
  String get leaderboardTitle => 'Xếp hạng';

  @override
  String get noScoredSubmissionsYet => 'Chưa có bài nào được chấm.';

  @override
  String get noSubmissionsForEventYet => 'Chưa có bài nộp cho sự kiện này.';

  @override
  String get eventDetailStatsTitle => 'Số liệu sự kiện';

  @override
  String get eventTeamsMetric => 'Đội';

  @override
  String get eventSubmissionsMetric => 'Bài nộp';

  @override
  String get eventUnscoredMetric => 'Chưa chấm';

  @override
  String get organizerShowAllEventsButton => 'Xem tất cả sự kiện';

  @override
  String get timelineTitle => 'Timeline';

  @override
  String get timelineRegistration => 'Đăng ký';

  @override
  String get timelineKickoff => 'Khai mạc';

  @override
  String get timelineFinal => 'Chung kết';

  @override
  String get openJudgeQueueButton => 'Xem bài chưa chấm';

  @override
  String get openOrganizerDashboardButton => 'Mở tổng quan ban tổ chức';

  @override
  String get openMentorChatButton => 'Mở chat mentor';

  @override
  String get manageTeamButton => 'Tạo hoặc quản lý đội';

  @override
  String get viewMyTeamButton => 'Xem đội của tôi';

  @override
  String get joinOrCreateTeamButton => 'Tạo hoặc tham gia đội';

  @override
  String get submitForEventButton => 'Nộp bài cho sự kiện này';

  @override
  String get myTeamForEventTitle => 'Đội của bạn';

  @override
  String get leaderboardPendingTitle => 'Bài chưa chấm';

  @override
  String get awaitingScoreBadge => 'Đang chờ chấm';

  @override
  String get judgeQueueFilteredSubtitle =>
      'Danh sách bài nộp chưa được chấm cho sự kiện đang chọn.';

  @override
  String get viewVenueButton => 'Xem địa điểm';

  @override
  String get eventCreatedSuccess => 'Đã tạo sự kiện.';

  @override
  String get eventUpdatedSuccess => 'Đã cập nhật sự kiện.';

  @override
  String get teamTitle => 'Đội';

  @override
  String get teamSubtitle => 'Tạo đội, mời thành viên và quản lý tham gia.';

  @override
  String get teamOverviewTitle => 'Tổng quan đội';

  @override
  String get noTeamsYet => 'Chưa có đội';

  @override
  String get teamsAvailable => 'Đội đang có';

  @override
  String get checkInLabel => 'Điểm danh';

  @override
  String get checkInPending => 'Chờ';

  @override
  String get checkInConfirmed => 'Đã xác nhận';

  @override
  String get submitProjectButton => 'Nộp bài';

  @override
  String get createTeamButton => 'Tạo đội';

  @override
  String get createTeamTitle => 'Tạo đội';

  @override
  String get eventLabel => 'Sự kiện';

  @override
  String get teamNameLabel => 'Tên đội';

  @override
  String get loadEventsBeforeCreateTeam =>
      'Chưa có sự kiện. Tải sự kiện trước khi tạo đội.';

  @override
  String get roleViewOnlyTeams =>
      'Vai trò này chỉ xem đội, không tạo đội thí sinh.';

  @override
  String get emptyTeamsMessage => 'Chưa có đội. Tạo đội để tiếp tục.';

  @override
  String get myTeamsGroup => 'Đội của tôi';

  @override
  String get otherTeamsGroup => 'Đội khác';

  @override
  String get teamFullBadge => 'Đội đã đầy';

  @override
  String get updateTeamDialogTitle => 'Cập nhật đội';

  @override
  String get leaveTeamDialogTitle => 'Rời đội?';

  @override
  String get leaveTeamButton => 'Rời đội';

  @override
  String get joinTeamButton => 'Tham gia đội';

  @override
  String get inviteMemberTitle => 'Mời thành viên';

  @override
  String get memberEmailLabel => 'Email thành viên';

  @override
  String get sendInvitationButton => 'Gửi lời mời';

  @override
  String get invitationSendingStatus => 'Đang gửi lời mời...';

  @override
  String get teamInvitationTitle => 'Lời mời vào đội';

  @override
  String get teamCreatedNotificationTitle => 'Đã tạo đội';

  @override
  String get teamCreatedSuccess => 'Đã tạo đội.';

  @override
  String get teamJoinedSuccess => 'Đã tham gia đội.';

  @override
  String get invitationSentSuccess => 'Đã gửi lời mời.';

  @override
  String get invitationAcceptedSuccess => 'Đã tham gia đội.';

  @override
  String get invitationDeclinedSuccess => 'Đã từ chối lời mời.';

  @override
  String get pendingInvitationsTitle => 'Lời mời đang chờ';

  @override
  String get pendingInvitationsEmpty => 'Chưa có lời mời vào đội.';

  @override
  String get acceptInvitationButton => 'Chấp nhận';

  @override
  String get declineInvitationButton => 'Từ chối';

  @override
  String get invitationStatusPending => 'Đang chờ';

  @override
  String get invitationStatusAccepted => 'Đã chấp nhận';

  @override
  String get invitationStatusDeclined => 'Đã từ chối';

  @override
  String get teamUpdatedSuccess => 'Đã cập nhật đội.';

  @override
  String get teamLeftSuccess => 'Đã rời đội.';

  @override
  String get invalidTeamError => 'Đội không hợp lệ.';

  @override
  String get inviteUserNotFound => 'Không tìm thấy tài khoản với email này.';

  @override
  String get invitationAlreadyPending =>
      'Người này đã có lời mời đang chờ cho đội.';

  @override
  String get alreadyTeamMemberError => 'Bạn đã là thành viên của đội này.';

  @override
  String get alreadyOnEventTeamError =>
      'Bạn đã thuộc một đội khác của sự kiện này. Rời đội hiện tại trước khi tham gia đội mới.';

  @override
  String get oneTeamPerEventBadge => 'Đã có đội cho sự kiện';

  @override
  String get cannotChangeOwnRole => 'Không thể đổi vai trò của chính bạn.';

  @override
  String get leaveTeamRegistrationClosedError =>
      'Không thể rời đội sau khi đăng ký đã đóng.';

  @override
  String get invitationNoLongerPending => 'Lời mời này không còn hiệu lực.';

  @override
  String get errorEventContextRequired =>
      'Không xác định được sự kiện. Vui lòng thử lại từ màn sự kiện.';

  @override
  String get errorEventEnded =>
      'Sự kiện đã kết thúc. Không thể tạo hoặc tham gia đội.';

  @override
  String get errorRegistrationDeadlinePassed =>
      'Đã quá hạn đăng ký đội cho sự kiện này.';

  @override
  String get errorSubmissionClosed =>
      'Sự kiện đã kết thúc. Không thể nộp hoặc cập nhật bài.';

  @override
  String get errorSubmissionNotStarted =>
      'Sự kiện chưa bắt đầu. Chưa thể nộp bài.';

  @override
  String get errorJudgingNotStarted =>
      'Sự kiện chưa bắt đầu. Chưa thể chấm điểm.';

  @override
  String get errorJudgingClosed => 'Sự kiện đã kết thúc. Không thể chấm điểm.';

  @override
  String get teamInviteOnlyError =>
      'Chỉ có thể tham gia đội qua lời mời từ trưởng đội.';

  @override
  String get teamInviteOnlyBadge => 'Chỉ qua lời mời';

  @override
  String get teamInviteOnlyHelper =>
      'Liên hệ trưởng đội để nhận lời mời tham gia.';

  @override
  String get submissionsRoleGateMessage => 'Chỉ thí sinh mới có thể nộp bài.';

  @override
  String get submitScreenTitle => 'Nộp bài';

  @override
  String get submitScreenSubtitle =>
      'Gửi link GitHub, video demo và mô tả dự án cho giám khảo.';

  @override
  String get projectInfoSection => 'Thông tin dự án';

  @override
  String get linksSection => 'Liên kết';

  @override
  String get descriptionSection => 'Mô tả';

  @override
  String get projectNameLabel => 'Tên dự án';

  @override
  String get githubUrlLabel => 'Link GitHub';

  @override
  String get demoVideoUrlLabel => 'Link video demo';

  @override
  String get projectDescriptionHint => 'Dự án giải quyết vấn đề gì?';

  @override
  String get submissionDescriptionTip =>
      'Gợi ý: nêu vấn đề, giải pháp, tính năng chính, tech stack và tác động đo được.';

  @override
  String get joinTeamBeforeSubmit => 'Tạo hoặc tham gia đội trước khi nộp bài.';

  @override
  String get updateSubmissionButton => 'Cập nhật bài nộp';

  @override
  String get submitProjectAction => 'Nộp bài';

  @override
  String get needsSubmissionStatus => 'Cần nộp bài';

  @override
  String get noProjectSubmittedHelper => 'Chưa có bài nộp.';

  @override
  String get reviewedStatus => 'Đã chấm';

  @override
  String get reviewedHelper => 'Giám khảo đã công bố feedback.';

  @override
  String get submittedStatus => 'Đã nộp';

  @override
  String get submittedHelper => 'Đang chờ giám khảo chấm.';

  @override
  String get notSubmittedYet => 'Chưa nộp bài';

  @override
  String get latestSubmissionTitle => 'Bài nộp mới nhất';

  @override
  String get selectTeamToSubmit => 'Chọn hoặc tạo đội để nộp bài.';

  @override
  String get goToTeamAction => 'Đến Đội';

  @override
  String get createTeamNowAction => 'Tạo đội ngay';

  @override
  String get teamHasNoSubmission => 'Đội này chưa nộp bài.';

  @override
  String get updateHistoryTitle => 'Lịch sử cập nhật';

  @override
  String get judgeFeedbackTitle => 'Nhận xét từ giám khảo';

  @override
  String get submissionSavedNotificationTitle => 'Đã lưu bài nộp';

  @override
  String get submissionCreatedSuccess => 'Đã nộp bài.';

  @override
  String get submissionUpdatedSuccess => 'Đã cập nhật bài nộp.';

  @override
  String get submissionStatusReviewed => 'Đã chấm';

  @override
  String get submissionStatusSubmitted => 'Đã nộp';

  @override
  String get submissionStatusDraft => 'Bản nháp';

  @override
  String get submissionDraftRestored => 'Đã khôi phục bản nháp chưa gửi.';

  @override
  String get chatRoleGateMessage => 'Chat khả dụng cho thí sinh và mentor.';

  @override
  String get chatTitle => 'Chat mentor';

  @override
  String get chatSubtitle =>
      'Trao đổi với mentor được gán cho sự kiện của bạn.';

  @override
  String get chatContactLabel => 'Chat với mentor';

  @override
  String get noChatContactsMessage =>
      'Chưa có mentor được gán cho sự kiện của bạn. Liên hệ BTC để được hỗ trợ.';

  @override
  String get contactOrganizerForMentorAction => 'Sao chép tin nhắn';

  @override
  String get sendMentorRequestAction => 'Gửi yêu cầu';

  @override
  String get mentorRequestSentSuccess =>
      'Đã gửi yêu cầu gán mentor tới ban tổ chức.';

  @override
  String get contactOrganizerHint =>
      'Hãy liên hệ BTC để được gán mentor phù hợp cho sự kiện.';

  @override
  String get chatInputHint => 'Hỏi mentor...';

  @override
  String get chatRealtimeConnected => 'Tin nhắn đang cập nhật';

  @override
  String get chatRealtimeConnecting => 'Đang mở trò chuyện';

  @override
  String get chatRealtimeOffline => 'Cần tải lại tin nhắn';

  @override
  String get reloadChatTooltip => 'Tải lại cuộc trò chuyện';

  @override
  String get messageSentStatus => 'Đã gửi';

  @override
  String get sendMessageTooltip => 'Gửi';

  @override
  String get yourMessageSemantic => 'Tin nhắn của bạn';

  @override
  String get deleteMessageTitle => 'Xóa tin nhắn?';

  @override
  String get deleteMessageBody =>
      'Tin nhắn của bạn sẽ bị xóa khỏi cuộc trò chuyện.';

  @override
  String get noMessagesYet => 'Chưa có tin nhắn.';

  @override
  String get selectConversationBeforeSend =>
      'Chọn cuộc trò chuyện trước khi gửi tin nhắn.';

  @override
  String get judgeRoleGateMessage =>
      'Chỉ giám khảo mới truy cập được màn chấm điểm.';

  @override
  String get judgeTitle => 'Chấm điểm';

  @override
  String get judgeSubtitle =>
      'Chấm bài theo chất lượng giải pháp, trải nghiệm và đổi mới.';

  @override
  String get filterUnscored => 'Chưa chấm';

  @override
  String get filterScored => 'Đã chấm';

  @override
  String get judgeSearchLabel => 'Tìm bài nộp hoặc đội';

  @override
  String get noMatchingSubmissions => 'Không có bài nộp phù hợp.';

  @override
  String get showAllSubmissions => 'Hiện tất cả';

  @override
  String get selectSubmissionTitle => 'Chọn bài nộp';

  @override
  String get nextUnscoredButton => 'Bài chưa chấm tiếp theo';

  @override
  String get selectSubmissionToScore => 'Chọn một bài để chấm.';

  @override
  String get needsScoringBadge => 'Cần chấm';

  @override
  String get repositoryButton => 'Mã nguồn';

  @override
  String get demoButton => 'Video demo';

  @override
  String get rubricEvaluationTitle => 'Bảng tiêu chí';

  @override
  String get feedbackLabel => 'Nhận xét';

  @override
  String get updateScoreDialogTitle => 'Cập nhật điểm cũ?';

  @override
  String get currentScoreLabel => 'Điểm hiện tại';

  @override
  String get feedbackReady => 'Sẵn sàng';

  @override
  String get feedbackMissing => 'Thiếu';

  @override
  String get submitScoreButton => 'Gửi điểm';

  @override
  String get updateScoreButton => 'Cập nhật điểm';

  @override
  String get scoringProgressTitle => 'Tiến độ chấm';

  @override
  String get scorePublishedNotificationTitle => 'Điểm đã được công bố';

  @override
  String get scorePublishedSnackBar => 'Đã công bố điểm cho bài nộp.';

  @override
  String get scoreSavedSuccess => 'Đã lưu điểm.';

  @override
  String get judgeScoreParticipantHint =>
      'Thí sinh mở thông báo để xem điểm và nhận xét.';

  @override
  String get scoreNotificationDialogTitle => 'Kết quả chấm điểm';

  @override
  String get announcementNotificationDialogTitle => 'Thông báo từ BTC';

  @override
  String get viewSubmissionButton => 'Xem bài nộp';

  @override
  String get closeDialogButton => 'Đóng';

  @override
  String get organizerRoleGateMessage =>
      'Chỉ ban tổ chức mới truy cập được màn vận hành.';

  @override
  String get organizerTitle => 'Ban tổ chức';

  @override
  String get organizerSubtitle =>
      'Theo dõi sự kiện, tiến độ đội và trạng thái chấm điểm.';

  @override
  String get sectionOverview => 'Tổng quan';

  @override
  String get sectionOperations => 'Vận hành';

  @override
  String get sectionSubmissions => 'Bài nộp';

  @override
  String get sectionEvents => 'Sự kiện';

  @override
  String get sectionTeams => 'Đội';

  @override
  String get sendAnnouncementButton => 'Gửi thông báo';

  @override
  String get sendAnnouncementDialogTitle => 'Gửi thông báo';

  @override
  String get recipientLabel => 'Người nhận';

  @override
  String get notificationTitleLabel => 'Tiêu đề';

  @override
  String get notificationContentLabel => 'Nội dung';

  @override
  String get announcementPreviewTitle => 'Xem trước thông báo';

  @override
  String get confirmSendAnnouncementButton => 'Xác nhận gửi';

  @override
  String get announcementSendingStatus => 'Đang gửi thông báo...';

  @override
  String get recipientCountLabel => 'Số người nhận';

  @override
  String get createEventTitle => 'Tạo sự kiện';

  @override
  String get editEventTitle => 'Sửa sự kiện';

  @override
  String get eventFieldTitle => 'Tiêu đề';

  @override
  String get eventFieldDescription => 'Mô tả';

  @override
  String get eventFieldLocation => 'Địa điểm';

  @override
  String get eventFieldBannerUrl => 'Banner URL';

  @override
  String get eventFieldStartDate => 'Ngày bắt đầu';

  @override
  String get eventFieldEndDate => 'Ngày kết thúc';

  @override
  String get eventFieldRegistrationDeadline => 'Hạn đăng ký';

  @override
  String get eventFieldSubmissionDeadline => 'Hạn nộp bài';

  @override
  String get eventFieldSupportHotline => 'Hotline hỗ trợ';

  @override
  String get eventFieldOpeningHours => 'Giờ mở cửa';

  @override
  String get eventFieldMaxTeamSize => 'Số thành viên tối đa';

  @override
  String get eventFieldRules => 'Luật thi';

  @override
  String get eventFieldPrize => 'Giải thưởng';

  @override
  String get eventFieldLatitude => 'Vĩ độ';

  @override
  String get eventFieldLongitude => 'Kinh độ';

  @override
  String get selectOnMapButton => 'Chọn trên bản đồ';

  @override
  String get eventStepInfo => 'Thông tin';

  @override
  String get eventStepBanner => 'Banner';

  @override
  String get eventStepLocation => 'Địa điểm';

  @override
  String get eventStepTime => 'Thời gian';

  @override
  String get uploadBannerTooltip => 'Tải ảnh lên';

  @override
  String get uploadBannerButton => 'Tải ảnh';

  @override
  String get changeBannerButton => 'Đổi ảnh';

  @override
  String get removeBannerButton => 'Xóa ảnh';

  @override
  String get bannerUploadSuccess => 'Đã tải banner lên thành công.';

  @override
  String get uploadBannerFailed =>
      'Không thể tải ảnh lên. Vui lòng kiểm tra lại cấu hình Storage.';

  @override
  String get advancedCoordinatesTitle => 'Nâng cao: tọa độ';

  @override
  String get invalidEventDatesSnackBar =>
      'Ngày sự kiện không hợp lệ. Kiểm tra lại định dạng.';

  @override
  String get closeRegistrationTitle => 'Đóng đăng ký?';

  @override
  String get closeRegistrationSuccess => 'Đã đóng đăng ký cho sự kiện này.';

  @override
  String get recentSubmissionsTitle => 'Bài nộp mới nhất';

  @override
  String get noSubmissionsYet => 'Chưa có bài nộp.';

  @override
  String get openTeamAction => 'Mở đội';

  @override
  String get teamDetailsTitle => 'Chi tiết đội';

  @override
  String get noTeamsToView => 'Chưa có đội để xem.';

  @override
  String get leaderboardCopiedSuccess => 'Đã sao chép bảng xếp hạng.';

  @override
  String get manageUserRolesTitle => 'Quản lý vai trò người dùng';

  @override
  String get createStaffAccountTitle => 'Tạo tài khoản giám khảo/mentor';

  @override
  String get createStaffAccountButton => 'Tạo tài khoản';

  @override
  String get createStaffAccountFailed =>
      'Không thể tạo tài khoản. Kiểm tra Edge Function admin-create-user.';

  @override
  String get noUsersYet => 'Chưa có người dùng.';

  @override
  String get changeRoleDialogTitle => 'Đổi vai trò tài khoản?';

  @override
  String get exportLeaderboardTitle => 'Xuất bảng xếp hạng';

  @override
  String get userRolesTitle => 'Vai trò người dùng';

  @override
  String get userSearchLabel => 'Tìm tên hoặc email';

  @override
  String get roleFilterLabel => 'Lọc vai trò';

  @override
  String get noMatchingUsers => 'Không có tài khoản phù hợp.';

  @override
  String get manageScoreCriteriaTitle => 'Quản lý tiêu chí chấm';

  @override
  String get manageEventMentorsTitle => 'Gán mentor cho sự kiện';

  @override
  String get manageEventMentorsDescription =>
      'Chọn mentor hỗ trợ thí sinh theo từng hackathon';

  @override
  String get noEventsForMentorAssignment => 'Chưa có sự kiện để gán mentor.';

  @override
  String get noMentorsAvailableMessage =>
      'Chưa có tài khoản mentor. Tạo hoặc đổi vai trò trước.';

  @override
  String get mentorAssignmentLoadFailed =>
      'Không tải được danh sách mentor đã gán.';

  @override
  String get manageScoreCriteriaDescription =>
      'Tạo rubric riêng cho từng sự kiện';

  @override
  String get addScoreCriterionButton => 'Thêm tiêu chí';

  @override
  String get scoreCriterionLabel => 'Tên tiêu chí';

  @override
  String get scoreCriterionDescription => 'Mô tả tiêu chí';

  @override
  String get scoreCriteriaSavedSuccess => 'Đã lưu tiêu chí chấm.';

  @override
  String get defaultRubricHint =>
      'Sự kiện này đang dùng rubric mặc định. BTC có thể chỉnh và lưu để tạo rubric riêng.';

  @override
  String get useDefaultRubricButton => 'Dùng rubric mặc định';

  @override
  String get unscoredMetricLabel => 'Chưa chấm';

  @override
  String get organizerTodayTasksTitle => 'Việc cần làm hôm nay';

  @override
  String get organizerUnscoredTasksLabel => 'Bài chưa chấm';

  @override
  String get organizerTeamsNeedMembersLabel => 'Đội còn thiếu thành viên';

  @override
  String get organizerClosingSoonLabel => 'Sự kiện sắp đóng đăng ký';

  @override
  String get organizerSendReminderButton => 'Gửi nhắc';

  @override
  String get organizerAssignMentorButton => 'Gán mentor';

  @override
  String get organizerTaskUnscoredLabel => 'Nhắc chấm điểm';

  @override
  String get organizerTaskTeamsLabel => 'Nhắc ghép đội';

  @override
  String get organizerTaskClosingLabel => 'Nhắc hạn đăng ký';

  @override
  String get otherActionsTitle => 'Thao tác khác';

  @override
  String get dashboardChartTitle => 'Tổng quan chấm';

  @override
  String get scoredBarLabel => 'Đã chấm';

  @override
  String get unscoredBarLabel => 'Chưa chấm';

  @override
  String get loadMoreButton => 'Xem thêm';

  @override
  String get announcementEventLabel => 'Liên kết sự kiện (tuỳ chọn)';

  @override
  String get announcementNoEvent => 'Không gắn sự kiện';

  @override
  String get viewEventFromAnnouncementButton => 'Xem sự kiện';

  @override
  String get announcementTemplatesLabel => 'Mẫu nhanh';

  @override
  String get announcementTemplateJudgingLabel => 'Mở phòng chấm';

  @override
  String get announcementTemplateJudgingTitle => 'Mở phòng chấm điểm';

  @override
  String get announcementTemplateJudgingBody =>
      'Giám khảo vui lòng vào tab Chấm điểm. Phiên chấm điểm chính thức đã mở.';

  @override
  String get announcementTemplateDeadlineLabel => 'Hạn nộp';

  @override
  String get announcementTemplateDeadlineTitle => 'Nhắc deadline nộp bài';

  @override
  String get announcementTemplateDeadlineBody =>
      'Các đội chưa nộp bài vui lòng hoàn thiện GitHub, video demo và mô tả trước hạn nộp.';

  @override
  String get announcementTemplateKickoffLabel => 'Khai mạc';

  @override
  String get announcementTemplateKickoffTitle => 'Khai mạc hackathon';

  @override
  String get announcementTemplateKickoffBody =>
      'Chào mừng các đội tham gia SEAL Innovation Hackathon 2026. Kiểm tra Sự kiện để xem lịch trình và luật thi.';

  @override
  String get newScoreSnackBar => 'Có điểm mới. Mở thông báo để xem.';

  @override
  String get openInboxAction => 'Xem thông báo';

  @override
  String get inboxTitle => 'Thông báo';

  @override
  String get inboxSubtitle => 'Điểm số, lời mời vào đội và cập nhật hệ thống.';

  @override
  String get inboxEmpty => 'Chưa có thông báo.';

  @override
  String get reloadInboxAction => 'Nạp lại thông báo';

  @override
  String get unreadGroup => 'Chưa đọc';

  @override
  String get readGroup => 'Đã đọc';

  @override
  String get markAsReadAction => 'Đánh dấu đã đọc';

  @override
  String get deleteNotificationTitle => 'Xóa mục thông báo?';

  @override
  String get deleteNotificationBody =>
      'Mục này sẽ bị xóa khỏi danh sách thông báo.';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String get profileSubtitle =>
      'Quản lý thông tin tài khoản dùng trong các luồng vai trò.';

  @override
  String get noActiveSession => 'Chưa có phiên đăng nhập.';

  @override
  String get roleLabel => 'Vai trò';

  @override
  String get accountInfoTitle => 'Thông tin tài khoản';

  @override
  String get saveProfileButton => 'Lưu hồ sơ';

  @override
  String get profileUpdatedSuccess => 'Đã cập nhật hồ sơ.';

  @override
  String get profileSecurityTitle => 'Bảo mật';

  @override
  String get profileSecuritySubtitle =>
      'Gửi email đặt lại mật khẩu đến địa chỉ đã đăng ký. Đổi email cần liên hệ BTC.';

  @override
  String get themeModeTitle => 'Giao diện';

  @override
  String get themeModeDark => 'Tối';

  @override
  String get themeModeLight => 'Sáng';

  @override
  String get themeModeSystem => 'Hệ thống';

  @override
  String get languageTitle => 'Ngôn ngữ';

  @override
  String get languageVi => 'Tiếng Việt';

  @override
  String get languageEn => 'English';

  @override
  String get languageJa => '日本語';

  @override
  String get sessionSectionTitle => 'Phiên đăng nhập';

  @override
  String get logoutDescription =>
      'Đăng xuất sẽ xóa state cục bộ và quay về màn đăng nhập.';

  @override
  String get mapTitle => 'Địa điểm';

  @override
  String get mapSubtitle => 'Bản đồ, địa chỉ và hỗ trợ mở app chỉ đường.';

  @override
  String get noVenueYet => 'Chưa có địa điểm sự kiện.';

  @override
  String get addressLabel => 'Địa chỉ';

  @override
  String get openingHoursLabel => 'Giờ mở';

  @override
  String get hotlineLabel => 'Đường dây nóng';

  @override
  String get coordinatesLabel => 'Tọa độ';

  @override
  String get defaultOpeningHours => '08:00 - 18:00';

  @override
  String get defaultHotline => '0900 000 000';

  @override
  String get copyAddressButton => 'Sao chép địa chỉ';

  @override
  String get addressCopiedSuccess => 'Đã copy địa chỉ.';

  @override
  String get openMapsButton => 'Mở Maps';

  @override
  String get openExternalMapsTitle => 'Mở Maps bên ngoài?';

  @override
  String get openExternalMapsBody =>
      'Bạn sẽ rời SEAL Hackathon tạm thời để mở ứng dụng bản đồ.';

  @override
  String get mapPickerTitle => 'Chọn vị trí sự kiện';

  @override
  String get mapPickerInstruction =>
      'Kéo bản đồ để đặt điểm ghim vào đúng vị trí sự kiện';

  @override
  String get openMapsFailed => 'Không thể mở Maps trên thiết bị này.';

  @override
  String get validationEmailRequired => 'Nhập email.';

  @override
  String get validationEmailInvalid => 'Nhập email hợp lệ.';

  @override
  String get validationPasswordRequired => 'Nhập mật khẩu.';

  @override
  String get validationPasswordMinLength => 'Mật khẩu cần ít nhất 6 ký tự.';

  @override
  String get validationConfirmPasswordRequired => 'Nhập lại mật khẩu.';

  @override
  String get validationPasswordMismatch => 'Mật khẩu nhập lại không khớp.';

  @override
  String get validationOtpRequired => 'Nhập mã OTP từ email.';

  @override
  String get validationOtpInvalid => 'Mã OTP phải gồm 6 chữ số.';

  @override
  String get validationFullNameRequired => 'Nhập họ tên.';

  @override
  String get validationFullNameMinLength => 'Họ tên cần ít nhất 2 ký tự.';

  @override
  String get validationUniversityRequired => 'Nhập trường.';

  @override
  String get validationUniversityMinLength => 'Tên trường cần ít nhất 2 ký tự.';

  @override
  String get validationSupabaseNotReady =>
      'Không thể kết nối hệ thống. Vui lòng thử lại sau.';

  @override
  String get validationTeamNameRequired => 'Nhập tên đội.';

  @override
  String get validationTeamNameMinLength => 'Tên đội cần ít nhất 2 ký tự.';

  @override
  String get validationInviteEmailInvalid => 'Nhập email thành viên hợp lệ.';

  @override
  String get validationProjectNameRequired => 'Nhập tên dự án.';

  @override
  String get validationProjectNameMinLength => 'Tên dự án cần ít nhất 2 ký tự.';

  @override
  String get validationDescriptionRequired => 'Nhập mô tả dự án.';

  @override
  String get validationDescriptionMinLength => 'Mô tả cần ít nhất 10 ký tự.';

  @override
  String get validationJoinTeamBeforeSubmit =>
      'Tạo hoặc tham gia đội trước khi nộp bài.';

  @override
  String get eventNotLoadedForSubmit =>
      'Chưa tải được thông tin sự kiện của đội. Thử tải lại sự kiện.';

  @override
  String get validationChatMessageRequired => 'Tin nhắn không được để trống.';

  @override
  String get validationNotificationTitleRequired => 'Nhập tiêu đề thông báo.';

  @override
  String get validationNotificationBodyRequired => 'Nhập nội dung thông báo.';

  @override
  String get validationNotificationTypeInvalid =>
      'Loại thông báo không hợp lệ.';

  @override
  String get validationRecipientLabel => 'Người nhận';

  @override
  String get validationEventTitleRequired => 'Nhập tiêu đề sự kiện.';

  @override
  String get validationEventTitleMinLength =>
      'Tiêu đề sự kiện cần ít nhất 2 ký tự.';

  @override
  String get validationEventLocationRequired => 'Nhập địa điểm sự kiện.';

  @override
  String get validationEventLocationMinLength =>
      'Địa điểm cần ít nhất 2 ký tự.';

  @override
  String get validationLatitudeRequired => 'Nhập vĩ độ.';

  @override
  String get validationLatitudeInvalid => 'Vĩ độ phải là số hợp lệ.';

  @override
  String get validationLatitudeRange =>
      'Vĩ độ phải nằm trong khoảng -90 đến 90.';

  @override
  String get validationLongitudeRequired => 'Nhập kinh độ.';

  @override
  String get validationLongitudeInvalid => 'Kinh độ phải là số hợp lệ.';

  @override
  String get validationLongitudeRange =>
      'Kinh độ phải nằm trong khoảng -180 đến 180.';

  @override
  String get validationMaxTeamSizeRequired => 'Nhập số thành viên tối đa.';

  @override
  String get validationMaxTeamSizeInvalid =>
      'Số thành viên tối đa phải là số nguyên hợp lệ.';

  @override
  String get validationEndAfterStart => 'Ngày kết thúc phải sau ngày bắt đầu.';

  @override
  String get validationDeadlineBeforeEnd =>
      'Hạn đăng ký không được sau ngày kết thúc sự kiện.';

  @override
  String get validationSubmissionAfterStart =>
      'Hạn nộp bài phải sau ngày bắt đầu sự kiện.';

  @override
  String get validationSubmissionBeforeEnd =>
      'Hạn nộp bài không được sau ngày kết thúc sự kiện.';

  @override
  String get validationScoreRange => 'Điểm phải nằm trong khoảng 0 đến 10.';

  @override
  String get validationScoreCriteriaRequired =>
      'Cần ít nhất một tiêu chí chấm.';

  @override
  String get validationScoreCriteriaLimit =>
      'Tối đa 8 tiêu chí chấm cho một sự kiện.';

  @override
  String get validationScoreCriteriaLabelRequired => 'Nhập tên tiêu chí chấm.';

  @override
  String get validationScoreCriteriaDuplicate =>
      'Mã tiêu chí bị trùng. Xóa và thêm lại tiêu chí.';

  @override
  String get validationScoreCriteriaWeight =>
      'Trọng số tiêu chí phải lớn hơn 0.';

  @override
  String get validationNoSubmissionSelected => 'Chưa chọn bài nộp để chấm.';

  @override
  String get validationInvalidJudgeSession => 'Phiên giám khảo không hợp lệ.';

  @override
  String get validationFeedbackRequired =>
      'Cần nhập nhận xét trước khi gửi điểm.';

  @override
  String get validationInvalidRole => 'Vai trò không hợp lệ.';

  @override
  String get validationUserLabel => 'Người dùng';

  @override
  String get validationBannerUrlLabel => 'Banner URL';

  @override
  String get openLinkTooltip => 'Mở link để kiểm tra';

  @override
  String get openLinkFailed => 'Không thể mở link này.';

  @override
  String get openExternalLinkFailed =>
      'Không thể mở liên kết trên thiết bị này.';

  @override
  String get reloadTeamsTooltip => 'Tải lại đội';

  @override
  String get reloadJudgeQueueTooltip => 'Tải lại bài chưa chấm';

  @override
  String get reloadDashboardTooltip => 'Tải lại tổng quan';

  @override
  String get judgePreviewOnlyMessage =>
      'Đăng nhập bằng tài khoản Giám khảo để gửi điểm chính thức.';

  @override
  String get judgeQueueSortLabel => 'Sắp xếp bài chưa chấm';

  @override
  String get sortNewestFirst => 'Mới nhất trước';

  @override
  String get sortProjectName => 'Tên dự án';

  @override
  String get sortTeamName => 'Đội';

  @override
  String get sortAverageScore => 'Điểm trung bình';

  @override
  String get judgeSubmissionToScoreLabel => 'Bài cần chấm';

  @override
  String get unknownTeamLabel => 'Chưa rõ đội';

  @override
  String get teamNotLoadedYet => 'Chưa tải đội';

  @override
  String get eventNotLoadedYet => 'Chưa tải sự kiện';

  @override
  String get averageScoreAbbrev => 'TB';

  @override
  String get judgeReviewReminder =>
      'Xem mã nguồn, chất lượng demo, độ sâu triển khai và tác động sản phẩm trước khi gửi điểm.';

  @override
  String get rubricTechnicalLabel => 'Chất lượng giải pháp';

  @override
  String get rubricTechnicalDescription =>
      'Kiến trúc, độ đúng, độ tin cậy và độ sâu triển khai.';

  @override
  String get rubricUiLabel => 'Trải nghiệm người dùng';

  @override
  String get rubricUiDescription =>
      'Luồng di động, độ rõ ràng, khả năng tiếp cận và độ hoàn thiện.';

  @override
  String get rubricInnovationLabel => 'Đổi mới';

  @override
  String get rubricInnovationDescription =>
      'Tính mới, tác động, AI/automation hữu ích và độ phù hợp sản phẩm.';

  @override
  String get decreaseScoreTooltip => 'Giảm';

  @override
  String get increaseScoreTooltip => 'Tăng';

  @override
  String get editEventMenuItem => 'Sửa sự kiện';

  @override
  String get closeRegistrationMenuItem => 'Đóng đăng ký';

  @override
  String get closeRegistrationConfirmButton => 'Đóng đăng ký';

  @override
  String get notificationActionsTooltip => 'Tùy chọn thông báo';

  @override
  String get eventActionsTooltip => 'Thao tác sự kiện';

  @override
  String get submissionsMetricLabel => 'Bài nộp';

  @override
  String get scoresMetricLabel => 'Số lượt chấm';

  @override
  String get systemStatusTitle => 'Trạng thái hệ thống';

  @override
  String get systemStatusSubtitle => 'Theo dõi trạng thái dữ liệu và cập nhật.';

  @override
  String get chatSuggestionSubmission => 'Hỏi về bài nộp';

  @override
  String get chatSuggestionGithub => 'Xem giúp GitHub link';

  @override
  String get chatSuggestionChecklist => 'Checklist nộp bài';

  @override
  String get emailPrefix => 'Email:';

  @override
  String get averageScoreTitle => 'Điểm trung bình';

  @override
  String get judgeQueueTitle => 'Theo dõi bài chưa chấm';

  @override
  String get judgeQueueWaitingSuffix => ' bài chưa chấm';

  @override
  String get exportLeaderboardDescription =>
      'Copy dữ liệu xếp hạng vào clipboard';

  @override
  String get userRolesDescription => 'Xem và cập nhật vai trò tài khoản';

  @override
  String get databaseConnectedLabel => 'Dữ liệu sẵn sàng';

  @override
  String get databaseMissingLabel => 'Chưa có dữ liệu';

  @override
  String get operationsDataLabel => 'Dữ liệu vận hành';

  @override
  String get syncingLabel => 'Đang cập nhật';

  @override
  String get stateReadyLabel => 'Đã sẵn sàng';

  @override
  String get notLoggedInShortLabel => 'Chưa đăng nhập';

  @override
  String get noApiErrorsLabel => 'Không có lỗi tải dữ liệu';

  @override
  String get systemStatusSemanticLabel => 'Trạng thái vận hành hệ thống';

  @override
  String get profileFullNameFieldSemantic => 'Ô nhập họ tên hồ sơ';

  @override
  String get profileUniversityFieldSemantic => 'Ô nhập trường';

  @override
  String get errorInvalidCredentials =>
      'Email hoặc mật khẩu không đúng. Hãy dùng đúng email đã đăng ký hoặc bấm \"Tạo tài khoản mới\".';

  @override
  String get errorEmailNotConfirmed =>
      'Email chưa được xác nhận. Kiểm tra hộp thư đến hoặc thư rác.';

  @override
  String get errorInvalidOtp =>
      'Mã OTP không hợp lệ hoặc đã hết hạn. Yêu cầu gửi lại email kích hoạt.';

  @override
  String get errorConnectionTimeout =>
      'Kết nối quá lâu. Kiểm tra mạng rồi thử lại.';

  @override
  String get errorRlsPermissionDenied =>
      'Tài khoản hiện tại không có quyền thực hiện thao tác này.';

  @override
  String get errorDuplicateRecord =>
      'Dữ liệu này đã tồn tại. Tải lại màn hình rồi cập nhật bản ghi hiện có.';

  @override
  String get errorCheckConstraint =>
      'Dữ liệu chưa hợp lệ. Kiểm tra lại thông tin rồi thử lại.';

  @override
  String get otpHelpText =>
      'Mã OTP nằm trong email kích hoạt. Kiểm tra hộp thư đến hoặc thư rác nếu chưa thấy email.';

  @override
  String teamOverviewForEvent(String title) {
    return 'Đội — $title';
  }

  @override
  String scopedTeamsAvailable(int count) {
    return '$count đội trong sự kiện này';
  }

  @override
  String pendingInvitationsCount(int count) {
    return '$count lời mời đang chờ phản hồi';
  }

  @override
  String eventScheduleHours(String start, String end) {
    return '$start - $end';
  }

  @override
  String activationEmailSent(String email) {
    return 'Đã gửi email kích hoạt tới $email. Nhập mã OTP 6 số trong email bên dưới.';
  }

  @override
  String emailActivatedWelcome(String email) {
    return 'Email đã được kích hoạt. Chào mừng $email!';
  }

  @override
  String passwordResetEmailSent(String email) {
    return 'Đã gửi link đặt lại mật khẩu tới $email. Kiểm tra hộp thư đến hoặc thư rác.';
  }

  @override
  String registerSuccess(String email) {
    return 'Đăng ký thành công với $email.';
  }

  @override
  String organizerFocusEventSubtitle(String title) {
    return 'Đang lọc theo $title.';
  }

  @override
  String submissionEventLabel(String title) {
    return 'Sự kiện: $title';
  }

  @override
  String judgeQueueForEventTitle(String title) {
    return 'Chấm điểm: $title';
  }

  @override
  String openEventSemanticLabel(String title) {
    return 'Mở sự kiện $title';
  }

  @override
  String registerBeforeDate(String date) {
    return 'Đăng ký trước $date';
  }

  @override
  String registrationClosedByDate(String date) {
    return 'Đóng đăng ký $date';
  }

  @override
  String registrationOpenUntilDate(String date) {
    return 'Mở đăng ký đến $date';
  }

  @override
  String maxMembersChip(int count) {
    return 'Tối đa $count thành viên';
  }

  @override
  String leaderPrefix(String name) {
    return 'Trưởng đội: $name';
  }

  @override
  String memberCountLabel(int count) {
    return '$count thành viên';
  }

  @override
  String teamSemanticLabel(String name, String memberCount, String leader) {
    return 'Đội $name, $memberCount thành viên, Trưởng đội: $leader';
  }

  @override
  String inviteTeamPrefix(String name) {
    return 'Đội: $name';
  }

  @override
  String leaveTeamDialogBody(String teamName) {
    return 'Bạn sẽ rời $teamName. Sau hạn đăng ký, bạn không thể vào lại đội.';
  }

  @override
  String teamInvitationBody(String teamName) {
    return 'Bạn được mời vào $teamName. Mở màn hình Đội để xem và tham gia nếu còn chỗ.';
  }

  @override
  String invitedByLabel(String name) {
    return 'Người mời: $name';
  }

  @override
  String teamCreatedNotificationBody(String teamName, String eventTitle) {
    return '$teamName đã tham gia $eventTitle.';
  }

  @override
  String alreadyOnEventTeamNamedError(String teamName) {
    return 'Bạn đã thuộc đội $teamName cho sự kiện này.';
  }

  @override
  String teamFullForEventError(String teamName) {
    return '$teamName đã đủ thành viên cho sự kiện này.';
  }

  @override
  String submissionSavedNotificationBody(String projectName) {
    return '$projectName đã được nộp thành công.';
  }

  @override
  String chatEventScopedSubtitle(String eventTitle) {
    return 'Cuộc trò chuyện cho sự kiện $eventTitle';
  }

  @override
  String mentorRequestNotificationTitle(String participantName) {
    return 'Yêu cầu mentor: $participantName';
  }

  @override
  String todayTimestamp(String time) {
    return 'Hôm nay, $time';
  }

  @override
  String scoreOutOfTenLabel(String score) {
    return '$score/10';
  }

  @override
  String scoreWeightLabel(String weight) {
    return 'Trọng số x$weight';
  }

  @override
  String updateScoreDialogBody(String projectName) {
    return 'Điểm trước đó của bạn cho $projectName sẽ được thay thế.';
  }

  @override
  String closeRegistrationBody(String title) {
    return 'Hạn đăng ký của $title sẽ được đặt về thời điểm hiện tại.';
  }

  @override
  String announcementSentSuccess(int count) {
    return 'Đã gửi thông báo cho $count người dùng.';
  }

  @override
  String announcementRolePreview(String role) {
    return 'Gửi tới: $role';
  }

  @override
  String recipientCountValue(int count) {
    return '$count tài khoản';
  }

  @override
  String changeRoleDialogBody(String name, String role) {
    return 'Gán $name thành $role.';
  }

  @override
  String roleUpdatedSuccess(String name) {
    return 'Đã cập nhật vai trò $name.';
  }

  @override
  String cannotChangeOwnRoleSubtitle(String email) {
    return '$email\nKhông thể đổi vai trò của chính bạn.';
  }

  @override
  String sendPasswordResetTo(String email) {
    return 'Gửi link đặt lại mật khẩu đến $email';
  }

  @override
  String mapPickerCoordinates(String latitude, String longitude) {
    return 'Tọa độ: $latitude, $longitude';
  }

  @override
  String coordinatesPreview(String latitude, String longitude) {
    return '$latitude, $longitude';
  }

  @override
  String staffAccountCreatedSuccess(String name) {
    return 'Đã tạo tài khoản cho $name.';
  }

  @override
  String mentorAssignmentSavedSuccess(int count) {
    return 'Đã gán $count mentor cho sự kiện.';
  }

  @override
  String organizerTaskUnscoredTitle(String eventTitle) {
    return 'Nhắc giám khảo chấm — $eventTitle';
  }

  @override
  String organizerTaskUnscoredBody(int count) {
    return 'Còn $count bài chưa chấm. Vui lòng hoàn tất chấm điểm trong hôm nay.';
  }

  @override
  String organizerTaskTeamsTitle(String eventTitle) {
    return 'Nhắc tham gia đội — $eventTitle';
  }

  @override
  String organizerTaskTeamsBody(int count) {
    return 'Còn $count đội chưa đủ thành viên. Mời thí sinh ghép đội trước hạn.';
  }

  @override
  String organizerTaskClosingTitle(String eventTitle) {
    return 'Sắp đóng đăng ký — $eventTitle';
  }

  @override
  String organizerTaskClosingBody(int count) {
    return 'Có $count sự kiện sắp đóng đăng ký trong 3 ngày tới. Hoàn tất đăng ký sớm.';
  }

  @override
  String organizerNotificationSuggestions(int count) {
    return '$count thông báo nên gửi';
  }

  @override
  String journeyScoreSummary(String score) {
    return 'Điểm trung bình: $score';
  }

  @override
  String submissionDraftSavedAt(String time) {
    return 'Bản nháp lưu lúc $time';
  }

  @override
  String validationSearchMaxLength(int max) {
    return 'Từ khóa tìm kiếm tối đa $max ký tự.';
  }

  @override
  String validationInvalidUser(String label) {
    return '$label không hợp lệ.';
  }

  @override
  String validationFieldRequired(String label) {
    return 'Nhập $label.';
  }

  @override
  String validationInvalidUrl(String label) {
    return '$label phải là URL http/https hợp lệ.';
  }

  @override
  String validationTeamNameMaxLength(int max) {
    return 'Tên đội tối đa $max ký tự.';
  }

  @override
  String validationProjectNameMaxLength(int max) {
    return 'Tên dự án tối đa $max ký tự.';
  }

  @override
  String validationDescriptionMaxLength(int max) {
    return 'Mô tả tối đa $max ký tự.';
  }

  @override
  String validationChatMessageMaxLength(int max) {
    return 'Tin nhắn tối đa $max ký tự.';
  }

  @override
  String validationNotificationTitleMaxLength(int max) {
    return 'Tiêu đề tối đa $max ký tự.';
  }

  @override
  String validationNotificationBodyMaxLength(int max) {
    return 'Nội dung tối đa $max ký tự.';
  }

  @override
  String validationFeedbackMaxLength(int max) {
    return 'Nhận xét tối đa $max ký tự.';
  }

  @override
  String validationMaxTeamSizeRange(int min, int max) {
    return 'Số thành viên tối đa phải từ $min đến $max.';
  }

  @override
  String validationDateTimeFormat(String label, String format) {
    return '$label phải theo định dạng $format (vd: 2026-06-15 09:00).';
  }

  @override
  String submissionQueueCountLabel(int count) {
    return '$count bài trong hàng chờ này';
  }

  @override
  String scoreCountLabel(int count) {
    return '$count lượt chấm';
  }

  @override
  String scoringProgressSemantic(int scored, int unscored) {
    return 'Tiến độ chấm: $scored đã chấm và $unscored chưa chấm';
  }

  @override
  String memberCountWithLimit(int current, int limit) {
    return '$current/$limit thành viên';
  }

  @override
  String apiErrorCountLabel(int count) {
    return '$count lỗi';
  }

  @override
  String judgeQueueWaitingLabel(int count) {
    return '$count bài chưa chấm';
  }

  @override
  String scoreSliderSemantic(String label, String value, String description) {
    return '$label $value điểm. $description';
  }

  @override
  String messageTimestampSemantic(String senderLabel, String time) {
    return '$senderLabel lúc $time';
  }
}
