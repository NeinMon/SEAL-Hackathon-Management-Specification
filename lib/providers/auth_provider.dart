import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart';

import '../core/app_helpers.dart';
import '../models/app_user.dart';
import '../services/supabase_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = const AuthService();
  AppUser? user;
  bool isLoading = false;
  bool hasCheckedSession = false;
  String? error;

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

  Future<void> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final cleanEmail = email.trim();
      if (!AppValidators.isValidEmail(cleanEmail) || password.length < 6) {
        throw const AuthException(
          'Nhập email hợp lệ và mật khẩu ít nhất 6 ký tự.',
        );
      }
      user = await _service.login(cleanEmail, password);
    } on AuthException catch (exception) {
      error = exception.message;
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
    String role,
    String university,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final cleanEmail = email.trim();
      final cleanName = fullName.trim();
      final cleanUniversity = university.trim();
      if (!AppValidators.isValidEmail(cleanEmail) || password.length < 6) {
        throw const AuthException(
          'Nhập email hợp lệ và mật khẩu ít nhất 6 ký tự.',
        );
      }
      if (cleanName.length < 2 || cleanUniversity.length < 2) {
        throw const AuthException('Họ tên và trường là bắt buộc.');
      }
      user = await _service.register(
        fullName: cleanName,
        email: cleanEmail,
        password: password,
        role: role,
        university: cleanUniversity,
      );
    } on AuthException catch (exception) {
      error = exception.message;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _service.logout();
    user = null;
    notifyListeners();
  }

  Future<void> updateProfile(String fullName, String university) async {
    final current = user;
    if (current == null) return;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      if (fullName.trim().length < 2 || university.trim().length < 2) {
        throw const AuthException('Họ tên và trường là bắt buộc.');
      }
      user = await _service.updateProfile(
        userId: current.id,
        fullName: fullName.trim(),
        university: university.trim(),
      );
    } on AuthException catch (exception) {
      error = exception.message;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }
}
