import 'package:flutter/foundation.dart';

class OrganizerDashboardUiProvider extends ChangeNotifier {
  bool suppressAppShellBottomNav = false;

  void setAdvancedMode(bool value) {
    if (suppressAppShellBottomNav == value) return;
    suppressAppShellBottomNav = value;
    notifyListeners();
  }
}
