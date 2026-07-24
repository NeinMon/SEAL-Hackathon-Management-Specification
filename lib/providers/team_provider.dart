import '../core/l10n/l10n_service.dart';
import 'package:flutter/foundation.dart';

import '../core/app_helpers.dart';
import '../core/helpers/workspace_catalog.dart';
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

  Future<void> loadTeams({String? eventId}) async {
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
      teams = await _service.fetchTeams(eventId: eventId);
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

  int pendingInvitationCountFor(String userId) {
    return invitations
        .where(
          (invitation) =>
              invitation.isPending && invitation.inviteeId == userId,
        )
        .length;
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
      error = L10nService.strings.alreadyOnEventTeamNamedError(existingTeam.name);
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
      message = L10nService.strings.teamCreatedSuccess;
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
    error = L10nService.strings.teamInviteOnlyError;
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
    final resolvedEvent =
        event ?? WorkspaceCatalog.eventForTeam(team ?? _teamById(teamId));
    if (resolvedEvent == null) {
      error = L10nService.strings.errorEventContextRequired;
      notifyListeners();
      return;
    }
    if (team != null &&
        resolvedEvent.maxTeamSize > 0 &&
        team.members.length >= resolvedEvent.maxTeamSize) {
      error = L10nService.strings.teamFullForEventError(team.name);
      notifyListeners();
      return;
    }
    final registrationError = resolvedEvent.registrationBlockReason();
    if (registrationError != null) {
      error = registrationError;
      notifyListeners();
      return;
    }
    if (team != null) {
      final normalizedEmail = email.trim().toLowerCase();
      if (team.members.any(
        (member) => member.email.toLowerCase() == normalizedEmail,
      )) {
        error = L10nService.strings.alreadyTeamMemberError;
        notifyListeners();
        return;
      }
      for (final candidate in teams) {
        if (candidate.eventId != resolvedEvent.id) continue;
        if (candidate.id == teamId) continue;
        for (final member in candidate.members) {
          if (member.email.toLowerCase() != normalizedEmail) continue;
          error = L10nService.strings.alreadyOnEventTeamNamedError(
            candidate.name,
          );
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
      message = L10nService.strings.invitationSentSuccess;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptInvitation(
    TeamInvitation invitation,
    AppUser user, {
    HackathonEvent? event,
  }) async {
    if (isLoading) return;
    error = null;
    message = null;
    if (!invitation.isPending) {
      error = L10nService.strings.invitationNoLongerPending;
      notifyListeners();
      return;
    }
    final team = invitation.team ?? _teamById(invitation.teamId);
    final resolvedEvent =
        event ?? WorkspaceCatalog.eventForTeam(team);
    if (resolvedEvent == null) {
      error = L10nService.strings.errorEventContextRequired;
      notifyListeners();
      return;
    }
    if (team != null && team.members.any((member) => member.id == user.id)) {
      error = L10nService.strings.alreadyTeamMemberError;
      notifyListeners();
      return;
    }
    final registrationError = resolvedEvent.registrationBlockReason();
    if (registrationError != null) {
      error = registrationError;
      notifyListeners();
      return;
    }
    if (team != null &&
        resolvedEvent.maxTeamSize > 0 &&
        team.members.length >= resolvedEvent.maxTeamSize) {
      error = L10nService.strings.teamFullForEventError(team.name);
      notifyListeners();
      return;
    }
    final existingTeam = TeamMembership.teamForUserOnEvent(
      teams: teams,
      userId: user.id,
      eventId: resolvedEvent.id,
      excludeTeamId: invitation.teamId,
    );
    if (existingTeam != null) {
      error = L10nService.strings.alreadyOnEventTeamNamedError(existingTeam.name);
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
      await _service.acceptInvitation(invitation);
      await loadTeamWorkspace(user);
      message = L10nService.strings.invitationAcceptedSuccess;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
      isLoading = false;
    }
    notifyListeners();
  }

  Future<bool> acceptLatestInvitationFromEmail(AppUser user) async {
    if (isLoading) return false;
    final configError = AppValidators.requireSupabaseReady();
    if (configError != null) {
      error = configError;
      notifyListeners();
      return false;
    }
    isLoading = true;
    error = null;
    message = null;
    notifyListeners();
    try {
      final accepted = await _service.acceptLatestInvitationForUser(user.id);
      await loadTeamWorkspace(user);
      if (accepted == null) {
        message = 'Khong co loi moi dang cho cho tai khoan nay.';
        notifyListeners();
        return false;
      }
      message = L10nService.strings.invitationAcceptedSuccess;
      notifyListeners();
      return true;
    } catch (exception) {
      error = FriendlyErrorMapper.message(exception);
      isLoading = false;
      notifyListeners();
      return false;
    }
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
      message = L10nService.strings.invitationDeclinedSuccess;
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
      message = L10nService.strings.teamUpdatedSuccess;
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
      error = L10nService.strings.invalidTeamError;
      notifyListeners();
      return;
    }
    final team = _teamById(teamId);
    final event = WorkspaceCatalog.eventForTeam(team);
    if (event != null && !event.registrationOpen()) {
      error = L10nService.strings.leaveTeamRegistrationClosedError;
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
      message = L10nService.strings.teamLeftSuccess;
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
