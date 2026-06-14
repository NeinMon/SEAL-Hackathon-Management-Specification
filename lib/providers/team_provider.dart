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
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
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
    final nameError = AppValidators.teamName(name);
    if (nameError != null) {
      error = nameError;
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.createTeam(
        name: name.trim(),
        eventId: event.id,
        leaderId: leader.id,
      );
      await loadTeams();
      message = AppStrings.teamCreatedSuccess;
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
    if (teamId.trim().isEmpty) {
      error = AppStrings.invalidTeamError;
      notifyListeners();
      return;
    }
    final team = _teamById(teamId);
    if (team != null && team.members.any((member) => member.id == user.id)) {
      error = AppStrings.alreadyTeamMemberError;
      notifyListeners();
      return;
    }
    if (team != null &&
        event != null &&
        event.maxTeamSize > 0 &&
        team.members.length >= event.maxTeamSize) {
      error = AppStrings.teamFullForEventError(team.name);
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.joinTeam(teamId, user.id);
      await loadTeams();
      message = AppStrings.teamJoinedSuccess;
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
    final emailError = AppValidators.inviteEmail(email);
    if (emailError != null) {
      error = emailError;
      notifyListeners();
      return;
    }
    final team = _teamById(teamId);
    if (team != null &&
        event != null &&
        event.maxTeamSize > 0 &&
        team.members.length >= event.maxTeamSize) {
      error = AppStrings.teamFullForEventError(team.name);
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.inviteMemberByEmail(teamId, email.trim());
      await loadTeams();
      message = AppStrings.invitationSentSuccess;
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
    final nameError = AppValidators.teamName(name);
    if (nameError != null) {
      error = nameError;
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.updateTeamName(teamId, name.trim());
      await loadTeams();
      message = AppStrings.teamUpdatedSuccess;
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
    if (teamId.trim().isEmpty) {
      error = AppStrings.invalidTeamError;
      notifyListeners();
      return;
    }
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.leaveTeam(teamId, user.id);
      await loadTeams();
      message = AppStrings.teamLeftSuccess;
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
