import '../../shared.dart';

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
    final user = context.watch<AuthProvider>().user;
    if (provider.error != null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SealSectionHeader(
            title: 'Inbox',
            subtitle: 'Thông báo hệ thống, điểm số và lời mời vào team.',
            icon: Icons.notifications_outlined,
          ),
          ErrorState(
            message: provider.error!,
            onRetry: user == null ? null : () => provider.loadForUser(user.id),
          ),
        ],
      );
    }
    if (provider.isLoading) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SealSectionHeader(
            title: 'Inbox',
            subtitle: 'Thông báo hệ thống, điểm số và lời mời vào team.',
            icon: Icons.notifications_outlined,
          ),
          LoadingCardList(itemCount: 3),
        ],
      );
    }
    if (notifications.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SealSectionHeader(
            title: 'Inbox',
            subtitle: 'Thông báo hệ thống, điểm số và lời mời vào team.',
            icon: Icons.notifications_outlined,
          ),
          EmptyState(
            message: 'Inbox đang trống.',
            icon: Icons.mark_email_read_outlined,
            actionLabel: user == null ? null : 'Tải lại Inbox',
            onAction: user == null ? null : () => provider.loadForUser(user.id),
          ),
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
          subtitle: 'Thông báo hệ thống, điểm số và lời mời vào team.',
          icon: Icons.notifications_outlined,
        ),
        if (unread.isNotEmpty) ...[
          _NotificationGroupTitle(label: 'Chưa đọc', count: unread.length),
          _NotificationList(notifications: unread),
        ],
        if (read.isNotEmpty) ...[
          _NotificationGroupTitle(label: 'Đã đọc', count: read.length),
          _NotificationList(notifications: read),
        ],
      ],
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({required this.notifications});

  final List<AppNotification> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) =>
          _NotificationTile(notification: notifications[index]),
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
    final style = _styleFor(notification.type, notification.isRead);
    return Semantics(
      button: true,
      label:
          '${notification.isRead ? 'Đã đọc' : 'Chưa đọc'} ${notification.title}',
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
            tooltip: 'Thao tác thông báo',
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
                    title: Text('Đánh dấu đã đọc'),
                  ),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Xóa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _NotificationVisual _styleFor(String type, bool isRead) {
    final muted = isRead ? SealPalette.onSurfaceVariant : null;
    switch (type) {
      case 'score':
        return _NotificationVisual(
          Icons.leaderboard_outlined,
          muted ?? SealPalette.secondary,
        );
      case 'invitation':
        return _NotificationVisual(
          Icons.group_add_outlined,
          muted ?? SealPalette.primary,
        );
      case 'announcement':
        return _NotificationVisual(
          Icons.campaign_outlined,
          muted ?? SealPalette.tertiary,
        );
      case 'system':
      default:
        return _NotificationVisual(
          Icons.shield_outlined,
          muted ?? SealPalette.indigo,
        );
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa thông báo?'),
        content: const Text('Thông báo sẽ bị xóa khỏi Inbox.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xóa'),
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

class _NotificationVisual {
  const _NotificationVisual(this.icon, this.color);

  final IconData icon;
  final Color color;
}
