import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/l10n/l10n_service.dart';

class LocaleProvider extends ChangeNotifier {
  static const _storageKey = 'seal_locale_code_v1';

  Locale _locale = const Locale('vi');

  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey);
    _locale = switch (code) {
      'en' => const Locale('en'),
      'ja' => const Locale('ja'),
      _ => const Locale('vi'),
    };
    L10nService.setLocale(_locale);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    L10nService.setLocale(locale);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, locale.languageCode);
  }

  Future<void> toggleViEn() {
    return setLocale(
      _locale.languageCode == 'vi' ? const Locale('en') : const Locale('vi'),
    );
  }
}
