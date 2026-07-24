import '../../../shared.dart';

class TeamScreenViewData {
  const TeamScreenViewData({
    required this.user,
    required this.selectedEvent,
    required this.loading,
    required this.myTeams,
    required this.pendingInvitations,
    required this.scopedTeams,
    required this.myTeamForSelectedEvent,
    required this.otherTeams,
    required this.visibleMyTeams,
    required this.canCreateTeamRole,
    required this.canCreateTeam,
    required this.filterEventId,
  });

  final AppUser? user;
  final HackathonEvent? selectedEvent;
  final bool loading;
  final List<Team> myTeams;
  final List<TeamInvitation> pendingInvitations;
  final List<Team> scopedTeams;
  final Team? myTeamForSelectedEvent;
  final List<Team> otherTeams;
  final List<Team> visibleMyTeams;
  final bool canCreateTeamRole;
  final bool canCreateTeam;
  final String? filterEventId;

  static TeamScreenViewData compute({
    required AppUser? user,
    required EventProvider events,
    required TeamProvider teams,
    required HackathonEvent? selectedEvent,
    required String? routeEventId,
  }) {
    final loading = events.isLoading || teams.isLoading;
    final myTeams = user == null
        ? <Team>[]
        : teams.teams
              .where(
                (team) => team.members.any((member) => member.id == user.id),
              )
              .toList();
    final filterEventId = selectedEvent?.id ?? routeEventId;
    final allPendingInvitations = user == null
        ? <TeamInvitation>[]
        : teams.invitations
              .where(
                (invitation) =>
                    invitation.isPending && invitation.inviteeId == user.id,
              )
              .toList();
    final pendingInvitations = filterEventId == null
        ? allPendingInvitations
        : allPendingInvitations
              .where(
                (invitation) => invitation.team?.eventId == filterEventId,
              )
              .toList();
    final scopedTeams = filterEventId == null
        ? teams.teams
        : teams.teams.where((team) => team.eventId == filterEventId).toList();
    final myTeamForSelectedEvent = user == null || selectedEvent == null
        ? null
        : TeamMembership.teamForUserOnEvent(
            teams: teams.teams,
            userId: user.id,
            eventId: selectedEvent.id,
          );
    final otherTeams = user == null
        ? scopedTeams
        : scopedTeams
              .where(
                (team) => !team.members.any((member) => member.id == user.id),
              )
              .toList();
    final visibleMyTeams = filterEventId == null
        ? myTeams
        : myTeams.where((team) => team.eventId == filterEventId).toList();
    final canCreateTeamRole =
        user != null && AppRoles.participantCreators.contains(user.role);
    final canCreateTeam =
        canCreateTeamRole &&
        selectedEvent != null &&
        selectedEvent.registrationOpen() &&
        myTeamForSelectedEvent == null &&
        !loading;

    return TeamScreenViewData(
      user: user,
      selectedEvent: selectedEvent,
      loading: loading,
      myTeams: myTeams,
      pendingInvitations: pendingInvitations,
      scopedTeams: scopedTeams,
      myTeamForSelectedEvent: myTeamForSelectedEvent,
      otherTeams: otherTeams,
      visibleMyTeams: visibleMyTeams,
      canCreateTeamRole: canCreateTeamRole,
      canCreateTeam: canCreateTeam,
      filterEventId: filterEventId,
    );
  }

  static HackathonEvent? eventFor(String eventId, List<HackathonEvent> events) {
    for (final event in events) {
      if (event.id == eventId) return event;
    }
    return null;
  }
}
