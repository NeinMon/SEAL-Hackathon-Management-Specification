import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  static const _storageVersion = 'v2';
  String? _role;
  bool _completed = false;
  bool _loaded = false;

  bool get shouldShow => _loaded && !_completed;

  Future<void> loadForRole(String? role) async {
    if (role == null) {
      _role = null;
      _completed = true;
      _loaded = true;
      notifyListeners();
      return;
    }
    if (_role == role && _loaded) return;
    _role = role;
    final prefs = await SharedPreferences.getInstance();
    _completed = prefs.getBool(_key(role)) ?? false;
    _loaded = true;
    notifyListeners();
  }

  Future<void> complete() async {
    final role = _role;
    if (role == null || _completed) return;
    _completed = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(role), true);
  }

  Future<void> clear() async {
    _role = null;
    _completed = false;
    _loaded = false;
    notifyListeners();
  }

  String _key(String role) => 'seal_onboarding_${_storageVersion}_$role';
}
