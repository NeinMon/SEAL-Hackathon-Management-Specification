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
      'Tính năng này không khả dụng với role hiện tại.';
  static const String accessDeniedDefaultMessage =
      'Vui lòng đăng nhập bằng tài khoản phù hợp.';
  static const String backToEventsButton = 'Về Events';
  static const String loginRequiredTitle = 'Vui lòng đăng nhập';
  static const String loginRequiredSubtitle =
      'Đăng nhập để tiếp tục sử dụng SEAL Hackathon.';
  static const String goToLoginButton = 'Đến màn hình đăng nhập';
  static const String supabaseRequiredTitle = 'Cần kết nối Supabase';
  static const String supabaseRequiredBody =
      'Chạy app với SUPABASE_URL và SUPABASE_ANON_KEY. App không còn chạy bằng dữ liệu mock.';
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
  static const String eventsNavLabel = 'Events';
  static const String teamNavLabel = 'Team';
  static const String submitNavLabel = 'Nộp bài';
  static const String judgeNavLabel = 'Chấm điểm';
  static const String dashboardNavLabel = 'Dashboard';
  static const String chatNavLabel = 'Chat';
  static const String mapNavLabel = 'Bản đồ';
  static const String profileNavLabel = 'Hồ sơ';
  static const String notificationsNavLabel = 'Thông báo';
  static const String accountMenuTooltip = 'Tài khoản';
  static const String logoutButton = 'Đăng xuất';

  // Auth
  static const String loginTitle = 'Đăng nhập';
  static const String registerTitle = 'Tạo tài khoản';
  static const String verifyEmailTitle = 'Kích hoạt email';
  static const String loginHeroSubtitle =
      'Quản lý event, team, bài nộp, chấm điểm, tin nhắn và địa điểm trong một app mobile.';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Mật khẩu';
  static const String confirmPasswordLabel = 'Nhập lại mật khẩu';
  static const String fullNameLabel = 'Họ tên';
  static const String universityLabel = 'Trường';
  static const String otpLabel = 'Mã OTP (6 số)';
  static const String otpHelpText =
      'Mã OTP nằm trong email kích hoạt. Local demo: mở Mailpit tại http://127.0.0.1:54324.';
  static const String registerRoleHint =
      'Tài khoản mới được tạo với vai trò Thí sinh. Sau đăng ký cần kích hoạt email bằng OTP hoặc link.';
  static const String roleManagedHint = 'Role được quản lý theo hồ sơ tài khoản.';
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
  static const String loginFailed =
      'Sai tên đăng nhập hoặc mật khẩu';
  static const String emailConfirmedWelcomeBack =
      'Email đã được xác nhận. Chào mừng bạn quay lại!';
  static const String noPendingVerificationEmail =
      'Không có email đang chờ xác nhận.';
  static const String registerSuccessPrefix = 'Đăng ký thành công với';

  static String activationEmailSent(String email) =>
      'Đã gửi email kích hoạt tới $email. '
      'Mở link trong email hoặc nhập mã OTP 6 số bên dưới. '
      'Local demo: Mailpit http://127.0.0.1:54324.';

  static String emailActivatedWelcome(String email) =>
      'Email đã được kích hoạt. Chào mừng $email!';

  static String passwordResetEmailSent(String email) =>
      'Đã gửi link đặt lại mật khẩu tới $email. '
      'Local demo: mở Mailpit tại http://127.0.0.1:54324.';

  static String registerSuccess(String email) => '$registerSuccessPrefix $email.';

  // Events
  static const String eventsTitle = 'Events';
  static const String eventsSubtitle =
      'Theo dõi hackathon, deadline và thông tin chi tiết.';
  static const String eventSearchHint = 'Tìm theo tên, địa điểm hoặc chủ đề';
  static const String sortStartAsc = 'Ngày bắt đầu: sớm nhất';
  static const String sortStartDesc = 'Ngày bắt đầu: muộn nhất';
  static const String sortTitleAsc = 'Tên A → Z';
  static const String sortTitleDesc = 'Tên Z → A';
  static const String sortDeadlineAsc = 'Deadline: gần nhất';
  static const String sortDeadlineDesc = 'Deadline: xa nhất';
  static const String noMatchingEvents = 'Không có event phù hợp.';
  static const String noEventsYet = 'Chưa có event.';
  static const String clearSearchAction = 'Xóa tìm kiếm';
  static const String reloadEventsAction = 'Tải lại Events';
  static const String registerTeamPill = 'Đăng ký team';
  static const String eventDetailTitle = 'Chi tiết Event';
  static const String eventDetailSubtitle =
      'Timeline, luật thi, địa điểm và bảng xếp hạng.';
  static const String eventDetailLoadingSubtitle =
      'Đang tải thông tin hackathon từ hệ thống.';
  static const String eventNotFound = 'Không tìm thấy event.';
  static const String rulesTitle = 'Luật thi';
  static const String prizeTitle = 'Giải thưởng';
  static const String leaderboardTitle = 'Bảng xếp hạng';
  static const String noScoredSubmissionsYet = 'Chưa có bài nào được chấm.';
  static const String timelineTitle = 'Timeline';
  static const String timelineRegistration = 'Đăng ký';
  static const String timelineKickoff = 'Kickoff';
  static const String timelineFinal = 'Chung kết';
  static const String openJudgeQueueButton = 'Mở hàng chờ chấm';
  static const String openOrganizerDashboardButton = 'Mở Dashboard ban tổ chức';
  static const String openMentorChatButton = 'Mở Mentor Chat';
  static const String manageTeamButton = 'Tạo hoặc quản lý team';
  static const String viewVenueButton = 'Xem địa điểm';
  static const String eventCreatedSuccess = 'Đã tạo event.';
  static const String eventUpdatedSuccess = 'Đã cập nhật event.';

  static String openEventSemanticLabel(String title) => 'Mở event $title';
  static String registerBeforeDate(String date) => 'Đăng ký trước $date';
  static String registrationClosedByDate(String date) => 'Đóng đăng ký $date';
  static String maxMembersChip(int count) => 'Tối đa $count thành viên';

  // Teams
  static const String teamTitle = 'Team';
  static const String teamSubtitle =
      'Tạo team, mời thành viên và quản lý tham gia.';
  static const String teamOverviewTitle = 'Tổng quan team';
  static const String noTeamsYet = 'Chưa có team';
  static const String teamsAvailable = 'Team đang có';
  static const String checkInLabel = 'Check-in';
  static const String checkInPending = 'Chờ';
  static const String checkInConfirmed = 'Đã xác nhận';
  static const String submitProjectButton = 'Nộp project';
  static const String createTeamButton = 'Tạo team';
  static const String createTeamTitle = 'Tạo team';
  static const String eventLabel = 'Event';
  static const String teamNameLabel = 'Tên team';
  static const String loadEventsBeforeCreateTeam =
      'Chưa có event. Tải event trước khi tạo team.';
  static const String roleViewOnlyTeams =
      'Role này chỉ xem team, không tạo team thí sinh.';
  static const String emptyTeamsMessage =
      'Chưa có team. Tạo team để tiếp tục.';
  static const String myTeamsGroup = 'Team của tôi';
  static const String otherTeamsGroup = 'Team khác';
  static const String teamFullBadge = 'Team đã đầy';
  static const String updateTeamDialogTitle = 'Cập nhật team';
  static const String leaveTeamDialogTitle = 'Rời team?';
  static const String leaveTeamButton = 'Rời team';
  static const String joinTeamButton = 'Tham gia team';
  static const String inviteMemberTitle = 'Mời thành viên';
  static const String memberEmailLabel = 'Email thành viên';
  static const String sendInvitationButton = 'Gửi lời mời';
  static const String teamInvitationTitle = 'Lời mời vào team';
  static const String teamCreatedNotificationTitle = 'Đã tạo team';
  static const String teamCreatedSuccess = 'Đã tạo team.';
  static const String teamJoinedSuccess = 'Đã tham gia team.';
  static const String invitationSentSuccess = 'Đã gửi lời mời.';
  static const String teamUpdatedSuccess = 'Đã cập nhật team.';
  static const String teamLeftSuccess = 'Đã rời team.';
  static const String invalidTeamError = 'Team không hợp lệ.';
  static const String alreadyTeamMemberError =
      'Bạn đã là thành viên của team này.';
  static const String cannotChangeOwnRole =
      'Không thể đổi role của chính bạn.';

  static String leaderPrefix(String name) => 'Leader: $name';
  static String memberCountLabel(int count) => '$count thành viên';
  static String inviteTeamPrefix(String name) => 'Team: $name';
  static String leaveTeamDialogBody(String teamName) =>
      'Bạn sẽ rời $teamName.';
  static String teamInvitationBody(String teamName) =>
      'Bạn được mời vào $teamName.';
  static String teamCreatedNotificationBody(String teamName, String eventTitle) =>
      '$teamName đã tham gia $eventTitle.';
  static String teamFullForEventError(String teamName) =>
      '$teamName đã đủ thành viên cho event này.';

  // Submissions
  static const String submissionsRoleGateMessage =
      'Chỉ thí sinh mới có thể nộp project.';
  static const String submitScreenTitle = 'Nộp bài';
  static const String submitScreenSubtitle =
      'Gửi GitHub, video demo và mô tả project cho giám khảo.';
  static const String projectInfoSection = 'Thông tin project';
  static const String linksSection = 'Links';
  static const String descriptionSection = 'Mô tả';
  static const String projectNameLabel = 'Tên project';
  static const String githubUrlLabel = 'GitHub URL';
  static const String demoVideoUrlLabel = 'Demo video URL';
  static const String projectDescriptionHint = 'Project giải quyết vấn đề gì?';
  static const String submissionDescriptionTip =
      'Gợi ý: nêu vấn đề, giải pháp, tính năng chính, tech stack và tác động đo được.';
  static const String joinTeamBeforeSubmit =
      'Tạo hoặc tham gia team trước khi nộp bài.';
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
  static const String selectTeamToSubmit = 'Chọn hoặc tạo team để nộp project.';
  static const String goToTeamAction = 'Đến Team';
  static const String teamHasNoSubmission = 'Team này chưa nộp project.';
  static const String updateHistoryTitle = 'Lịch sử cập nhật';
  static const String judgeFeedbackTitle = 'Feedback từ giám khảo';
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
  static const String chatTitle = 'Mentor Chat';
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
      'Chấm bài theo tiêu chí kỹ thuật, UI/UX và đổi mới.';
  static const String filterUnscored = 'Chưa chấm';
  static const String filterScored = 'Đã chấm';
  static const String judgeSearchLabel = 'Tìm bài nộp hoặc team';
  static const String noMatchingSubmissions = 'Không có bài nộp phù hợp.';
  static const String showAllSubmissions = 'Hiện tất cả';
  static const String selectSubmissionTitle = 'Chọn bài nộp';
  static const String nextUnscoredButton = 'Bài chưa chấm tiếp theo';
  static const String selectSubmissionToScore = 'Chọn một bài để chấm.';
  static const String needsScoringBadge = 'Cần chấm';
  static const String repositoryButton = 'Repository';
  static const String demoButton = 'Demo';
  static const String rubricEvaluationTitle = 'Rubric Evaluation';
  static const String feedbackLabel = 'Feedback';
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

  static String updateScoreDialogBody(String projectName) =>
      'Điểm trước đó của bạn cho $projectName sẽ được thay thế.';
  static String scorePublishedNotificationBody(String projectName) =>
      '$projectName có điểm mới.';

  // Organizer
  static const String organizerRoleGateMessage =
      'Chỉ ban tổ chức mới truy cập được Dashboard vận hành.';
  static const String organizerTitle = 'Organizer';
  static const String organizerSubtitle =
      'Theo dõi event, tiến độ team và trạng thái chấm điểm.';
  static const String sectionOverview = 'Tổng quan';
  static const String sectionOperations = 'Vận hành';
  static const String sectionSubmissions = 'Bài nộp';
  static const String sectionEvents = 'Events';
  static const String sectionTeams = 'Team';
  static const String sendAnnouncementButton = 'Gửi thông báo';
  static const String sendAnnouncementDialogTitle = 'Gửi thông báo';
  static const String recipientLabel = 'Người nhận';
  static const String notificationTitleLabel = 'Tiêu đề';
  static const String notificationContentLabel = 'Nội dung';
  static const String createEventTitle = 'Tạo event';
  static const String editEventTitle = 'Sửa event';
  static const String eventFieldTitle = 'Tiêu đề';
  static const String eventFieldDescription = 'Mô tả';
  static const String eventFieldLocation = 'Địa điểm';
  static const String eventFieldBannerUrl = 'Banner URL';
  static const String eventFieldStartDate = 'Ngày bắt đầu';
  static const String eventFieldEndDate = 'Ngày kết thúc';
  static const String eventFieldRegistrationDeadline = 'Deadline đăng ký';
  static const String eventFieldMaxTeamSize = 'Số thành viên tối đa';
  static const String eventFieldRules = 'Luật thi';
  static const String eventFieldPrize = 'Giải thưởng';
  static const String eventFieldLatitude = 'Latitude';
  static const String eventFieldLongitude = 'Longitude';
  static const String invalidEventDatesSnackBar =
      'Ngày event không hợp lệ. Kiểm tra lại định dạng.';
  static const String closeRegistrationTitle = 'Đóng đăng ký?';
  static const String closeRegistrationSuccess =
      'Đã đóng đăng ký cho event này.';
  static const String recentSubmissionsTitle = 'Bài nộp gần đây';
  static const String noSubmissionsYet = 'Chưa có bài nộp.';
  static const String openTeamAction = 'Mở Team';
  static const String teamDetailsTitle = 'Chi tiết team';
  static const String noTeamsToView = 'Chưa có team để xem.';
  static const String leaderboardCopiedSuccess = 'Đã copy leaderboard CSV.';
  static const String manageUserRolesTitle = 'Quản lý role người dùng';
  static const String noUsersYet = 'Chưa có người dùng.';
  static const String changeRoleDialogTitle = 'Đổi role tài khoản?';
  static const String exportLeaderboardTitle = 'Export leaderboard CSV';
  static const String userRolesTitle = 'Role người dùng';
  static const String resetDemoTitle = 'Reset dữ liệu demo?';
  static const String unscoredMetricLabel = 'Chưa chấm';
  static const String otherActionsTitle = 'Thao tác khác';
  static const String dashboardChartTitle = 'Dashboard';
  static const String scoredBarLabel = 'Đã chấm';
  static const String unscoredBarLabel = 'Chưa chấm';

  static String closeRegistrationBody(String title) =>
      'Deadline đăng ký của $title sẽ được đặt về thời điểm hiện tại.';
  static String announcementSentSuccess(int count) =>
      'Đã gửi thông báo cho $count người dùng.';
  static String changeRoleDialogBody(String name, String role) =>
      'Gán $name thành $role.';
  static String roleUpdatedSuccess(String name) => 'Đã cập nhật role $name.';
  static String cannotChangeOwnRoleSubtitle(String email) =>
      '$email\n${AppStrings.cannotChangeOwnRole}';

  // Notifications
  static const String inboxTitle = 'Inbox';
  static const String inboxSubtitle =
      'Thông báo hệ thống, điểm số và lời mời vào team.';
  static const String inboxEmpty = 'Inbox đang trống.';
  static const String reloadInboxAction = 'Tải lại Inbox';
  static const String unreadGroup = 'Chưa đọc';
  static const String readGroup = 'Đã đọc';
  static const String markAsReadAction = 'Đánh dấu đã đọc';
  static const String deleteNotificationTitle = 'Xóa thông báo?';
  static const String deleteNotificationBody =
      'Thông báo sẽ bị xóa khỏi Inbox.';

  // Profile
  static const String profileTitle = 'Hồ sơ';
  static const String profileSubtitle =
      'Quản lý thông tin tài khoản dùng trong các luồng role.';
  static const String noActiveSession = 'Chưa có phiên đăng nhập.';
  static const String roleLabel = 'Role';
  static const String accountInfoTitle = 'Thông tin tài khoản';
  static const String saveProfileButton = 'Lưu hồ sơ';
  static const String profileUpdatedSuccess = 'Đã cập nhật hồ sơ.';
  static const String sessionSectionTitle = 'Phiên đăng nhập';
  static const String logoutDescription =
      'Đăng xuất sẽ xóa state cục bộ và quay về màn đăng nhập.';

  // Map
  static const String mapTitle = 'Địa điểm';
  static const String mapSubtitle =
      'Bản đồ, địa chỉ và hỗ trợ mở app chỉ đường.';
  static const String noVenueYet = 'Chưa có địa điểm event.';
  static const String addressLabel = 'Địa chỉ';
  static const String openingHoursLabel = 'Giờ mở';
  static const String hotlineLabel = 'Hotline';
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
      'Chưa kết nối Supabase. Kiểm tra SUPABASE_URL và SUPABASE_ANON_KEY.';
  static const String validationTeamNameRequired = 'Nhập tên team.';
  static const String validationTeamNameMinLength =
      'Tên team cần ít nhất 2 ký tự.';
  static const String validationInviteEmailInvalid =
      'Nhập email thành viên hợp lệ.';
  static const String validationProjectNameRequired = 'Nhập tên project.';
  static const String validationProjectNameMinLength =
      'Tên project cần ít nhất 2 ký tự.';
  static const String validationDescriptionRequired = 'Nhập mô tả project.';
  static const String validationDescriptionMinLength =
      'Mô tả cần ít nhất 10 ký tự.';
  static const String validationJoinTeamBeforeSubmit =
      'Tạo hoặc tham gia team trước khi nộp bài.';
  static const String validationChatMessageRequired =
      'Tin nhắn không được để trống.';
  static const String validationNotificationTitleRequired =
      'Nhập tiêu đề thông báo.';
  static const String validationNotificationBodyRequired =
      'Nhập nội dung thông báo.';
  static const String validationNotificationTypeInvalid =
      'Loại thông báo không hợp lệ.';
  static const String validationRecipientLabel = 'Người nhận';
  static const String validationEventTitleRequired = 'Nhập tiêu đề event.';
  static const String validationEventTitleMinLength =
      'Tiêu đề event cần ít nhất 2 ký tự.';
  static const String validationEventLocationRequired = 'Nhập địa điểm event.';
  static const String validationEventLocationMinLength =
      'Địa điểm cần ít nhất 2 ký tự.';
  static const String validationLatitudeRequired = 'Nhập latitude.';
  static const String validationLatitudeInvalid = 'Latitude phải là số hợp lệ.';
  static const String validationLatitudeRange =
      'Latitude phải nằm trong khoảng -90 đến 90.';
  static const String validationLongitudeRequired = 'Nhập longitude.';
  static const String validationLongitudeInvalid =
      'Longitude phải là số hợp lệ.';
  static const String validationLongitudeRange =
      'Longitude phải nằm trong khoảng -180 đến 180.';
  static const String validationMaxTeamSizeRequired =
      'Nhập số thành viên tối đa.';
  static const String validationMaxTeamSizeInvalid =
      'Số thành viên tối đa phải là số nguyên hợp lệ.';
  static const String validationEndAfterStart =
      'Ngày kết thúc phải sau ngày bắt đầu.';
  static const String validationDeadlineBeforeEnd =
      'Deadline đăng ký không được sau ngày kết thúc event.';
  static const String validationScoreRange =
      'Điểm phải nằm trong khoảng 0 đến 10.';
  static const String validationNoSubmissionSelected =
      'Chưa chọn bài nộp để chấm.';
  static const String validationInvalidJudgeSession =
      'Phiên giám khảo không hợp lệ.';
  static const String validationFeedbackRequired =
      'Cần nhập feedback trước khi gửi điểm.';
  static const String validationInvalidRole = 'Role không hợp lệ.';
  static const String validationUserLabel = 'Người dùng';
  static const String validationBannerUrlLabel = 'Banner URL';

  static String validationSearchMaxLength(int max) =>
      'Từ khóa tìm kiếm tối đa $max ký tự.';

  static String validationInvalidUser(String label) => '$label không hợp lệ.';

  static String validationFieldRequired(String label) => 'Nhập $label.';

  static String validationInvalidUrl(String label) =>
      '$label phải là URL http/https hợp lệ.';

  static String validationTeamNameMaxLength(int max) =>
      'Tên team tối đa $max ký tự.';

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
      'Feedback tối đa $max ký tự.';

  static String validationMaxTeamSizeRange(int min, int max) =>
      'Số thành viên tối đa phải từ $min đến $max.';

  static String validationDateTimeFormat(String label, String format) =>
      '$label phải theo định dạng $format (vd: 2026-06-15 09:00).';

  // Misc UI
  static const String reloadTeamsTooltip = 'Tải lại Team';
  static const String reloadJudgeQueueTooltip = 'Tải lại hàng chờ chấm';
  static const String reloadDashboardTooltip = 'Tải lại Dashboard';
  static const String judgePreviewOnlyMessage =
      'Đăng nhập role Giám khảo để gửi điểm chính thức. Ban tổ chức có thể xem trước màn này.';
  static const String judgeQueueSortLabel = 'Sắp xếp hàng chờ';
  static const String sortNewestFirst = 'Mới nhất trước';
  static const String sortProjectName = 'Tên project';
  static const String sortTeamName = 'Team';
  static const String sortAverageScore = 'Điểm trung bình';
  static const String judgeSubmissionToScoreLabel = 'Bài cần chấm';
  static const String unknownTeamLabel = 'Chưa rõ team';
  static const String teamNotLoadedYet = 'Chưa tải team';
  static const String eventNotLoadedYet = 'Chưa tải event';
  static const String averageScoreAbbrev = 'TB';
  static const String judgeReviewReminder =
      'Xem repository, chất lượng demo, độ sâu triển khai và tác động sản phẩm trước khi gửi điểm.';
  static const String rubricTechnicalLabel = 'Technical depth';
  static const String rubricTechnicalDescription =
      'Kiến trúc, độ đúng, độ tin cậy và độ sâu triển khai.';
  static const String rubricUiLabel = 'UI/UX quality';
  static const String rubricUiDescription =
      'Luồng mobile, độ rõ ràng, accessibility và độ hoàn thiện demo.';
  static const String rubricInnovationLabel = 'Innovation';
  static const String rubricInnovationDescription =
      'Tính mới, tác động, AI/automation hữu ích và độ phù hợp sản phẩm.';
  static const String decreaseScoreTooltip = 'Giảm';
  static const String increaseScoreTooltip = 'Tăng';
  static const String editEventMenuItem = 'Sửa event';
  static const String closeRegistrationMenuItem = 'Đóng đăng ký';
  static const String closeRegistrationConfirmButton = 'Đóng đăng ký';
  static const String notificationActionsTooltip = 'Thao tác thông báo';
  static const String eventActionsTooltip = 'Thao tác event';
  static const String submissionsMetricLabel = 'Bài nộp';
  static const String scoresMetricLabel = 'Scores';
  static const String systemStatusTitle = 'System Status';
  static const String systemStatusSubtitle =
      'Trạng thái Database/API và Provider để demo.';
  static const String chatSuggestionSubmission = 'Hỏi về bài nộp';
  static const String chatSuggestionGithub = 'Review GitHub link';
  static const String chatSuggestionChecklist = 'Checklist demo';
  static const String emailPrefix = 'Email:';
  static const String averageScoreTitle = 'Điểm trung bình';
  static const String judgeQueueTitle = 'Hàng chờ chấm';
  static const String judgeQueueWaitingSuffix = ' bài đang chờ điểm';
  static const String exportLeaderboardDescription =
      'Copy dữ liệu xếp hạng vào clipboard';
  static const String userRolesDescription = 'Xem role tài khoản dùng trong RLS';
  static const String resetDemoDescription =
      'Gọi Edge Function có kiểm role organizer';
  static const String resetDemoBody =
      'Edge Function sẽ xóa dữ liệu demo cũ và seed lại workspace sạch. Chỉ role Ban tổ chức được phép chạy.';
  static const String databaseConnectedLabel = 'Database đã kết nối';
  static const String databaseMissingLabel = 'Thiếu Database';
  static const String syncingLabel = 'Đang đồng bộ';
  static const String stateReadyLabel = 'State sẵn sàng';
  static const String notLoggedInShortLabel = 'Chưa đăng nhập';
  static const String noApiErrorsLabel = 'Không có lỗi API';
  static const String systemStatusSemanticLabel =
      'Trạng thái hệ thống database và state app';

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
  ) =>
      '$label $value điểm. $description';

  static String messageTimestampSemantic(String senderLabel, String time) =>
      '$senderLabel lúc $time';

  static const String profileFullNameFieldSemantic = 'Ô nhập họ tên hồ sơ';
  static const String profileUniversityFieldSemantic = 'Ô nhập trường';

  // System errors
  static const String errorInvalidCredentials =
      'Email hoặc mật khẩu không đúng. '
      'Hãy dùng đúng email đã đăng ký hoặc bấm "Tạo tài khoản mới".';
  static const String errorEmailNotConfirmed =
      'Email chưa được xác nhận. Kiểm tra hộp thư hoặc Mailpit local.';
  static const String errorInvalidOtp =
      'Mã OTP không hợp lệ hoặc đã hết hạn. Yêu cầu gửi lại email kích hoạt.';
  static const String errorConnectionTimeout =
      'Kết nối quá lâu. Kiểm tra mạng rồi thử lại.';
  static const String errorRlsPermissionDenied =
      'Tài khoản hiện tại không có quyền thực hiện thao tác này. Kiểm tra role đăng nhập và migrations RLS.';
  static const String errorDuplicateRecord =
      'Dữ liệu này đã tồn tại. Tải lại màn hình rồi cập nhật bản ghi hiện có.';
  static const String errorCheckConstraint =
      'Dữ liệu chưa đạt quy tắc của database. Kiểm tra điểm, trạng thái và loại thông báo.';
}
