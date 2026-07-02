class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'SEAL Hackathon';

  // Common actions
  static const String cancelButton = 'Hủy';
  static const String saveButton = 'Lưu';
  static const String deleteButton = 'Xóa';
  static const String sendButton = 'Gửi';
  static const String doneButton = 'Xong';
  static const String resetButton = 'Reset';
  static const String updateButton = 'Cập nhật';
  static const String retryButton = 'Thử lại';
  static const String stayButton = 'Ở lại';
  static const String confirmButton = 'Xác nhận';
  static const String confirmDelete = 'Bạn có chắc chắn muốn xóa?';
  static const String detailsButton = 'Chi tiết';
  static const String editButton = 'Sửa';
  static const String inviteButton = 'Mời';
  static const String allFilter = 'Tất cả';
  static const String sortLabel = 'Sắp xếp';
  static const String unknownLabel = 'Chưa rõ';
  static const String leaderBadge = 'Leader';
  static const String meLabel = 'Tôi';

  // Common status
  static const String statusActive = 'Đang mở';
  static const String statusUpcoming = 'Sắp diễn ra';
  static const String statusClosed = 'Đã đóng';
  static const String filterRegistrationOpen = 'Còn đăng ký';

  // Common access / session
  static const String networkOfflineMessage =
      'Không có kết nối mạng. Kiểm tra mạng rồi thử lại.';
  static const String networkError = 'Không thể kết nối máy chủ';
  static const String unknownError = 'Đã có lỗi xảy ra';
  static const String accessDeniedTitle = 'Không có quyền truy cập';
  static const String accessDeniedSubtitle =
      'Tính năng này không khả dụng với vai trò hiện tại.';
  static const String accessDeniedDefaultMessage =
      'Vui lòng đăng nhập bằng tài khoản phù hợp.';
  static const String backToEventsButton = 'Về sự kiện';
  static const String loginRequiredTitle = 'Vui lòng đăng nhập';
  static const String loginRequiredSubtitle =
      'Đăng nhập để tiếp tục sử dụng SEAL Hackathon.';
  static const String goToLoginButton = 'Đến màn hình đăng nhập';
  static const String supabaseRequiredTitle = 'Không thể kết nối hệ thống';
  static const String supabaseRequiredBody =
      'Ứng dụng chưa sẵn sàng để tải dữ liệu. Vui lòng thử lại sau hoặc liên hệ ban tổ chức.';
  static const String notLoggedInMessage = 'Bạn chưa đăng nhập.';
  static const String logoutFailedMessage = 'Không thể đăng xuất. Thử lại.';

  // Common success
  static const String saveSuccess = 'Lưu dữ liệu thành công';
  static const String updateSuccess = 'Cập nhật thành công';
  static const String deleteSuccess = 'Xóa dữ liệu thành công';

  // Roles
  static const String roleParticipant = 'Thí sinh';
  static const String roleJudge = 'Giám khảo';
  static const String roleMentor = 'Mentor';
  static const String roleOrganizer = 'Ban tổ chức';

  // Navigation
  static const String eventsNavLabel = 'Sự kiện';
  static const String teamNavLabel = 'Đội';
  static const String submitNavLabel = 'Nộp bài';
  static const String judgeNavLabel = 'Chấm điểm';
  static const String dashboardNavLabel = 'Tổng quan';
  static const String chatNavLabel = 'Chat';
  static const String mapNavLabel = 'Bản đồ';
  static const String profileNavLabel = 'Hồ sơ';
  static const String notificationsNavLabel = 'Thông báo';
  static const String accountMenuTooltip = 'Tài khoản';
  static const String logoutButton = 'Đăng xuất';
  static const String helpTooltip = 'Hỗ trợ';
  static const String helpDialogTitle = 'Cần hỗ trợ?';
  static const String helpDialogBody =
      'Liên hệ ban tổ chức tại quầy hỗ trợ hoặc gửi tin nhắn trong mục Chat.';

  // Auth
  static const String loginTitle = 'Đăng nhập';
  static const String registerTitle = 'Tạo tài khoản';
  static const String verifyEmailTitle = 'Kích hoạt email';
  static const String loginHeroSubtitle =
      'Quản lý sự kiện, đội, bài nộp, chấm điểm, tin nhắn và địa điểm trong một ứng dụng di động.';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Mật khẩu';
  static const String confirmPasswordLabel = 'Nhập lại mật khẩu';
  static const String fullNameLabel = 'Họ tên';
  static const String universityLabel = 'Trường';
  static const String otpLabel = 'Mã OTP (6 số)';
  static String get otpHelpText =>
      'Mã OTP nằm trong email kích hoạt. Kiểm tra hộp thư đến hoặc thư rác nếu chưa thấy email.';
  static const String registerRoleHint =
      'Tài khoản mới được tạo với vai trò Thí sinh. Sau đăng ký cần kích hoạt email bằng OTP hoặc link.';
  static const String roleManagedHint =
      'Vai trò được quản lý theo hồ sơ tài khoản.';
  static const String forgotPasswordButton = 'Quên mật khẩu?';
  static const String hidePasswordTooltip = 'Ẩn mật khẩu';
  static const String showPasswordTooltip = 'Hiện mật khẩu';
  static const String loginButton = 'Đăng nhập';
  static const String registerButton = 'Đăng ký';
  static const String confirmOtpButton = 'Xác nhận OTP';
  static const String backToLoginButton = 'Quay lại đăng nhập';
  static const String haveAccountButton = 'Tôi đã có tài khoản';
  static const String createAccountButton = 'Tạo tài khoản mới';
  static const String loginSuccess = 'Đăng nhập thành công';
  static const String loginFailed = 'Sai tên đăng nhập hoặc mật khẩu';
  static const String emailConfirmedWelcomeBack =
      'Email đã được xác nhận. Chào mừng bạn quay lại!';
  static const String noPendingVerificationEmail =
      'Không có email đang chờ xác nhận.';
  static const String registerSuccessPrefix = 'Đăng ký thành công với';

  static String activationEmailSent(String email) =>
      'Đã gửi email kích hoạt tới $email. '
      'Mở link trong email hoặc nhập mã OTP 6 số bên dưới.';

  static String emailActivatedWelcome(String email) =>
      'Email đã được kích hoạt. Chào mừng $email!';

  static String passwordResetEmailSent(String email) =>
      'Đã gửi link đặt lại mật khẩu tới $email. Kiểm tra hộp thư đến hoặc thư rác.';

  static String registerSuccess(String email) =>
      '$registerSuccessPrefix $email.';

  // Events
  static const String eventsTitle = 'Sự kiện';
  static const String eventsSubtitle =
      'Theo dõi hackathon, deadline và thông tin chi tiết.';
  static const String eventSearchHint = 'Tìm theo tên, địa điểm hoặc chủ đề';
  static const String sortStartAsc = 'Ngày bắt đầu: sớm nhất';
  static const String sortStartDesc = 'Ngày bắt đầu: muộn nhất';
  static const String sortTitleAsc = 'Tên A → Z';
  static const String sortTitleDesc = 'Tên Z → A';
  static const String sortDeadlineAsc = 'Hạn nộp: gần nhất';
  static const String sortDeadlineDesc = 'Hạn nộp: xa nhất';
  static const String noMatchingEvents = 'Không có sự kiện phù hợp.';
  static const String noEventsYet = 'Chưa có sự kiện.';
  static const String clearSearchAction = 'Xóa tìm kiếm';
  static const String reloadEventsAction = 'Tải lại sự kiện';
  static const String registerTeamPill = 'Đăng ký đội';
  static const String registrationClosedPill = 'Đăng ký đã đóng';
  static const String eventDetailTitle = 'Chi tiết sự kiện';
  static const String eventDetailSubtitle =
      'Timeline, luật thi, địa điểm và bảng xếp hạng.';
  static const String eventDetailLoadingSubtitle =
      'Đang tải thông tin hackathon từ hệ thống.';
  static const String eventNotFound = 'Không tìm thấy sự kiện.';
  static const String rulesTitle = 'Luật thi';
  static const String prizeTitle = 'Giải thưởng';
  static const String leaderboardTitle = 'Bảng xếp hạng';
  static const String noScoredSubmissionsYet = 'Chưa có bài nào được chấm.';
  static const String noSubmissionsForEventYet =
      'Chưa có bài nộp cho sự kiện này.';
  static const String eventDetailStatsTitle = 'Tổng quan sự kiện';
  static const String eventTeamsMetric = 'Đội';
  static const String eventSubmissionsMetric = 'Bài nộp';
  static const String eventUnscoredMetric = 'Chưa chấm';
  static String organizerFocusEventSubtitle(String title) =>
      'Đang lọc theo $title.';
  static const String organizerShowAllEventsButton = 'Xem tất cả sự kiện';
  static String submissionEventLabel(String title) => 'Sự kiện: $title';
  static const String timelineTitle = 'Timeline';
  static const String timelineRegistration = 'Đăng ký';
  static const String timelineKickoff = 'Kickoff';
  static const String timelineFinal = 'Chung kết';
  static const String openJudgeQueueButton = 'Mở hàng chờ chấm';
  static const String openOrganizerDashboardButton = 'Mở tổng quan ban tổ chức';
  static const String openMentorChatButton = 'Mở chat mentor';
  static const String manageTeamButton = 'Tạo hoặc quản lý đội';
  static const String viewMyTeamButton = 'Xem đội của tôi';
  static const String joinOrCreateTeamButton = 'Tạo hoặc tham gia đội';
  static const String submitForEventButton = 'Nộp bài cho sự kiện này';
  static const String myTeamForEventTitle = 'Đội của bạn';
  static const String leaderboardPendingTitle = 'Chờ chấm';
  static const String awaitingScoreBadge = 'Chờ điểm';
  static const String judgeQueueFilteredSubtitle =
      'Hàng chờ chấm điểm cho sự kiện đang chọn.';
  static String judgeQueueForEventTitle(String title) => 'Chấm điểm: $title';
  static const String viewVenueButton = 'Xem địa điểm';
  static const String eventCreatedSuccess = 'Đã tạo sự kiện.';
  static const String eventUpdatedSuccess = 'Đã cập nhật sự kiện.';

  static String openEventSemanticLabel(String title) => 'Mở sự kiện $title';
  static String registerBeforeDate(String date) => 'Đăng ký trước $date';
  static String registrationClosedByDate(String date) => 'Đóng đăng ký $date';
  static String registrationOpenUntilDate(String date) =>
      'Mở đăng ký đến $date';
  static String maxMembersChip(int count) => 'Tối đa $count thành viên';

  // Teams
  static const String teamTitle = 'Đội';
  static const String teamSubtitle =
      'Tạo đội, mời thành viên và quản lý tham gia.';
  static const String teamOverviewTitle = 'Tổng quan đội';
  static const String noTeamsYet = 'Chưa có đội';
  static const String teamsAvailable = 'Đội đang có';
  static const String checkInLabel = 'Check-in';
  static const String checkInPending = 'Chờ';
  static const String checkInConfirmed = 'Đã xác nhận';
  static const String submitProjectButton = 'Nộp project';
  static const String createTeamButton = 'Tạo đội';
  static const String createTeamTitle = 'Tạo đội';
  static const String eventLabel = 'Sự kiện';
  static const String teamNameLabel = 'Tên đội';
  static const String loadEventsBeforeCreateTeam =
      'Chưa có sự kiện. Tải sự kiện trước khi tạo đội.';
  static const String roleViewOnlyTeams =
      'Vai trò này chỉ xem đội, không tạo đội thí sinh.';
  static const String emptyTeamsMessage = 'Chưa có đội. Tạo đội để tiếp tục.';
  static const String myTeamsGroup = 'Đội của tôi';
  static const String otherTeamsGroup = 'Đội khác';
  static const String teamFullBadge = 'Đội đã đầy';
  static const String updateTeamDialogTitle = 'Cập nhật đội';
  static const String leaveTeamDialogTitle = 'Rời đội?';
  static const String leaveTeamButton = 'Rời đội';
  static const String joinTeamButton = 'Tham gia đội';
  static const String inviteMemberTitle = 'Mời thành viên';
  static const String memberEmailLabel = 'Email thành viên';
  static const String sendInvitationButton = 'Gửi lời mời';
  static const String teamInvitationTitle = 'Lời mời vào đội';
  static const String teamCreatedNotificationTitle = 'Đã tạo đội';
  static const String teamCreatedSuccess = 'Đã tạo đội.';
  static const String teamJoinedSuccess = 'Đã tham gia đội.';
  static const String invitationSentSuccess = 'Đã gửi lời mời.';
  static const String invitationAcceptedSuccess = 'Đã tham gia đội.';
  static const String invitationDeclinedSuccess = 'Đã từ chối lời mời.';
  static const String pendingInvitationsTitle = 'Lời mời đang chờ';
  static const String pendingInvitationsEmpty = 'Chưa có lời mời vào đội.';
  static const String acceptInvitationButton = 'Chấp nhận';
  static const String declineInvitationButton = 'Từ chối';
  static const String invitationStatusPending = 'Đang chờ';
  static const String invitationStatusAccepted = 'Đã chấp nhận';
  static const String invitationStatusDeclined = 'Đã từ chối';
  static const String teamUpdatedSuccess = 'Đã cập nhật đội.';
  static const String teamLeftSuccess = 'Đã rời đội.';
  static const String invalidTeamError = 'Đội không hợp lệ.';
  static const String inviteUserNotFound =
      'Không tìm thấy tài khoản với email này.';
  static const String invitationAlreadyPending =
      'Người này đã có lời mời đang chờ cho đội.';
  static const String alreadyTeamMemberError =
      'Bạn đã là thành viên của đội này.';
  static const String alreadyOnEventTeamError =
      'Bạn đã thuộc một đội khác của sự kiện này. Rời đội hiện tại trước khi tham gia đội mới.';
  static const String oneTeamPerEventBadge = 'Đã có đội cho sự kiện';
  static String alreadyOnEventTeamNamedError(String teamName) =>
      'Bạn đã thuộc đội $teamName cho sự kiện này.';
  static const String cannotChangeOwnRole =
      'Không thể đổi vai trò của chính bạn.';

  static String leaderPrefix(String name) => 'Leader: $name';
  static String memberCountLabel(int count) => '$count thành viên';
  static String inviteTeamPrefix(String name) => 'Đội: $name';
  static String leaveTeamDialogBody(String teamName) => 'Bạn sẽ rời $teamName.';
  static String teamInvitationBody(String teamName) =>
      'Bạn được mời vào $teamName. Mở màn hình Đội để xem và tham gia nếu còn chỗ.';
  static String invitedByLabel(String name) => 'Người mời: $name';
  static String teamCreatedNotificationBody(
    String teamName,
    String eventTitle,
  ) => '$teamName đã tham gia $eventTitle.';
  static String teamFullForEventError(String teamName) =>
      '$teamName đã đủ thành viên cho sự kiện này.';
  static const String errorEventEnded =
      'Sự kiện đã kết thúc. Không thể tạo hoặc tham gia đội.';
  static const String errorRegistrationDeadlinePassed =
      'Đã quá hạn đăng ký đội cho sự kiện này.';
  static const String errorSubmissionClosed =
      'Sự kiện đã kết thúc. Không thể nộp hoặc cập nhật bài.';
  static const String errorJudgingNotStarted =
      'Sự kiện chưa bắt đầu. Chưa thể chấm điểm.';

  // Submissions
  static const String submissionsRoleGateMessage =
      'Chỉ thí sinh mới có thể nộp project.';
  static const String submitScreenTitle = 'Nộp bài';
  static const String submitScreenSubtitle =
      'Gửi GitHub, video demo và mô tả dự án cho giám khảo.';
  static const String projectInfoSection = 'Thông tin project';
  static const String linksSection = 'Links';
  static const String descriptionSection = 'Mô tả';
  static const String projectNameLabel = 'Tên project';
  static const String githubUrlLabel = 'GitHub URL';
  static const String demoVideoUrlLabel = 'Link video demo';
  static const String projectDescriptionHint = 'Dự án giải quyết vấn đề gì?';
  static const String submissionDescriptionTip =
      'Gợi ý: nêu vấn đề, giải pháp, tính năng chính, tech stack và tác động đo được.';
  static const String joinTeamBeforeSubmit =
      'Tạo hoặc tham gia đội trước khi nộp bài.';
  static const String updateSubmissionButton = 'Cập nhật bài nộp';
  static const String submitProjectAction = 'Nộp project';
  static const String needsSubmissionStatus = 'Cần nộp bài';
  static const String noProjectSubmittedHelper = 'Chưa có project được nộp.';
  static const String reviewedStatus = 'Đã chấm';
  static const String reviewedHelper = 'Giám khảo đã công bố feedback.';
  static const String submittedStatus = 'Đã nộp';
  static const String submittedHelper = 'Đang chờ giám khảo chấm.';
  static const String notSubmittedYet = 'Chưa nộp project';
  static const String latestSubmissionTitle = 'Bài nộp mới nhất';
  static const String selectTeamToSubmit = 'Chọn hoặc tạo đội để nộp project.';
  static const String goToTeamAction = 'Đến Đội';
  static const String teamHasNoSubmission = 'Đội này chưa nộp project.';
  static const String updateHistoryTitle = 'Lịch sử cập nhật';
  static const String judgeFeedbackTitle = 'Nhận xét từ giám khảo';
  static const String submissionSavedNotificationTitle = 'Đã lưu bài nộp';
  static const String submissionCreatedSuccess = 'Đã nộp project.';
  static const String submissionUpdatedSuccess = 'Đã cập nhật bài nộp.';
  static const String submissionStatusReviewed = 'Đã chấm';
  static const String submissionStatusSubmitted = 'Đã nộp';
  static const String submissionStatusDraft = 'Bản nháp';

  static String submissionSavedNotificationBody(String projectName) =>
      '$projectName đã được nộp thành công.';

  // Chat
  static const String chatRoleGateMessage =
      'Chat khả dụng cho thí sinh, mentor và ban tổ chức.';
  static const String chatTitle = 'Chat mentor';
  static const String chatSubtitle =
      'Trao đổi với mentor và ban tổ chức trong cuộc thi.';
  static const String chatContactLabel = 'Chat với mentor / ban tổ chức';
  static const String noChatContactsMessage =
      'Chưa có tài khoản mentor hoặc ban tổ chức để chat.';
  static const String chatInputHint = 'Hỏi mentor...';
  static const String sendMessageTooltip = 'Gửi';
  static const String yourMessageSemantic = 'Tin nhắn của bạn';
  static const String deleteMessageTitle = 'Xóa tin nhắn?';
  static const String deleteMessageBody =
      'Tin nhắn của bạn sẽ bị xóa khỏi cuộc trò chuyện.';
  static const String noMessagesYet = 'Chưa có tin nhắn.';
  static const String selectConversationBeforeSend =
      'Chọn cuộc trò chuyện trước khi gửi tin nhắn.';

  static String todayTimestamp(String time) => 'Hôm nay, $time';

  // Judge
  static const String judgeRoleGateMessage =
      'Chỉ giám khảo và ban tổ chức mới truy cập được chấm điểm.';
  static const String judgeTitle = 'Chấm điểm';
  static const String judgeSubtitle =
      'Chấm bài theo tiêu chí kỹ thuật, trải nghiệm người dùng và đổi mới.';
  static const String filterUnscored = 'Chưa chấm';
  static const String filterScored = 'Đã chấm';
  static const String judgeSearchLabel = 'Tìm bài nộp hoặc đội';
  static const String noMatchingSubmissions = 'Không có bài nộp phù hợp.';
  static const String showAllSubmissions = 'Hiện tất cả';
  static const String selectSubmissionTitle = 'Chọn bài nộp';
  static const String nextUnscoredButton = 'Bài chưa chấm tiếp theo';
  static const String selectSubmissionToScore = 'Chọn một bài để chấm.';
  static const String needsScoringBadge = 'Cần chấm';
  static const String repositoryButton = 'Mã nguồn';
  static const String demoButton = 'Video demo';
  static const String rubricEvaluationTitle = 'Bảng tiêu chí';
  static const String feedbackLabel = 'Nhận xét';
  static const String updateScoreDialogTitle = 'Cập nhật điểm cũ?';
  static const String currentScoreLabel = 'Điểm hiện tại';
  static const String feedbackReady = 'Sẵn sàng';
  static const String feedbackMissing = 'Thiếu';
  static const String submitScoreButton = 'Gửi điểm';
  static const String updateScoreButton = 'Cập nhật điểm';
  static const String scoringProgressTitle = 'Tiến độ chấm';
  static const String scorePublishedNotificationTitle = 'Đã công bố điểm';
  static const String scorePublishedSnackBar = 'Đã công bố điểm.';
  static const String scoreSavedSuccess = 'Đã lưu điểm.';
  static const String judgeScoreParticipantHint =
      'Thí sinh mở icon chuông để xem điểm và nhận xét.';
  static const String scoreNotificationDialogTitle = 'Kết quả chấm điểm';
  static const String announcementNotificationDialogTitle = 'Thông báo từ BTC';
  static const String viewSubmissionButton = 'Xem bài nộp';
  static const String closeDialogButton = 'Đóng';

  static String updateScoreDialogBody(String projectName) =>
      'Điểm trước đó của bạn cho $projectName sẽ được thay thế.';
  static String scorePublishedNotificationBody(
    String projectName, {
    double? average,
    String? feedback,
  }) {
    final buffer = StringBuffer('$projectName có điểm mới');
    if (average != null) {
      buffer.write(': ${average.toStringAsFixed(1)} điểm');
    }
    if (feedback != null && feedback.trim().isNotEmpty) {
      buffer.write('. Nhận xét: ${feedback.trim()}');
    }
    buffer.write('.');
    return buffer.toString();
  }

  // Organizer
  static const String organizerRoleGateMessage =
      'Chỉ ban tổ chức mới truy cập được màn vận hành.';
  static const String organizerTitle = 'Ban tổ chức';
  static const String organizerSubtitle =
      'Theo dõi sự kiện, tiến độ đội và trạng thái chấm điểm.';
  static const String sectionOverview = 'Tổng quan';
  static const String sectionOperations = 'Vận hành';
  static const String sectionSubmissions = 'Bài nộp';
  static const String sectionEvents = 'Sự kiện';
  static const String sectionTeams = 'Đội';
  static const String sendAnnouncementButton = 'Gửi thông báo';
  static const String sendAnnouncementDialogTitle = 'Gửi thông báo';
  static const String recipientLabel = 'Người nhận';
  static const String notificationTitleLabel = 'Tiêu đề';
  static const String notificationContentLabel = 'Nội dung';
  static const String createEventTitle = 'Tạo sự kiện';
  static const String editEventTitle = 'Sửa sự kiện';
  static const String eventFieldTitle = 'Tiêu đề';
  static const String eventFieldDescription = 'Mô tả';
  static const String eventFieldLocation = 'Địa điểm';
  static const String eventFieldBannerUrl = 'Banner URL';
  static const String eventFieldStartDate = 'Ngày bắt đầu';
  static const String eventFieldEndDate = 'Ngày kết thúc';
  static const String eventFieldRegistrationDeadline = 'Hạn đăng ký';
  static const String eventFieldMaxTeamSize = 'Số thành viên tối đa';
  static const String eventFieldRules = 'Luật thi';
  static const String eventFieldPrize = 'Giải thưởng';
  static const String eventFieldLatitude = 'Vĩ độ';
  static const String eventFieldLongitude = 'Kinh độ';
  static const String invalidEventDatesSnackBar =
      'Ngày sự kiện không hợp lệ. Kiểm tra lại định dạng.';
  static const String closeRegistrationTitle = 'Đóng đăng ký?';
  static const String closeRegistrationSuccess =
      'Đã đóng đăng ký cho sự kiện này.';
  static const String recentSubmissionsTitle = 'Bài nộp gần đây';
  static const String noSubmissionsYet = 'Chưa có bài nộp.';
  static const String openTeamAction = 'Mở đội';
  static const String teamDetailsTitle = 'Chi tiết đội';
  static const String noTeamsToView = 'Chưa có đội để xem.';
  static const String leaderboardCopiedSuccess = 'Đã sao chép bảng xếp hạng.';
  static const String manageUserRolesTitle = 'Quản lý vai trò người dùng';
  static const String noUsersYet = 'Chưa có người dùng.';
  static const String changeRoleDialogTitle = 'Đổi vai trò tài khoản?';
  static const String exportLeaderboardTitle = 'Xuất bảng xếp hạng';
  static const String userRolesTitle = 'Vai trò người dùng';
  static const String unscoredMetricLabel = 'Chưa chấm';
  static const String otherActionsTitle = 'Thao tác khác';
  static const String dashboardChartTitle = 'Tổng quan';
  static const String scoredBarLabel = 'Đã chấm';
  static const String unscoredBarLabel = 'Chưa chấm';

  static String closeRegistrationBody(String title) =>
      'Hạn đăng ký của $title sẽ được đặt về thời điểm hiện tại.';
  static const String loadMoreButton = 'Xem thêm';
  static const String announcementEventLabel = 'Liên kết sự kiện (tuỳ chọn)';
  static const String announcementNoEvent = 'Không gắn sự kiện';
  static const String viewEventFromAnnouncementButton = 'Xem sự kiện';
  static String announcementSentSuccess(int count) =>
      'Đã gửi thông báo cho $count người dùng.';
  static const String announcementTemplatesLabel = 'Mẫu nhanh';
  static const String announcementTemplateJudgingLabel = 'Mở phòng chấm';
  static const String announcementTemplateJudgingTitle = 'Mở phòng chấm điểm';
  static const String announcementTemplateJudgingBody =
      'Giám khảo vui lòng vào tab Chấm điểm. Phiên chấm điểm chính thức đã mở.';
  static const String announcementTemplateDeadlineLabel = 'Hạn nộp';
  static const String announcementTemplateDeadlineTitle =
      'Nhắc deadline nộp bài';
  static const String announcementTemplateDeadlineBody =
      'Các đội chưa nộp bài vui lòng hoàn thiện GitHub, video demo và mô tả trước hạn nộp.';
  static const String announcementTemplateKickoffLabel = 'Khai mạc';
  static const String announcementTemplateKickoffTitle = 'Khai mạc hackathon';
  static const String announcementTemplateKickoffBody =
      'Chào mừng các đội tham gia SEAL Innovation Hackathon 2026. Kiểm tra Sự kiện để xem lịch trình và luật thi.';
  static const String newScoreSnackBar =
      'Có điểm mới! Mở chuông để xem chi tiết.';
  static const String openInboxAction = 'Mở thông báo';
  static String changeRoleDialogBody(String name, String role) =>
      'Gán $name thành $role.';
  static String roleUpdatedSuccess(String name) => 'Đã cập nhật vai trò $name.';
  static String cannotChangeOwnRoleSubtitle(String email) =>
      '$email\n${AppStrings.cannotChangeOwnRole}';

  // Notifications
  static const String inboxTitle = 'Thông báo';
  static const String inboxSubtitle =
      'Thông báo hệ thống, điểm số và lời mời vào đội.';
  static const String inboxEmpty = 'Chưa có thông báo.';
  static const String reloadInboxAction = 'Tải lại thông báo';
  static const String unreadGroup = 'Chưa đọc';
  static const String readGroup = 'Đã đọc';
  static const String markAsReadAction = 'Đánh dấu đã đọc';
  static const String deleteNotificationTitle = 'Xóa thông báo?';
  static const String deleteNotificationBody =
      'Thông báo sẽ bị xóa khỏi danh sách.';

  // Profile
  static const String profileTitle = 'Hồ sơ';
  static const String profileSubtitle =
      'Quản lý thông tin tài khoản dùng trong các luồng vai trò.';
  static const String noActiveSession = 'Chưa có phiên đăng nhập.';
  static const String roleLabel = 'Vai trò';
  static const String accountInfoTitle = 'Thông tin tài khoản';
  static const String saveProfileButton = 'Lưu hồ sơ';
  static const String profileUpdatedSuccess = 'Đã cập nhật hồ sơ.';
  static const String themeModeTitle = 'Giao diện';
  static const String themeModeDark = 'Tối';
  static const String themeModeLight = 'Sáng';
  static const String themeModeSystem = 'Hệ thống';
  static const String sessionSectionTitle = 'Phiên đăng nhập';
  static const String logoutDescription =
      'Đăng xuất sẽ xóa state cục bộ và quay về màn đăng nhập.';

  // Map
  static const String mapTitle = 'Địa điểm';
  static const String mapSubtitle =
      'Bản đồ, địa chỉ và hỗ trợ mở app chỉ đường.';
  static const String noVenueYet = 'Chưa có địa điểm sự kiện.';
  static const String addressLabel = 'Địa chỉ';
  static const String openingHoursLabel = 'Giờ mở';
  static const String hotlineLabel = 'Đường dây nóng';
  static const String coordinatesLabel = 'Tọa độ';
  static const String defaultOpeningHours = '08:00 - 18:00';
  static const String defaultHotline = '0900 000 000';
  static const String copyAddressButton = 'Copy địa chỉ';
  static const String addressCopiedSuccess = 'Đã copy địa chỉ.';
  static const String openMapsButton = 'Mở Maps';
  static const String openExternalMapsTitle = 'Mở Maps bên ngoài?';
  static const String openExternalMapsBody =
      'Bạn sẽ rời SEAL Hackathon tạm thời để mở ứng dụng bản đồ.';

  // Validation
  static const String validationEmailRequired = 'Nhập email.';
  static const String validationEmailInvalid = 'Nhập email hợp lệ.';
  static const String validationPasswordRequired = 'Nhập mật khẩu.';
  static const String validationPasswordMinLength =
      'Mật khẩu cần ít nhất 6 ký tự.';
  static const String validationConfirmPasswordRequired = 'Nhập lại mật khẩu.';
  static const String validationPasswordMismatch =
      'Mật khẩu nhập lại không khớp.';
  static const String validationOtpRequired = 'Nhập mã OTP từ email.';
  static const String validationOtpInvalid = 'Mã OTP phải gồm 6 chữ số.';
  static const String validationFullNameRequired = 'Nhập họ tên.';
  static const String validationFullNameMinLength =
      'Họ tên cần ít nhất 2 ký tự.';
  static const String validationUniversityRequired = 'Nhập trường.';
  static const String validationUniversityMinLength =
      'Tên trường cần ít nhất 2 ký tự.';
  static const String validationSupabaseNotReady =
      'Không thể kết nối hệ thống. Vui lòng thử lại sau.';
  static const String validationTeamNameRequired = 'Nhập tên đội.';
  static const String validationTeamNameMinLength =
      'Tên đội cần ít nhất 2 ký tự.';
  static const String validationInviteEmailInvalid =
      'Nhập email thành viên hợp lệ.';
  static const String validationProjectNameRequired = 'Nhập tên project.';
  static const String validationProjectNameMinLength =
      'Tên project cần ít nhất 2 ký tự.';
  static const String validationDescriptionRequired = 'Nhập mô tả project.';
  static const String validationDescriptionMinLength =
      'Mô tả cần ít nhất 10 ký tự.';
  static const String validationJoinTeamBeforeSubmit =
      'Tạo hoặc tham gia đội trước khi nộp bài.';
  static const String eventNotLoadedForSubmit =
      'Chưa tải được thông tin sự kiện của đội. Thử tải lại sự kiện.';
  static const String validationChatMessageRequired =
      'Tin nhắn không được để trống.';
  static const String validationNotificationTitleRequired =
      'Nhập tiêu đề thông báo.';
  static const String validationNotificationBodyRequired =
      'Nhập nội dung thông báo.';
  static const String validationNotificationTypeInvalid =
      'Loại thông báo không hợp lệ.';
  static const String validationRecipientLabel = 'Người nhận';
  static const String validationEventTitleRequired = 'Nhập tiêu đề sự kiện.';
  static const String validationEventTitleMinLength =
      'Tiêu đề sự kiện cần ít nhất 2 ký tự.';
  static const String validationEventLocationRequired =
      'Nhập địa điểm sự kiện.';
  static const String validationEventLocationMinLength =
      'Địa điểm cần ít nhất 2 ký tự.';
  static const String validationLatitudeRequired = 'Nhập vĩ độ.';
  static const String validationLatitudeInvalid = 'Vĩ độ phải là số hợp lệ.';
  static const String validationLatitudeRange =
      'Vĩ độ phải nằm trong khoảng -90 đến 90.';
  static const String validationLongitudeRequired = 'Nhập kinh độ.';
  static const String validationLongitudeInvalid = 'Kinh độ phải là số hợp lệ.';
  static const String validationLongitudeRange =
      'Kinh độ phải nằm trong khoảng -180 đến 180.';
  static const String validationMaxTeamSizeRequired =
      'Nhập số thành viên tối đa.';
  static const String validationMaxTeamSizeInvalid =
      'Số thành viên tối đa phải là số nguyên hợp lệ.';
  static const String validationEndAfterStart =
      'Ngày kết thúc phải sau ngày bắt đầu.';
  static const String validationDeadlineBeforeEnd =
      'Hạn đăng ký không được sau ngày kết thúc sự kiện.';
  static const String validationScoreRange =
      'Điểm phải nằm trong khoảng 0 đến 10.';
  static const String validationNoSubmissionSelected =
      'Chưa chọn bài nộp để chấm.';
  static const String validationInvalidJudgeSession =
      'Phiên giám khảo không hợp lệ.';
  static const String validationFeedbackRequired =
      'Cần nhập nhận xét trước khi gửi điểm.';
  static const String validationInvalidRole = 'Vai trò không hợp lệ.';
  static const String validationUserLabel = 'Người dùng';
  static const String validationBannerUrlLabel = 'Banner URL';

  static String validationSearchMaxLength(int max) =>
      'Từ khóa tìm kiếm tối đa $max ký tự.';

  static String validationInvalidUser(String label) => '$label không hợp lệ.';

  static String validationFieldRequired(String label) => 'Nhập $label.';

  static String validationInvalidUrl(String label) =>
      '$label phải là URL http/https hợp lệ.';

  static String validationTeamNameMaxLength(int max) =>
      'Tên đội tối đa $max ký tự.';

  static String validationProjectNameMaxLength(int max) =>
      'Tên project tối đa $max ký tự.';

  static String validationDescriptionMaxLength(int max) =>
      'Mô tả tối đa $max ký tự.';

  static String validationChatMessageMaxLength(int max) =>
      'Tin nhắn tối đa $max ký tự.';

  static String validationNotificationTitleMaxLength(int max) =>
      'Tiêu đề tối đa $max ký tự.';

  static String validationNotificationBodyMaxLength(int max) =>
      'Nội dung tối đa $max ký tự.';

  static String validationFeedbackMaxLength(int max) =>
      'Nhận xét tối đa $max ký tự.';

  static String validationMaxTeamSizeRange(int min, int max) =>
      'Số thành viên tối đa phải từ $min đến $max.';

  static String validationDateTimeFormat(String label, String format) =>
      '$label phải theo định dạng $format (vd: 2026-06-15 09:00).';

  // Misc UI
  static const String reloadTeamsTooltip = 'Tải lại đội';
  static const String reloadJudgeQueueTooltip = 'Tải lại hàng chờ chấm';
  static const String reloadDashboardTooltip = 'Tải lại tổng quan';
  static const String judgePreviewOnlyMessage =
      'Đăng nhập bằng tài khoản Giám khảo để gửi điểm chính thức. Ban tổ chức có thể xem trước màn này.';
  static const String judgeQueueSortLabel = 'Sắp xếp hàng chờ';
  static const String sortNewestFirst = 'Mới nhất trước';
  static const String sortProjectName = 'Tên project';
  static const String sortTeamName = 'Đội';
  static const String sortAverageScore = 'Điểm trung bình';
  static const String judgeSubmissionToScoreLabel = 'Bài cần chấm';
  static const String unknownTeamLabel = 'Chưa rõ đội';
  static const String teamNotLoadedYet = 'Chưa tải đội';
  static const String eventNotLoadedYet = 'Chưa tải sự kiện';
  static const String averageScoreAbbrev = 'TB';
  static const String judgeReviewReminder =
      'Xem mã nguồn, chất lượng demo, độ sâu triển khai và tác động sản phẩm trước khi gửi điểm.';
  static const String rubricTechnicalLabel = 'Độ sâu kỹ thuật';
  static const String rubricTechnicalDescription =
      'Kiến trúc, độ đúng, độ tin cậy và độ sâu triển khai.';
  static const String rubricUiLabel = 'Trải nghiệm người dùng';
  static const String rubricUiDescription =
      'Luồng di động, độ rõ ràng, khả năng tiếp cận và độ hoàn thiện.';
  static const String rubricInnovationLabel = 'Đổi mới';
  static const String rubricInnovationDescription =
      'Tính mới, tác động, AI/automation hữu ích và độ phù hợp sản phẩm.';
  static const String decreaseScoreTooltip = 'Giảm';
  static const String increaseScoreTooltip = 'Tăng';
  static const String editEventMenuItem = 'Sửa sự kiện';
  static const String closeRegistrationMenuItem = 'Đóng đăng ký';
  static const String closeRegistrationConfirmButton = 'Đóng đăng ký';
  static const String notificationActionsTooltip = 'Thao tác thông báo';
  static const String eventActionsTooltip = 'Thao tác sự kiện';
  static const String submissionsMetricLabel = 'Bài nộp';
  static const String scoresMetricLabel = 'Lượt chấm';
  static const String systemStatusTitle = 'Tình trạng vận hành';
  static const String systemStatusSubtitle =
      'Theo dõi khả năng tải dữ liệu và trạng thái đồng bộ.';
  static const String chatSuggestionSubmission = 'Hỏi về bài nộp';
  static const String chatSuggestionGithub = 'Xem giúp GitHub link';
  static const String chatSuggestionChecklist = 'Checklist nộp bài';
  static const String emailPrefix = 'Email:';
  static const String averageScoreTitle = 'Điểm trung bình';
  static const String judgeQueueTitle = 'Hàng chờ chấm';
  static const String judgeQueueWaitingSuffix = ' bài đang chờ điểm';
  static const String exportLeaderboardDescription =
      'Copy dữ liệu xếp hạng vào clipboard';
  static const String userRolesDescription =
      'Xem và cập nhật vai trò tài khoản';
  static const String databaseConnectedLabel = 'Dữ liệu sẵn sàng';
  static const String databaseMissingLabel = 'Chưa có dữ liệu';
  static const String operationsDataLabel = 'Dữ liệu vận hành';
  static const String syncingLabel = 'Đang đồng bộ';
  static const String stateReadyLabel = 'Đã sẵn sàng';
  static const String notLoggedInShortLabel = 'Chưa đăng nhập';
  static const String noApiErrorsLabel = 'Không có lỗi tải dữ liệu';
  static const String systemStatusSemanticLabel =
      'Trạng thái vận hành hệ thống';

  static String submissionQueueCountLabel(int count) =>
      '$count bài trong hàng chờ này';

  static String scoreCountLabel(int count) => '$count lượt chấm';

  static String scoringProgressSemantic(int scored, int unscored) =>
      'Tiến độ chấm: $scored đã chấm và $unscored chưa chấm';

  static String memberCountWithLimit(int current, int limit) =>
      limit > 0 ? '$current/$limit thành viên' : memberCountLabel(current);

  static String apiErrorCountLabel(int count) => '$count lỗi';

  static String judgeQueueWaitingLabel(int count) =>
      '$count$judgeQueueWaitingSuffix';

  static String scoreSliderSemantic(
    String label,
    String value,
    String description,
  ) => '$label $value điểm. $description';

  static String messageTimestampSemantic(String senderLabel, String time) =>
      '$senderLabel lúc $time';

  static const String profileFullNameFieldSemantic = 'Ô nhập họ tên hồ sơ';
  static const String profileUniversityFieldSemantic = 'Ô nhập trường';

  // System errors
  static const String errorInvalidCredentials =
      'Email hoặc mật khẩu không đúng. '
      'Hãy dùng đúng email đã đăng ký hoặc bấm "Tạo tài khoản mới".';
  static const String errorEmailNotConfirmed =
      'Email chưa được xác nhận. Kiểm tra hộp thư đến hoặc thư rác.';
  static const String errorInvalidOtp =
      'Mã OTP không hợp lệ hoặc đã hết hạn. Yêu cầu gửi lại email kích hoạt.';
  static const String errorConnectionTimeout =
      'Kết nối quá lâu. Kiểm tra mạng rồi thử lại.';
  static const String errorRlsPermissionDenied =
      'Tài khoản hiện tại không có quyền thực hiện thao tác này.';
  static const String errorDuplicateRecord =
      'Dữ liệu này đã tồn tại. Tải lại màn hình rồi cập nhật bản ghi hiện có.';
  static const String errorCheckConstraint =
      'Dữ liệu chưa hợp lệ. Kiểm tra lại thông tin rồi thử lại.';
}
