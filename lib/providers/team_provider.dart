part of '../main.dart';

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
      error = exception.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createTeam(
    String name,
    HackathonEvent event,
    AppUser leader,
  ) async {
    error = null;
    message = null;
    final cleanName = name.trim();
    if (cleanName.length < 2) {
      error = 'Team name must be at least 2 characters.';
      notifyListeners();
      return;
    }
    try {
      await _service.createTeam(
        name: cleanName,
        eventId: event.id,
        leaderId: leader.id,
      );
      await loadTeams();
      message = 'Team created successfully.';
    } catch (exception) {
      error = exception.toString();
    }
    notifyListeners();
  }

  Future<void> joinTeam(String teamId, AppUser user) async {
    error = null;
    message = null;
    try {
      await _service.joinTeam(teamId, user.id);
      await loadTeams();
      message = 'Joined team successfully.';
    } catch (exception) {
      error = exception.toString();
    }
    notifyListeners();
  }

  Future<void> inviteMember(String teamId, String email) async {
    error = null;
    message = null;
    final cleanEmail = email.trim();
    if (!cleanEmail.contains('@')) {
      error = 'Enter a valid member email address.';
      notifyListeners();
      return;
    }
    try {
      await _service.inviteMemberByEmail(teamId, cleanEmail);
      await loadTeams();
      message = 'Invitation sent.';
    } catch (exception) {
      error = exception.toString();
    }
    notifyListeners();
  }

  Future<void> updateTeamName(String teamId, String name) async {
    error = null;
    message = null;
    final cleanName = name.trim();
    if (cleanName.length < 2) {
      error = 'Team name must be at least 2 characters.';
      notifyListeners();
      return;
    }
    try {
      await _service.updateTeamName(teamId, cleanName);
      await loadTeams();
      message = 'Team updated successfully.';
    } catch (exception) {
      error = exception.toString();
    }
    notifyListeners();
  }

  Future<void> leaveTeam(String teamId, AppUser user) async {
    error = null;
    message = null;
    try {
      await _service.leaveTeam(teamId, user.id);
      await loadTeams();
      message = 'Left team successfully.';
    } catch (exception) {
      error = exception.toString();
    }
    notifyListeners();
  }
}
