/// Feature-grouped UI strings (Vietnamese reference). Runtime text uses [AppLocalizations].
abstract final class AuthStrings {
  AuthStrings._();
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
      'Tài khoản mới được tạo với vai trò Thí sinh. Sau đăng ký cần kích hoạt email bằng mã OTP.';
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
      'Nhập mã OTP 6 số trong email bên dưới.';

  static String emailActivatedWelcome(String email) =>
      'Email đã được kích hoạt. Chào mừng $email!';

  static String passwordResetEmailSent(String email) =>
      'Đã gửi link đặt lại mật khẩu tới $email. Kiểm tra hộp thư đến hoặc thư rác.';

  static String registerSuccess(String email) =>
      '$registerSuccessPrefix $email.';
}
