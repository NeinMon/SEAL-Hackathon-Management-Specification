import '../../../shared.dart';

class OrganizerTeamsSection extends StatelessWidget {
  const OrganizerTeamsSection({
    super.key,
    required this.teams,
    required this.onTapTeam,
  });

  final TeamProvider teams;
  final void Function(Team team) onTapTeam;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          AppStrings.teamDetailsTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (teams.teams.isEmpty)
          const EmptyState(message: AppStrings.noTeamsToView)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: teams.teams.take(5).length,
            itemBuilder: (context, index) {
              final team = teams.teams[index];
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
