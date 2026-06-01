part of '../../main.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<NotificationProvider>().loadForUser(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>().notifications;
    final provider = context.watch<NotificationProvider>();
    if (provider.error != null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SealSectionHeader(
            title: 'Inbox',
            subtitle: 'System alerts, scoring updates, and team invitations.',
            icon: Icons.notifications_outlined,
          ),
          StatusBanner(message: provider.error!, isError: true),
        ],
      );
    }
    if (provider.isLoading) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SealSectionHeader(
            title: 'Inbox',
            subtitle: 'System alerts, scoring updates, and team invitations.',
            icon: Icons.notifications_outlined,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }
    if (notifications.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SealSectionHeader(
            title: 'Inbox',
            subtitle: 'System alerts, scoring updates, and team invitations.',
            icon: Icons.notifications_outlined,
          ),
          EmptyState(message: 'No notifications'),
        ],
      );
    }
    final unread = notifications
        .where((notification) => !notification.isRead)
        .toList();
    final read = notifications
        .where((notification) => notification.isRead)
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Inbox',
          subtitle: 'System alerts, scoring updates, and team invitations.',
          icon: Icons.notifications_outlined,
        ),
        if (unread.isNotEmpty) ...[
          _NotificationGroupTitle(label: 'Unread', count: unread.length),
          for (final notification in unread)
            _NotificationTile(notification: notification),
        ],
        if (read.isNotEmpty) ...[
          _NotificationGroupTitle(label: 'Read', count: read.length),
          for (final notification in read)
            _NotificationTile(notification: notification),
        ],
      ],
    );
  }
}

class _NotificationGroupTitle extends StatelessWidget {
  const _NotificationGroupTitle({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(width: 8),
          StatusPill(label: '$count'),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () async {
          await context.read<NotificationProvider>().markRead(notification.id);
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
        leading: Icon(
          notification.isRead
              ? Icons.mark_email_read_outlined
              : Icons.mark_email_unread_outlined,
          color: notification.isRead
              ? SealPalette.onSurfaceVariant
              : SealPalette.primary,
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
          tooltip: 'Notification actions',
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
                  title: Text('Mark as read'),
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete notification?'),
        content: const Text('This removes the notification from your inbox.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
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
