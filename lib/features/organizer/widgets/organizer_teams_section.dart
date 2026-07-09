import '../../../shared.dart';
import 'organizer_team_tile.dart';

class OrganizerTeamsSection extends StatelessWidget {
  const OrganizerTeamsSection({
    super.key,
    required this.teams,
    required this.onTapTeam,
    this.focusEventId,
  });

  final TeamProvider teams;
  final void Function(Team team) onTapTeam;
  final String? focusEventId;

  List<Team> get _visibleTeams {
    if (focusEventId == null) return teams.teams;
    return EventScope.teamsForEvent(teams.teams, focusEventId!);
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleTeams;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          L10nService.strings.teamDetailsTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (visible.isEmpty)
          EmptyState(message: context.l10n.noTeamsToView)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visible.take(5).length,
            itemBuilder: (context, index) {
              final team = visible[index];
              return OrganizerTeamTile(
                team: team,
                onTap: () => onTapTeam(team),
              );
            },
          ),
      ],
    );
  }
}
