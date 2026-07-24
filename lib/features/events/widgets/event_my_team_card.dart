import '../../../shared.dart';
import '../../teams/widgets/team_member_avatar.dart';

class EventMyTeamCard extends StatelessWidget {
  const EventMyTeamCard({super.key, required this.team, required this.event});

  final Team team;
  final HackathonEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MemberAvatarStack(members: team.members),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10nService.strings.myTeamForEventTitle,
                        style: TextStyle(
                          color: context.sealTheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        team.name,
                        style: TextStyle(
                          color: context.onSurfaceColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        L10nService.strings.memberCountLabel(team.members.length),
                        style: TextStyle(
                          color: context.sealTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (team.members.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final member in team.members)
                    StatusPill(label: member.fullName),
                ],
              ),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => context.go(RouteQuery.teamsForEvent(event.id)),
              icon: Icon(Icons.groups_outlined),
              label: Text(context.l10n.viewMyTeamButton),
            ),
          ],
        ),
      ),
    );
  }
}
