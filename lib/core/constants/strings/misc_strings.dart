/// Feature-grouped UI strings (Vietnamese reference). Runtime text uses [AppLocalizations].
abstract final class MiscStrings {
  MiscStrings._();
  // Misc UI
  static const String reloadTeamsTooltip = 'Tải lại đội';
  static const String reloadJudgeQueueTooltip = 'Tải lại bài chưa chấm';
  static const String reloadDashboardTooltip = 'Tải lại tổng quan';
  static const String judgePreviewOnlyMessage =
      'Đăng nhập bằng tài khoản Giám khảo để gửi điểm chính thức.';
  static const String judgeQueueSortLabel = 'Sắp xếp bài chưa chấm';
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
  static const String rubricTechnicalLabel = 'Chất lượng giải pháp';
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
  static const String notificationActionsTooltip = 'Tùy chọn thông báo';
  static const String eventActionsTooltip = 'Thao tác sự kiện';
  static const String submissionsMetricLabel = 'Bài nộp';
  static const String scoresMetricLabel = 'Số lượt chấm';
  static const String systemStatusTitle = 'Trạng thái hệ thống';
  static const String systemStatusSubtitle =
      'Theo dõi trạng thái dữ liệu và cập nhật.';
  static const String chatSuggestionSubmission = 'Hỏi về bài nộp';
  static const String chatSuggestionGithub = 'Xem giúp GitHub link';
  static const String chatSuggestionChecklist = 'Checklist nộp bài';
  static const String emailPrefix = 'Email:';
  static const String averageScoreTitle = 'Điểm trung bình';
  static const String judgeQueueTitle = 'Theo dõi bài chưa chấm';
  static const String judgeQueueWaitingSuffix = ' bài chưa chấm';
  static const String exportLeaderboardDescription =
      'Copy dữ liệu xếp hạng vào clipboard';
  static const String userRolesDescription =
      'Xem và cập nhật vai trò tài khoản';
  static const String databaseConnectedLabel = 'Dữ liệu sẵn sàng';
  static const String databaseMissingLabel = 'Chưa có dữ liệu';
  static const String operationsDataLabel = 'Dữ liệu vận hành';
  static const String syncingLabel = 'Đang cập nhật';
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
      limit > 0 ? '$current/$limit thành viên' : '$current thành viên';

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
}
