/// Feature-grouped UI strings (Vietnamese reference). Runtime text uses [AppLocalizations].
abstract final class CommonStrings {
  CommonStrings._();
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
}
