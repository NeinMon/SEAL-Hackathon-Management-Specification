/// Feature-grouped UI strings (Vietnamese reference). Runtime text uses [AppLocalizations].
abstract final class EventsStrings {
  EventsStrings._();
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
      'Đang nạp dữ liệu sự kiện.';
  static const String eventNotFound = 'Không tìm thấy sự kiện.';
  static const String rulesTitle = 'Luật thi';
  static const String prizeTitle = 'Giải thưởng';
    static const String leaderboardTitle = 'Xếp hạng';
  static const String noScoredSubmissionsYet = 'Chưa có bài nào được chấm.';
  static const String noSubmissionsForEventYet =
      'Chưa có bài nộp cho sự kiện này.';
    static const String eventDetailStatsTitle = 'Số liệu sự kiện';
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
    static const String openJudgeQueueButton = 'Xem bài chưa chấm';
  static const String openOrganizerDashboardButton = 'Mở tổng quan ban tổ chức';
  static const String openMentorChatButton = 'Mở chat mentor';
  static const String manageTeamButton = 'Tạo hoặc quản lý đội';
  static const String viewMyTeamButton = 'Xem đội của tôi';
  static const String joinOrCreateTeamButton = 'Tạo hoặc tham gia đội';
  static const String submitForEventButton = 'Nộp bài cho sự kiện này';
  static const String myTeamForEventTitle = 'Đội của bạn';
    static const String leaderboardPendingTitle = 'Bài chưa chấm';
    static const String awaitingScoreBadge = 'Đang chờ chấm';
  static const String judgeQueueFilteredSubtitle =
      'Danh sách bài nộp chưa được chấm cho sự kiện đang chọn.';
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
}
