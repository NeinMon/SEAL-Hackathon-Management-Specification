import '../../../shared.dart';

class OrganizerTeamDetailsDialog {
  const OrganizerTeamDetailsDialog._();

  static Future<void> show(BuildContext context, Team team) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(team.name),
        content: SizedBox(
          width: 420,
          child: ListView(
            shrinkWrap: true,
            children: [
              StatusPill(
                label: L10nService.strings.memberCountLabel(team.members.length),
                icon: Icons.groups_outlined,
              ),
              const SizedBox(height: AppSizes.paddingCompact),
              for (final member in team.members)
                ListTile(
                  leading: Icon(
                    member.id == team.leaderId
                        ? Icons.verified_outlined
                        : Icons.person_outline,
                  ),
                  title: Text(member.fullName),
                  subtitle: Text(
                    '${member.email}\n${AppRoles.label(member.role)}',
                  ),
                  isThreeLine: true,
                ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.doneButton),
          ),
        ],
      ),
    );
  }
}
