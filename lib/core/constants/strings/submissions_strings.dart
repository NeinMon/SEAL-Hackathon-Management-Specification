/// Feature-grouped UI strings (Vietnamese reference). Runtime text uses [AppLocalizations].
abstract final class SubmissionsStrings {
  SubmissionsStrings._();
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
}
