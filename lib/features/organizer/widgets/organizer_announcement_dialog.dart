import '../../../shared.dart';

class OrganizerAnnouncementDialog {
  const OrganizerAnnouncementDialog._();

  static Future<void> show(BuildContext context) async {
    final title = TextEditingController();
    final content = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var role = 'all';
    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text(AppStrings.sendAnnouncementDialogTitle),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: role,
                    decoration: const InputDecoration(
                      labelText: AppStrings.recipientLabel,
                      prefixIcon: Icon(Icons.people_outline),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text(AppStrings.allFilter),
                      ),
                      DropdownMenuItem(
                        value: AppRoles.participant,
                        child: Text(AppStrings.roleParticipant),
                      ),
                      DropdownMenuItem(
                        value: AppRoles.mentor,
                        child: Text(AppStrings.roleMentor),
                      ),
                      DropdownMenuItem(
                        value: AppRoles.judge,
                        child: Text(AppStrings.roleJudge),
                      ),
                    ],
                    onChanged: (value) =>
                        setDialogState(() => role = value ?? 'all'),
                  ),
                  const SizedBox(height: AppSizes.paddingCompact),
                  TextFormField(
                    controller: title,
                    validator: AppValidators.notificationTitle,
                    decoration: const InputDecoration(
                      labelText: AppStrings.notificationTitleLabel,
                      prefixIcon: Icon(Icons.campaign_outlined),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingCompact),
                  TextFormField(
                    controller: content,
                    minLines: 3,
                    maxLines: 5,
                    validator: AppValidators.notificationBody,
                    decoration: const InputDecoration(
                      labelText: AppStrings.notificationContentLabel,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.cancelButton),
            ),
            FilledButton.icon(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;
                Navigator.of(dialogContext).pop(true);
              },
              icon: const Icon(Icons.send_outlined),
              label: const Text(AppStrings.sendButton),
            ),
          ],
        ),
      ),
    );

    final cleanTitle = title.text.trim();
    final cleanContent = content.text.trim();
    title.dispose();
    content.dispose();

    if (sent != true || !context.mounted) return;

    final notifications = context.read<NotificationProvider>();
    final users = await const UserDirectoryService().fetchUsers();
    final recipients = users
        .where((user) => role == 'all' || user.role == role)
        .toList();
    for (final user in recipients) {
      await notifications.push(
        cleanTitle,
        cleanContent,
        'announcement',
        userId: user.id,
      );
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.announcementSentSuccess(recipients.length)),
      ),
    );
  }
}
