import 'package:flutter/material.dart';
import 'package:seal_hackathon_app/l10n/app_localizations.dart';

Widget wrapLocalized(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('vi'),
    home: child,
  );
}

Widget wrapLocalizedWithProviders({
  required Widget child,
  List<InheritedWidget> providers = const [],
}) {
  Widget tree = wrapLocalized(child);
  for (final provider in providers.reversed) {
    tree = provider;
  }
  return tree;
}
