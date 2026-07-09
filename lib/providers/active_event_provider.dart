import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/helpers/active_event_resolver.dart';
import '../models/hackathon_event.dart';
import '../models/team.dart';

class ActiveEventProvider extends ChangeNotifier {
  static const _storageVersion = 'v2';
  String? _userId;
  String? _selectedEventId;
  bool _loaded = false;

  String? get selectedEventId => _selectedEventId;
  bool get isLoaded => _loaded;

  Future<void> loadForUser(String? userId) async {
    if (userId == null) {
      _userId = null;
      _selectedEventId = null;
      _loaded = true;
      notifyListeners();
      return;
    }
    if (_userId == userId && _loaded) return;
    _userId = userId;
    final prefs = await SharedPreferences.getInstance();
    _selectedEventId = prefs.getString(_key(userId));
    _loaded = true;
    notifyListeners();
  }

  Future<void> clear() async {
    _userId = null;
    _selectedEventId = null;
    _loaded = false;
    notifyListeners();
  }

  Future<void> setFromUserPick(String? eventId) async {
    final userId = _userId;
    if (userId == null) return;
    if (_selectedEventId == eventId) return;
    _selectedEventId = eventId;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (eventId == null) {
      await prefs.remove(_key(userId));
    } else {
      await prefs.setString(_key(userId), eventId);
    }
  }

  Future<void> syncContext({
    required List<HackathonEvent> events,
    required List<Team> teams,
    required String? userId,
    String? routeEventId,
  }) async {
    if (userId != null && userId != _userId) {
      await loadForUser(userId);
    }
    if (events.isEmpty) return;
    final resolved = ActiveEventResolver.resolveId(
      events: events,
      routeEventId: routeEventId,
      storedEventId: _selectedEventId,
      userId: userId,
      teams: teams,
    );
    if (resolved == null || resolved == _selectedEventId) return;
    if (routeEventId != null || _selectedEventId == null) {
      await setFromUserPick(resolved);
    }
  }

  HackathonEvent? eventFor({
    required List<HackathonEvent> events,
    String? routeEventId,
    List<Team> teams = const [],
    String? userId,
  }) {
    return ActiveEventResolver.resolveEvent(
      events: events,
      routeEventId: routeEventId,
      storedEventId: _selectedEventId,
      userId: userId,
      teams: teams,
    );
  }

  String _key(String userId) => 'seal_active_event_${_storageVersion}_$userId';
}
