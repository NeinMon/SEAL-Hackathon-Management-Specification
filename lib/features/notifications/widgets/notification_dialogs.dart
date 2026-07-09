import '../../../shared.dart';

class NotificationDialogs {
  const NotificationDialogs._();

  static Future<bool> showDetail(
    BuildContext context, {
    required AppNotification notification,
    required String title,
    required String actionLabel,
    String? destination,
    String? body,
  }) async {
    final message =
        body ?? NotificationLink.displayContent(notification.content);
    final shouldNavigate = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(message),
            const SizedBox(height: 8),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(notification.createdAt),
              style: TextStyle(color: context.sealTheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.closeDialogButton),
          ),
          if (destination != null)
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(actionLabel),
            )
          else
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(actionLabel),
            ),
        ],
      ),
    );
    return shouldNavigate == true;
  }

  static Future<bool> confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.deleteNotificationTitle),
        content: Text(context.l10n.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.deleteButton),
          ),
        ],
      ),
    );
    return shouldDelete == true;
  }
}
