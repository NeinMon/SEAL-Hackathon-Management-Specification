/// Feature-grouped UI strings (Vietnamese reference). Runtime text uses [AppLocalizations].
abstract final class ValidationStrings {
  ValidationStrings._();
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
