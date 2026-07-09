/// Feature-grouped UI strings (Vietnamese reference). Runtime text uses [AppLocalizations].
abstract final class TeamsStrings {
  TeamsStrings._();
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
}
