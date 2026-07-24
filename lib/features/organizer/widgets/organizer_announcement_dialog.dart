import '../../../shared.dart';
import 'organizer_announcement_form.dart';
import 'organizer_announcement_preview.dart';

class OrganizerAnnouncementDialog {
  const OrganizerAnnouncementDialog._();

  static Future<void> show(
    BuildContext context, {
    List<AppUser>? initialUsers,
    AnnouncementTemplate? initialTemplate,
    String? linkedEventId,
    String? actionLabel,
    String? deepRoute,
  }) async {
    final title = TextEditingController(text: initialTemplate?.title ?? '');
    final content = TextEditingController(text: initialTemplate?.content ?? '');
    final formKey = GlobalKey<FormState>();
    var role = initialTemplate?.role ?? 'all';
    String? selectedEventId = linkedEventId;
    final storedActionLabel = actionLabel;
    final storedDeepRoute = deepRoute;
    final events = context.read<EventProvider>().sortedEvents;
    final compact = MediaQuery.sizeOf(context).width < 640;
    final form = StatefulBuilder(
      builder: (dialogContext, setDialogState) => OrganizerAnnouncementForm(
        formKey: formKey,
        title: title,
        content: content,
        role: role,
        linkedEventId: selectedEventId,
        events: events,
        onRoleChanged: (value) => setDialogState(() => role = value),
        onEventChanged: (value) =>
            setDialogState(() => selectedEventId = value),
        onTemplateSelected: (template) {
          setDialogState(() {
            role = template.role;
            title.text = template.title;
            content.text = template.content;
          });
        },
      ),
    );
    final sent = compact
        ? await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (dialogContext) => FractionallySizedBox(
              heightFactor: 0.95,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(context.l10n.sendAnnouncementDialogTitle),
                  leading: IconButton(
                    tooltip: context.l10n.cancelButton,
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    icon: const Icon(Icons.close),
                  ),
                  actions: [
                    TextButton.icon(
                      onPressed: () {
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        Navigator.of(dialogContext).pop(true);
                      },
                      icon: const Icon(Icons.send_outlined),
                      label: Text(context.l10n.sendButton),
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingMedium),
                    child: form,
                  ),
                ),
              ),
            ),
          )
        : await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(context.l10n.sendAnnouncementDialogTitle),
              content: SizedBox(width: 520, child: form),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(context.l10n.cancelButton),
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    Navigator.of(dialogContext).pop(true);
                  },
                  icon: const Icon(Icons.send_outlined),
                  label: Text(context.l10n.sendButton),
                ),
              ],
            ),
          );

    final cleanTitle = title.text.trim();
    final cleanContent = content.text.trim();
    final encodedContent = selectedEventId == null || selectedEventId!.isEmpty
        ? cleanContent
        : NotificationLink.encodeEvent(
            eventId: selectedEventId!,
            content: cleanContent,
          );
    if (sent != true || !context.mounted) {
      title.dispose();
      content.dispose();
      return;
    }

    final users = selectedEventId == null || selectedEventId!.isEmpty
        ? (initialUsers ?? await const UserDirectoryService().fetchUsers())
        : await const UserDirectoryService().fetchUsersForEvent(
            eventId: selectedEventId!,
            role: role == 'all' ? null : role,
          );
    final recipients = selectedEventId == null || selectedEventId!.isEmpty
        ? users.where((user) => role == 'all' || user.role == role).toList()
        : users;
    if (!context.mounted) {
      title.dispose();
      content.dispose();
      return;
    }
    final confirmed = await OrganizerAnnouncementPreview.confirm(
      context,
      title: cleanTitle,
      content: cleanContent,
      role: role,
      eventTitle: selectedEventId == null
          ? L10nService.strings.announcementNoEvent
          : _eventTitleFor(events, selectedEventId!),
      recipientCount: recipients.length,
    );
    if (confirmed != true || !context.mounted) {
      title.dispose();
      content.dispose();
      return;
    }
    await _dispatch(
      context,
      recipients: recipients,
      title: cleanTitle,
      encodedContent: encodedContent,
      selectedEventId: selectedEventId,
      storedActionLabel: storedActionLabel,
      storedDeepRoute: storedDeepRoute,
    );
    title.dispose();
    content.dispose();
  }

  static Future<void> _dispatch(
    BuildContext context, {
    required List<AppUser> recipients,
    required String title,
    required String encodedContent,
    required String? selectedEventId,
    required String? storedActionLabel,
    required String? storedDeepRoute,
  }) async {
    final notifications = context.read<NotificationProvider>();
    final resolvedActionLabel = storedActionLabel ??
        (selectedEventId != null && selectedEventId.isNotEmpty
            ? L10nService.strings.notificationActionViewEvent
            : null);
    final resolvedDeepRoute = storedDeepRoute ??
        (selectedEventId != null && selectedEventId.isNotEmpty
            ? RouteQuery.overviewForEvent(selectedEventId)
            : null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.announcementSendingStatus)),
    );
    for (final user in recipients) {
      await notifications.push(
        title,
        encodedContent,
        'announcement',
        userId: user.id,
        actionLabel: resolvedActionLabel,
        deepRoute: resolvedDeepRoute,
      );
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.announcementSentSuccess(recipients.length)),
      ),
    );
  }

  static String? _eventTitleFor(List<HackathonEvent> events, String eventId) {
    for (final event in events) {
      if (event.id == eventId) return event.title;
    }
    return null;
  }
}
