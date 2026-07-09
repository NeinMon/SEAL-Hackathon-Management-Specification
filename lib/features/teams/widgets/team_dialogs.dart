import '../../../shared.dart';

class TeamDialogs {
  const TeamDialogs._();

  static Future<String?> editTeamName(BuildContext context, Team team) async {
    final controller = TextEditingController(text: team.name);
    try {
      return await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.l10n.updateTeamDialogTitle),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: L10nService.strings.teamNameLabel,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.cancelButton),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: Text(context.l10n.saveButton),
            ),
          ],
        ),
      );
    } finally {
      controller.dispose();
    }
  }

  static Future<bool> confirmLeave(BuildContext context, Team team) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.leaveTeamDialogTitle),
        content: Text(context.l10n.leaveTeamDialogBody(team.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.leaveTeamButton),
          ),
        ],
      ),
    );
    return shouldLeave == true;
  }
}
