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
      return StatusBanner(message: provider.error!, isError: true);
    }
    if (provider.isLoading) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SealSectionHeader(
            title: 'Notifications',
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
            title: 'Notifications',
            subtitle: 'System alerts, scoring updates, and team invitations.',
            icon: Icons.notifications_outlined,
          ),
          EmptyState(message: 'No notifications'),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Notifications',
          subtitle: 'System alerts, scoring updates, and team invitations.',
          icon: Icons.notifications_outlined,
        ),
        for (final notification in notifications)
          Card(
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
              leading: Icon(
                notification.isRead
                    ? Icons.mark_email_read_outlined
                    : Icons.mark_email_unread_outlined,
              ),
              title: Text(notification.title),
              subtitle: Text(
                '${notification.content}\nType: ${notification.type}',
              ),
              isThreeLine: true,
              trailing: notification.isRead
                  ? IconButton(
                      tooltip: 'Delete',
                      onPressed: () => context
                          .read<NotificationProvider>()
                          .deleteNotification(notification.id),
                      icon: const Icon(Icons.delete_outline),
                    )
                  : Wrap(
                      spacing: 4,
                      children: [
                        TextButton(
                          onPressed: () => context
                              .read<NotificationProvider>()
                              .markRead(notification.id),
                          child: const Text('Read'),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          onPressed: () => context
                              .read<NotificationProvider>()
                              .deleteNotification(notification.id),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
            ),
          ),
      ],
    );
  }
}
