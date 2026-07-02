import 'package:flutter/foundation.dart';

import '../core/app_helpers.dart';
import '../core/team_membership.dart';
import '../models/app_user.dart';
import '../models/hackathon_event.dart';
import '../models/team.dart';
import '../models/team_invitation.dart';
import '../services/supabase_services.dart';

class TeamProvider extends ChangeNotifier {
  final TeamService _service = const TeamService();
  List<Team> teams = [];
  List<TeamInvitation> invitations = [];
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

  Future<void> loadInvitations(AppUser? user) async {
    if (user == null) {
      invitations = [];
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
    error = null;
    notifyListeners();
    try {
      invitations = await _service.fetchInvitationsForUser(user.id);
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadTeamWorkspace(AppUser? user) async {
    await loadTeams();
    if (error != null) return;
    await loadInvitations(user);
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
    final registrationError = event.registrationBlockReason();
    if (registrationError != null) {
      error = registrationError;
      notifyListeners();
      return;
    }
    final existingTeam = TeamMembership.teamForUserOnEvent(
      teams: teams,
      userId: leader.id,
      eventId: event.id,
    );
    if (existingTeam != null) {
      error = AppStrings.alreadyOnEventTeamNamedError(existingTeam.name);
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
    if (event != null) {
      final registrationError = event.registrationBlockReason();
      if (registrationError != null) {
        error = registrationError;
        notifyListeners();
        return;
      }
      final existingTeam = TeamMembership.teamForUserOnEvent(
        teams: teams,
        userId: user.id,
        eventId: event.id,
        excludeTeamId: teamId,
      );
      if (existingTeam != null) {
        error = AppStrings.alreadyOnEventTeamNamedError(existingTeam.name);
        notifyListeners();
        return;
      }
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
    if (team != null && event != null) {
      final registrationError = event.registrationBlockReason();
      if (registrationError != null) {
        error = registrationError;
        notifyListeners();
        return;
      }
      final normalizedEmail = email.trim().toLowerCase();
      for (final candidate in teams) {
        if (candidate.eventId != event.id) continue;
        for (final member in candidate.members) {
          if (member.email.toLowerCase() != normalizedEmail) continue;
          if (candidate.id == teamId) continue;
          error = AppStrings.alreadyOnEventTeamNamedError(candidate.name);
          notifyListeners();
          return;
        }
      }
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
      message = AppStrings.invitationSentSuccess;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> acceptInvitation(
    TeamInvitation invitation,
    AppUser user, {
    HackathonEvent? event,
  }) async {
    if (isLoading) return;
    error = null;
    message = null;
    final team = invitation.team ?? _teamById(invitation.teamId);
    if (team != null && team.members.any((member) => member.id == user.id)) {
      error = AppStrings.alreadyTeamMemberError;
      notifyListeners();
      return;
    }
    if (event != null) {
      final registrationError = event.registrationBlockReason();
      if (registrationError != null) {
        error = registrationError;
        notifyListeners();
        return;
      }
      if (team != null &&
          event.maxTeamSize > 0 &&
          team.members.length >= event.maxTeamSize) {
        error = AppStrings.teamFullForEventError(team.name);
        notifyListeners();
        return;
      }
      final existingTeam = TeamMembership.teamForUserOnEvent(
        teams: teams,
        userId: user.id,
        eventId: event.id,
        excludeTeamId: invitation.teamId,
      );
      if (existingTeam != null) {
        error = AppStrings.alreadyOnEventTeamNamedError(existingTeam.name);
        notifyListeners();
        return;
      }
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
      await _service.acceptInvitation(invitation);
      await loadTeamWorkspace(user);
      message = AppStrings.invitationAcceptedSuccess;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> declineInvitation(String invitationId, AppUser user) async {
    if (isLoading) return;
    error = null;
    message = null;
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      await _service.declineInvitation(invitationId);
      await loadInvitations(user);
      message = AppStrings.invitationDeclinedSuccess;
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
    invitations = [];
    error = null;
    message = null;
    isLoading = false;
    notifyListeners();
  }
}
