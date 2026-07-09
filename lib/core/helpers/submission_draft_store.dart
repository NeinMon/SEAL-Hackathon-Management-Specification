import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SubmissionDraftStore {
  const SubmissionDraftStore._();

  static String _key(String teamId) => 'submission_draft_$teamId';

  static Future<void> save({
    required String teamId,
    required String projectName,
    required String github,
    required String video,
    required String description,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final empty =
        projectName.trim().isEmpty &&
        github.trim().isEmpty &&
        video.trim().isEmpty &&
        description.trim().isEmpty;
    if (empty) {
      await prefs.remove(_key(teamId));
      return;
    }
    await prefs.setString(
      _key(teamId),
      jsonEncode({
        'projectName': projectName,
        'github': github,
        'video': video,
        'description': description,
        'savedAt': DateTime.now().toIso8601String(),
      }),
    );
  }

  static Future<Map<String, String>?> load(String teamId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(teamId));
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return {
        'projectName': (decoded['projectName'] ?? '').toString(),
        'github': (decoded['github'] ?? '').toString(),
        'video': (decoded['video'] ?? '').toString(),
        'description': (decoded['description'] ?? '').toString(),
        'savedAt': (decoded['savedAt'] ?? '').toString(),
      };
    } catch (_) {
      await prefs.remove(_key(teamId));
      return null;
    }
  }

  static Future<void> clear(String teamId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(teamId));
  }
}
