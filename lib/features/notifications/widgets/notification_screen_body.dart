import '../../../shared.dart';
import '../widgets/notification_list.dart';

enum NotificationViewState { error, loading, empty, content }

class NotificationScreenBody extends StatelessWidget {
  const NotificationScreenBody({
    super.key,
    required this.state,
    required this.provider,
    required this.user,
    required this.onRefresh,
    required this.onRetryWatch,
  });

  final NotificationViewState state;
  final NotificationProvider provider;
  final AppUser? user;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetryWatch;

  @override
  Widget build(BuildContext context) {
    final notifications = provider.visibleNotifications;
    final unread =
        notifications.where((notification) => !notification.isRead).toList();
    final read =
        notifications.where((notification) => notification.isRead).toList();

    return RefreshableListView(
      onRefresh: user == null ? () async {} : onRefresh,
      children: [
        SealSectionHeader(
          title: L10nService.strings.inboxTitle,
          subtitle: L10nService.strings.inboxSubtitle,
          icon: Icons.notifications_outlined,
        ),
        switch (state) {
          NotificationViewState.error => ErrorState(
            message: provider.error!,
            onRetry: user == null ? null : onRetryWatch,
          ),
          NotificationViewState.loading => const LoadingCardList(itemCount: 3),
          NotificationViewState.empty => EmptyState(
            message: L10nService.strings.inboxEmpty,
            icon: Icons.mark_email_read_outlined,
            actionLabel:
                user == null ? null : L10nService.strings.reloadInboxAction,
            onAction: user == null ? null : onRetryWatch,
          ),
          NotificationViewState.content => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (unread.isNotEmpty) ...[
                NotificationGroupTitle(
                  label: L10nService.strings.unreadGroup,
                  count: unread.length,
                ),
                NotificationList(notifications: unread),
              ],
              if (read.isNotEmpty) ...[
                NotificationGroupTitle(
                  label: L10nService.strings.readGroup,
                  count: read.length,
                ),
                NotificationList(notifications: read),
              ],
              if (provider.hasMoreNotifications)
                LoadMoreButton(onPressed: provider.loadMoreNotifications),
            ],
          ),
        },
      ],
    );
  }
}
