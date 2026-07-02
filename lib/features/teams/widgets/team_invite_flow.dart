import '../../../shared.dart';

class TeamInviteFlow {
  const TeamInviteFlow._();

  static Future<void> show(
    BuildContext context, {
    required Team team,
    required HackathonEvent? event,
  }) async {
    if (event != null) {
      final blockReason = event.registrationBlockReason();
      if (blockReason != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(blockReason)));
        return;
      }
    }
    final controller = TextEditingController();
    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.inviteMemberTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.inviteTeamPrefix(team.name),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            if (event != null) ...[
              const SizedBox(height: 4),
              Text(
                event.title,
                style: const TextStyle(color: SealPalette.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: AppStrings.memberEmailLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text(AppStrings.sendInvitationButton),
          ),
        ],
      ),
    );
    if (email == null || email.isEmpty || !context.mounted) return;
    final teamProvider = context.read<TeamProvider>();
    await teamProvider.inviteMember(team.id, email, event: event);
    if (!context.mounted) return;
    if (teamProvider.error != null) return;
    final invited = await const UserDirectoryService().findByEmail(email);
    if (!context.mounted) return;
    if (invited != null) {
      await context.read<NotificationProvider>().push(
        AppStrings.teamInvitationTitle,
        AppStrings.teamInvitationBody(team.name),
        'invitation',
        userId: invited.id,
      );
    }
  }
}
