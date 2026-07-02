import '../../../shared.dart';

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
        const Text(
          AppStrings.teamDetailsTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (visible.isEmpty)
          const EmptyState(message: AppStrings.noTeamsToView)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visible.take(5).length,
            itemBuilder: (context, index) {
              final team = visible[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.groups_outlined),
                  title: Text(team.name),
                  subtitle: Text(
                    AppStrings.memberCountLabel(team.members.length),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => onTapTeam(team),
                ),
              );
            },
          ),
      ],
    );
  }
}
