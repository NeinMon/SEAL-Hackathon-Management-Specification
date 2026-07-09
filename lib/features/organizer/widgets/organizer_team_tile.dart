import '../../../shared.dart';

class OrganizerTeamTile extends StatelessWidget {
  const OrganizerTeamTile({
    super.key,
    required this.team,
    required this.onTap,
  });

  final Team team;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.groups_outlined),
        title: Text(team.name),
        subtitle: Text(
          L10nService.strings.memberCountLabel(team.members.length),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
