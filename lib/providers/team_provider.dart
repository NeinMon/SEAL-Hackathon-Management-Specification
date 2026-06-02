import 'package:flutter/foundation.dart';

import '../core/app_helpers.dart';
import '../models/app_user.dart';
import '../models/hackathon_event.dart';
import '../models/team.dart';
import '../services/supabase_services.dart';

class TeamProvider extends ChangeNotifier {
  final TeamService _service = const TeamService();
  List<Team> teams = [];
  bool isLoading = false;
  String? message;
  String? error;

  Future<void> loadTeams() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      teams = await _service.fetchTeams();
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createTeam(
    String name,
    HackathonEvent event,
    AppUser leader,
  ) async {
    if (isLoading) return;
    error = null;
    message = null;
    final cleanName = name.trim();
    if (cleanName.length < 2) {
      error = 'Tên team cần ít nhất 2 ký tự.';
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.createTeam(
        name: cleanName,
        eventId: event.id,
        leaderId: leader.id,
      );
      await loadTeams();
      message = 'Đã tạo team.';
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> joinTeam(
    String teamId,
    AppUser user, {
    HackathonEvent? event,
  }) async {
    if (isLoading) return;
    error = null;
    message = null;
    final team = _teamById(teamId);
    if (team != null && team.members.any((member) => member.id == user.id)) {
      error = 'Bạn đã là thành viên của team này.';
      notifyListeners();
      return;
    }
    if (team != null &&
        event != null &&
        event.maxTeamSize > 0 &&
        team.members.length >= event.maxTeamSize) {
      error = '${team.name} đã đủ thành viên cho event này.';
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.joinTeam(teamId, user.id);
      await loadTeams();
      message = 'Đã tham gia team.';
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> inviteMember(
    String teamId,
    String email, {
    HackathonEvent? event,
  }) async {
    if (isLoading) return;
    error = null;
    message = null;
    final cleanEmail = email.trim();
    if (!AppValidators.isValidEmail(cleanEmail)) {
      error = 'Nhập email thành viên hợp lệ.';
      notifyListeners();
      return;
    }
    final team = _teamById(teamId);
    if (team != null &&
        event != null &&
        event.maxTeamSize > 0 &&
        team.members.length >= event.maxTeamSize) {
      error = '${team.name} đã đủ thành viên cho event này.';
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.inviteMemberByEmail(teamId, cleanEmail);
      await loadTeams();
      message = 'Đã gửi lời mời.';
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> updateTeamName(String teamId, String name) async {
    if (isLoading) return;
    error = null;
    message = null;
    final cleanName = name.trim();
    if (cleanName.length < 2) {
      error = 'Tên team cần ít nhất 2 ký tự.';
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.updateTeamName(teamId, cleanName);
      await loadTeams();
      message = 'Đã cập nhật team.';
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> leaveTeam(String teamId, AppUser user) async {
    if (isLoading) return;
    error = null;
    message = null;
    isLoading = true;
    notifyListeners();
    try {
      await _service.leaveTeam(teamId, user.id);
      await loadTeams();
      message = 'Đã rời team.';
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
      isLoading = false;
    }
    notifyListeners();
  }

  Team? _teamById(String teamId) {
    for (final team in teams) {
      if (team.id == teamId) return team;
    }
    return null;
  }

  void clear() {
    teams = [];
    error = null;
    message = null;
    isLoading = false;
    notifyListeners();
  }
}
