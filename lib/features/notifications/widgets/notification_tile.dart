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
          onTap: () async {
            await context.read<NotificationProvider>().markRead(
              notification.id,
            );
            if (!context.mounted) return;
            switch (notification.type) {
              case 'invitation':
                context.go('/teams');
                break;
              case 'score':
                context.go('/events');
                break;
              case 'reminder':
                context.go('/map');
                break;
              case 'system':
              default:
                context.go('/events');
            }
          },
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
            '${notification.content}\n${DateFormat('dd/MM HH:mm').format(notification.createdAt)}',
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
