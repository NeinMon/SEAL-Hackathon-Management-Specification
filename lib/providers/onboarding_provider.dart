import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  static const _storageKey = 'seal_demo_onboarding_v1';

  bool _completed = true;

  bool get shouldShow => !_completed;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    // Do not show internal demo onboarding by default.
    // Only show it when explicitly enabled in local storage (set to false).
    _completed = prefs.getBool(_storageKey) ?? true;
    notifyListeners();
  }

  Future<void> complete() async {
    if (_completed) return;
    _completed = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_storageKey, true);
  }
}
