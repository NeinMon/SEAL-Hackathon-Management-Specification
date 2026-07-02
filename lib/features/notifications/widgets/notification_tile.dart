import '../../../shared.dart';

class NotificationVisual {
  const NotificationVisual(this.icon, this.color);

  final IconData icon;
  final Color color;
}

NotificationVisual notificationVisualFor(String type, bool isRead) {
  final muted = isRead ? SealPalette.onSurfaceVariant : null;
  switch (type) {
    case 'score':
      return NotificationVisual(
        Icons.leaderboard_outlined,
        muted ?? SealPalette.secondary,
      );
    case 'invitation':
      return NotificationVisual(
        Icons.group_add_outlined,
        muted ?? SealPalette.primary,
      );
    case 'announcement':
      return NotificationVisual(
        Icons.campaign_outlined,
        muted ?? SealPalette.tertiary,
      );
    case 'system':
    default:
      return NotificationVisual(
        Icons.shield_outlined,
        muted ?? SealPalette.indigo,
      );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final style = notificationVisualFor(notification.type, notification.isRead);
    return Semantics(
      button: true,
      label:
          '${notification.isRead ? AppStrings.readGroup : AppStrings.unreadGroup} ${notification.title}',
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          onTap: () => _handleTap(context),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: style.color.withValues(
                alpha: notification.isRead ? 0.08 : 0.16,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: style.color.withValues(alpha: 0.32)),
            ),
            child: Icon(style.icon, color: style.color),
          ),
          title: Text(
            notification.title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            '${NotificationLink.displayContent(notification.content)}\n${DateFormat('dd/MM HH:mm').format(notification.createdAt)}',
          ),
          isThreeLine: true,
          trailing: PopupMenuButton<String>(
            tooltip: AppStrings.notificationActionsTooltip,
            onSelected: (value) {
              if (value == 'read') {
                context.read<NotificationProvider>().markRead(notification.id);
              }
              if (value == 'delete') {
                _confirmDelete(context);
              }
            },
            itemBuilder: (context) => [
              if (!notification.isRead)
                const PopupMenuItem(
                  value: 'read',
                  child: ListTile(
                    leading: Icon(Icons.done),
                    title: Text(AppStrings.markAsReadAction),
                  ),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text(AppStrings.deleteButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    await context.read<NotificationProvider>().markRead(notification.id);
    if (!context.mounted) return;
    final role =
        context.read<AuthProvider>().user?.role ?? AppRoles.participant;
    switch (notification.type) {
      case 'score':
        await _showDetailDialog(
          context,
          title: AppStrings.scoreNotificationDialogTitle,
          actionLabel: role == AppRoles.participant
              ? AppStrings.viewSubmissionButton
              : AppStrings.detailsButton,
          destination: AppValidators.notificationRoute(
            type: notification.type,
            role: role,
          ),
          body: NotificationLink.displayContent(notification.content),
        );
        return;
      case 'announcement':
        final linkedEventId = NotificationLink.eventId(notification.content);
        await _showDetailDialog(
          context,
          title: AppStrings.announcementNotificationDialogTitle,
          actionLabel: linkedEventId == null
              ? AppStrings.closeDialogButton
              : AppStrings.viewEventFromAnnouncementButton,
          destination: linkedEventId == null ? null : '/events/$linkedEventId',
          body: NotificationLink.displayContent(notification.content),
        );
        return;
      default:
        final destination = AppValidators.notificationRoute(
          type: notification.type,
          role: role,
        );
        if (destination != null) {
          context.go(destination);
        }
    }
  }

  Future<void> _showDetailDialog(
    BuildContext context, {
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
              style: const TextStyle(color: SealPalette.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.closeDialogButton),
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
    if (!context.mounted || shouldNavigate != true || destination == null) {
      return;
    }
    context.go(destination);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteNotificationTitle),
        content: const Text(AppStrings.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.deleteButton),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !context.mounted) return;
    await context.read<NotificationProvider>().deleteNotification(
      notification.id,
    );
  }
}
