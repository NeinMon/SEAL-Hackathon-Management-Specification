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
    final formKey = GlobalKey<FormState>();
    final compact = MediaQuery.sizeOf(context).width < 640;
    final form = _InviteMemberForm(
      formKey: formKey,
      controller: controller,
      team: team,
      event: event,
    );
    final email = compact
        ? await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (dialogContext) => Padding(
              padding: EdgeInsets.only(
                left: AppSizes.paddingMedium,
                right: AppSizes.paddingMedium,
                top: AppSizes.paddingMedium,
                bottom:
                    MediaQuery.viewInsetsOf(dialogContext).bottom +
                    AppSizes.paddingMedium,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          L10nService.strings.inviteMemberTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: context.l10n.cancelButton,
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  form,
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        Navigator.of(dialogContext).pop(controller.text.trim());
                      },
                      icon: Icon(Icons.send_outlined),
                      label: Text(context.l10n.sendInvitationButton),
                    ),
                  ),
                ],
              ),
            ),
          )
        : await showDialog<String>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(context.l10n.inviteMemberTitle),
              content: form,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(context.l10n.cancelButton),
                ),
                FilledButton(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    Navigator.of(dialogContext).pop(controller.text.trim());
                  },
                  child: Text(context.l10n.sendInvitationButton),
                ),
              ],
            ),
          );
    controller.dispose();
    if (email == null || email.isEmpty || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.invitationSendingStatus)),
    );
    final teamProvider = context.read<TeamProvider>();
    await teamProvider.inviteMember(team.id, email, event: event);
    if (!context.mounted) return;
    if (teamProvider.error != null) return;
    final invited = await const UserDirectoryService().findByEmail(email);
    if (!context.mounted) return;
    if (invited != null && event != null) {
      await context.read<NotificationProvider>().push(
        L10nService.strings.teamInvitationTitle,
        NotificationLink.encodeEvent(
          eventId: event.id,
          content: L10nService.strings.teamInvitationBody(team.name),
        ),
        'invitation',
        userId: invited.id,
        actionLabel: L10nService.strings.notificationActionGoTeams,
        deepRoute: RouteQuery.teamsForEvent(event.id),
      );
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.invitationSentSuccess)),
      );
  }
}

class _InviteMemberForm extends StatelessWidget {
  const _InviteMemberForm({
    required this.formKey,
    required this.controller,
    required this.team,
    required this.event,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final Team team;
  final HackathonEvent? event;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.strings.inviteTeamPrefix(team.name),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          if (event != null) ...[
            const SizedBox(height: 4),
            Text(
              event!.title,
              style: TextStyle(color: context.sealTheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            validator: AppValidators.inviteEmail,
            decoration: InputDecoration(
              labelText: L10nService.strings.memberEmailLabel,
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
        ],
      ),
    );
  }
}
