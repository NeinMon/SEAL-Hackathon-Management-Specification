import '../core/l10n/l10n_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_helpers.dart';
import '../models/app_user.dart';
import '../services/supabase_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = const AuthService();
  AppUser? user;
  bool isLoading = false;
  bool hasCheckedSession = false;
  String? error;
  String? infoMessage;
  String? pendingVerificationEmail;
  bool passwordRecoveryMode = false;

  AuthProvider({bool restoreSession = true}) {
    if (restoreSession) {
      _restoreSession();
    } else {
      hasCheckedSession = true;
    }
  }

  Future<void> _restoreSession() async {
    try {
      user = await _service.currentUserProfile();
    } catch (_) {
      user = null;
    }
    hasCheckedSession = true;
    notifyListeners();
  }

  Future<void> refreshFromDeepLink() async {
    try {
      user = await _service.currentUserProfile();
      pendingVerificationEmail = null;
      passwordRecoveryMode = false;
      error = null;
      infoMessage = L10nService.strings.emailConfirmedWelcomeBack;
    } catch (_) {
      user = null;
    }
    notifyListeners();
  }

  Future<bool> refreshFromInviteDeepLink() async {
    try {
      user = await _service.currentUserProfile();
      pendingVerificationEmail = null;
      passwordRecoveryMode = false;
      error = null;
      infoMessage = 'Da mo loi moi. Vao tab Doi de chap nhan loi moi.';
      notifyListeners();
      return user != null;
    } catch (_) {
      user = null;
      passwordRecoveryMode = false;
      error =
          'Link moi khong hop le hoac da het han. Hay dang nhap tai khoan duoc moi roi mo tab Doi.';
      infoMessage = null;
      notifyListeners();
      return false;
    }
  }

  void showSignupOtpRequiredMessage() {
    passwordRecoveryMode = false;
    error = null;
    infoMessage =
        'Link email không đăng nhập tự động. Vui lòng nhập mã OTP 6 số trong email để kích hoạt tài khoản.';
    notifyListeners();
  }

  void showInviteEmailMessage() {
    passwordRecoveryMode = false;
    error = null;
    infoMessage =
        'Lời mời đã được gửi. Vui lòng đăng nhập bằng tài khoản được mời, sau đó mở tab Đội để chấp nhận lời mời.';
    notifyListeners();
  }

  void showPasswordRecoveryLinkError() {
    passwordRecoveryMode = false;
    error =
        'Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn. Vui lòng gửi lại email đặt lại mật khẩu.';
    infoMessage = null;
    notifyListeners();
  }

  Future<void> startPasswordRecovery() async {
    try {
      user = await _service.currentUserProfile();
      passwordRecoveryMode = true;
      pendingVerificationEmail = null;
      error = null;
      infoMessage = null;
    } catch (_) {
      user = null;
      passwordRecoveryMode = false;
      error = L10nService.strings.notLoggedInMessage;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    error = null;
    infoMessage = null;
    notifyListeners();
    try {
      final emailError = AppValidators.loginEmail(email);
      if (emailError != null) {
        throw AuthException(emailError);
      }
      final passwordError = AppValidators.loginPassword(password);
      if (passwordError != null) {
        throw AuthException(passwordError);
      }
      final configError = AppValidators.requireSupabaseReady();
      if (configError != null) {
        throw AuthException(configError);
      }
      user = await _service.login(email.trim(), password);
      pendingVerificationEmail = null;
      passwordRecoveryMode = false;
    } on AuthException catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> register(
    String fullName,
    String email,
    String password,
    String confirmPassword,
    String university,
  ) async {
    isLoading = true;
    error = null;
    infoMessage = null;
    notifyListeners();
    try {
      final nameError = AppValidators.registerName(fullName);
      if (nameError != null) {
        throw AuthException(nameError);
      }
      final universityError = AppValidators.registerUniversity(university);
      if (universityError != null) {
        throw AuthException(universityError);
      }
      final emailError = AppValidators.loginEmail(email);
      if (emailError != null) {
        throw AuthException(emailError);
      }
      final passwordError = AppValidators.loginPassword(password);
      if (passwordError != null) {
        throw AuthException(passwordError);
      }
      final confirmError = AppValidators.confirmPassword(
        password,
        confirmPassword,
      );
      if (confirmError != null) {
        throw AuthException(confirmError);
      }
      final configError = AppValidators.requireSupabaseReady();
      if (configError != null) {
        throw AuthException(configError);
      }
      final cleanEmail = email.trim();
      final result = await _service.register(
        fullName: fullName.trim(),
        email: cleanEmail,
        password: password,
        university: university.trim(),
      );
      if (result.requiresEmailVerification) {
        pendingVerificationEmail = cleanEmail;
        passwordRecoveryMode = false;
        user = null;
        infoMessage = L10nService.strings.activationEmailSent(cleanEmail);
      } else {
        pendingVerificationEmail = null;
        passwordRecoveryMode = false;
        user = result.user;
        infoMessage = L10nService.strings.registerSuccess(cleanEmail);
      }
    } on AuthException catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> verifySignupOtp(String otp) async {
    final email = pendingVerificationEmail;
    if (email == null) {
      error = L10nService.strings.noPendingVerificationEmail;
      notifyListeners();
      return;
    }
    isLoading = true;
    error = null;
    infoMessage = null;
    notifyListeners();
    try {
      final otpError = AppValidators.signupOtp(otp);
      if (otpError != null) {
        throw AuthException(otpError);
      }
      final configError = AppValidators.requireSupabaseReady();
      if (configError != null) {
        throw AuthException(configError);
      }
      user = await _service.verifySignupOtp(email: email, otp: otp);
      pendingVerificationEmail = null;
      passwordRecoveryMode = false;
      infoMessage = L10nService.strings.emailActivatedWelcome(email);
    } on AuthException catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  void cancelEmailVerification() {
    pendingVerificationEmail = null;
    passwordRecoveryMode = false;
    infoMessage = null;
    error = null;
    notifyListeners();
  }

  Future<bool> logout() async {
    error = null;
    infoMessage = null;
    if (user == null) {
      error = L10nService.strings.notLoggedInMessage;
      notifyListeners();
      return false;
    }
    try {
      final configError = AppValidators.requireSupabaseReady();
      if (configError != null) {
        throw AuthException(configError);
      }
      await _service.logout();
      user = null;
      pendingVerificationEmail = null;
      passwordRecoveryMode = false;
      notifyListeners();
      return true;
    } on AuthException catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    notifyListeners();
    return false;
  }

  Future<bool> requestPasswordReset(String email) async {
    isLoading = true;
    error = null;
    infoMessage = null;
    notifyListeners();
    try {
      final emailError = AppValidators.loginEmail(email);
      if (emailError != null) {
        throw AuthException(emailError);
      }
      final configError = AppValidators.requireSupabaseReady();
      if (configError != null) {
        throw AuthException(configError);
      }
      final cleanEmail = email.trim();
      await _service.requestPasswordReset(cleanEmail);
      infoMessage = L10nService.strings.passwordResetEmailSent(cleanEmail);
      isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateRecoveredPassword(
    String password,
    String confirmPassword,
  ) async {
    isLoading = true;
    error = null;
    infoMessage = null;
    notifyListeners();
    try {
      final passwordError = AppValidators.loginPassword(password);
      if (passwordError != null) {
        throw AuthException(passwordError);
      }
      final confirmError = AppValidators.confirmPassword(
        password,
        confirmPassword,
      );
      if (confirmError != null) {
        throw AuthException(confirmError);
      }
      final configError = AppValidators.requireSupabaseReady();
      if (configError != null) {
        throw AuthException(configError);
      }
      user = await _service.updatePassword(password);
      passwordRecoveryMode = false;
      infoMessage = 'Đã cập nhật mật khẩu. Bạn có thể tiếp tục sử dụng app.';
      isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  void clearFeedback() {
    error = null;
    infoMessage = null;
    notifyListeners();
  }

  Future<void> updateProfile(String fullName, String university) async {
    final current = user;
    if (current == null) return;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final nameError = AppValidators.registerName(fullName);
      if (nameError != null) {
        throw AuthException(nameError);
      }
      final universityError = AppValidators.registerUniversity(university);
      if (universityError != null) {
        throw AuthException(universityError);
      }
      final configError = AppValidators.requireSupabaseReady();
      if (configError != null) {
        throw AuthException(configError);
      }
      user = await _service.updateProfile(
        userId: current.id,
        fullName: fullName.trim(),
        university: university.trim(),
      );
    } on AuthException catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }
}
