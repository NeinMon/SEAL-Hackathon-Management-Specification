part of '../main.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = const AuthService();
  AppUser? user;
  bool isLoading = false;
  bool hasCheckedSession = false;
  String? error;

  AuthProvider() {
    _restoreSession();
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
      if (!email.contains('@') || password.length < 6) {
        throw const AuthException(
          'Enter a valid email and a password with at least 6 characters.',
        );
      }
      user = await _service.login(email, password);
    } on AuthException catch (exception) {
      error = exception.message;
    } catch (exception) {
      error = exception.toString();
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
      if (!email.contains('@') || password.length < 6) {
        throw const AuthException(
          'Enter a valid email and a password with at least 6 characters.',
        );
      }
      if (fullName.trim().length < 2 || university.trim().length < 2) {
        throw const AuthException('Full name and university are required.');
      }
      user = await _service.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        university: university,
      );
    } on AuthException catch (exception) {
      error = exception.message;
    } catch (exception) {
      error = exception.toString();
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
        throw const AuthException('Full name and university are required.');
      }
      user = await _service.updateProfile(
        userId: current.id,
        fullName: fullName.trim(),
        university: university.trim(),
      );
    } on AuthException catch (exception) {
      error = exception.message;
    } catch (exception) {
      error = exception.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
