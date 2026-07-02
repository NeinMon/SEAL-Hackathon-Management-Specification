import '../../../shared.dart';
import '../widgets/notification_list.dart';

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
        context.read<NotificationProvider>().watchForUser(user.id);
        context.read<NotificationProvider>().clearScoreAlert();
      }
    });
  }

  Future<void> _refresh(String userId) async {
    await context.read<NotificationProvider>().loadForUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final notifications = provider.visibleNotifications;
    final user = context.watch<AuthProvider>().user;

    if (provider.error != null && provider.notifications.isEmpty) {
      return RefreshableListView(
        onRefresh: user == null ? () async {} : () => _refresh(user.id),
        children: [
          const SealSectionHeader(
            title: AppStrings.inboxTitle,
            subtitle: AppStrings.inboxSubtitle,
            icon: Icons.notifications_outlined,
          ),
          ErrorState(
            message: provider.error!,
            onRetry: user == null ? null : () => provider.watchForUser(user.id),
          ),
        ],
      );
    }

    if (provider.isLoading && provider.notifications.isEmpty) {
      return RefreshableListView(
        onRefresh: user == null ? () async {} : () => _refresh(user.id),
        children: const [
          SealSectionHeader(
            title: AppStrings.inboxTitle,
            subtitle: AppStrings.inboxSubtitle,
            icon: Icons.notifications_outlined,
          ),
          LoadingCardList(itemCount: 3),
        ],
      );
    }

    if (provider.notifications.isEmpty) {
      return RefreshableListView(
        onRefresh: user == null ? () async {} : () => _refresh(user.id),
        children: [
          const SealSectionHeader(
            title: AppStrings.inboxTitle,
            subtitle: AppStrings.inboxSubtitle,
            icon: Icons.notifications_outlined,
          ),
          EmptyState(
            message: AppStrings.inboxEmpty,
            icon: Icons.mark_email_read_outlined,
            actionLabel: user == null ? null : AppStrings.reloadInboxAction,
            onAction: user == null
                ? null
                : () => provider.watchForUser(user.id),
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

    return RefreshableListView(
      onRefresh: user == null ? () async {} : () => _refresh(user.id),
      children: [
        const SealSectionHeader(
          title: AppStrings.inboxTitle,
          subtitle: AppStrings.inboxSubtitle,
          icon: Icons.notifications_outlined,
        ),
        if (unread.isNotEmpty) ...[
          NotificationGroupTitle(
            label: AppStrings.unreadGroup,
            count: unread.length,
          ),
          NotificationList(notifications: unread),
        ],
        if (read.isNotEmpty) ...[
          NotificationGroupTitle(
            label: AppStrings.readGroup,
            count: read.length,
          ),
          NotificationList(notifications: read),
        ],
        if (provider.hasMoreNotifications)
          LoadMoreButton(onPressed: provider.loadMoreNotifications),
      ],
    );
  }
}
