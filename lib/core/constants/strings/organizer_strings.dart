/// Feature-grouped UI strings (Vietnamese reference). Runtime text uses [AppLocalizations].
abstract final class OrganizerStrings {
  OrganizerStrings._();
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
    static const String recentSubmissionsTitle = 'Bài nộp mới nhất';
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
    static const String dashboardChartTitle = 'Tổng quan chấm';
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
      'Có điểm mới. Mở thông báo để xem.';
  static const String openInboxAction = 'Xem thông báo';
  static String changeRoleDialogBody(String name, String role) =>
      'Gán $name thành $role.';
  static String roleUpdatedSuccess(String name) => 'Đã cập nhật vai trò $name.';
  static String cannotChangeOwnRoleSubtitle(String email) =>
      '$email\nKhông thể đổi vai trò của chính bạn.';
}
