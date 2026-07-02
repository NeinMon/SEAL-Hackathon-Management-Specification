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
      error = null;
      infoMessage = AppStrings.emailConfirmedWelcomeBack;
    } catch (_) {
      user = null;
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
        user = null;
        infoMessage = AppStrings.activationEmailSent(cleanEmail);
      } else {
        pendingVerificationEmail = null;
        user = result.user;
        infoMessage = AppStrings.registerSuccess(cleanEmail);
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
      error = AppStrings.noPendingVerificationEmail;
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
      infoMessage = AppStrings.emailActivatedWelcome(email);
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
    infoMessage = null;
    error = null;
    notifyListeners();
  }

  Future<bool> logout() async {
    error = null;
    infoMessage = null;
    if (user == null) {
      error = AppStrings.notLoggedInMessage;
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
      infoMessage = AppStrings.passwordResetEmailSent(cleanEmail);
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
