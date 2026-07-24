/// Feature-grouped UI strings (Vietnamese reference). Runtime text uses [AppLocalizations].
abstract final class JudgeStrings {
  JudgeStrings._();
  // Judge
  static const String judgeRoleGateMessage =
      'Chỉ giám khảo mới truy cập được màn chấm điểm.';
  static const String judgeTitle = 'Chấm điểm';
  static const String judgeSubtitle =
      'Chấm bài theo chất lượng giải pháp, trải nghiệm và đổi mới.';
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
  static const String scorePublishedNotificationTitle = 'Điểm đã được công bố';
  static const String scorePublishedSnackBar = 'Đã công bố điểm cho bài nộp.';
  static const String scoreSavedSuccess = 'Đã lưu điểm.';
  static const String judgeScoreParticipantHint =
      'Thí sinh mở thông báo để xem điểm và nhận xét.';
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
}
