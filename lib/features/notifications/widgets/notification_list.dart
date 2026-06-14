import '../../../shared.dart';
import 'notification_tile.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key, required this.notifications});

  final List<AppNotification> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) =>
          NotificationTile(notification: notifications[index]),
    );
  }
}

class NotificationGroupTitle extends StatelessWidget {
  const NotificationGroupTitle({
    super.key,
    required this.label,
    required this.count,
  });

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
          const SizedBox(width: AppSizes.paddingSmall),
          StatusPill(label: '$count'),
        ],
      ),
    );
  }
}
