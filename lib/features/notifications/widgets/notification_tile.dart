import '../../../shared.dart';
import 'notification_dialogs.dart';

class NotificationVisual {
  const NotificationVisual(this.icon, this.color);

  final IconData icon;
  final Color color;
}

NotificationVisual notificationVisualFor(
  BuildContext context,
  String type,
  bool isRead,
) {
  final muted = isRead ? context.sealTheme.onSurfaceVariant : null;
  switch (type) {
    case 'score':
      return NotificationVisual(
        Icons.leaderboard_outlined,
        muted ?? context.sealSecondary,
      );
    case 'invitation':
      return NotificationVisual(
        Icons.group_add_outlined,
        muted ?? context.sealPrimary,
      );
    case 'announcement':
      return NotificationVisual(
        Icons.campaign_outlined,
        muted ?? context.sealTertiary,
      );
    case 'system':
    default:
      return NotificationVisual(
        Icons.shield_outlined,
        muted ?? context.sealIndigo,
      );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final style = notificationVisualFor(
      context,
      notification.type,
      notification.isRead,
    );
    final auth = context.watch<AuthProvider>();
    final role = auth.user?.role ?? AppRoles.participant;
    final teams = context.watch<TeamProvider>().teams;
    final actionLabel = NotificationLink.actionLabelFor(
      notification,
      role: role,
    );
    final actionRoute = NotificationLink.routeFor(
      notification,
      role: role,
      teams: teams,
      userId: auth.user?.id,
    );
    return Semantics(
      button: true,
      label:
          '${notification.isRead ? L10nService.strings.readGroup : L10nService.strings.unreadGroup} ${notification.title}',
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            ListTile(
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
                tooltip: context.l10n.notificationActionsTooltip,
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
                    PopupMenuItem(
                      value: 'read',
                      child: ListTile(
                        leading: Icon(Icons.done),
                        title: Text(context.l10n.markAsReadAction),
                      ),
                    ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text(context.l10n.deleteButton),
                    ),
                  ),
                ],
              ),
            ),
            if (actionLabel != null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                  child: FilledButton.tonal(
                    onPressed: () => _openAction(context, actionRoute),
                    child: Text(actionLabel),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAction(BuildContext context, String route) async {
    await context.read<NotificationProvider>().markRead(notification.id);
    if (!context.mounted) return;
    context.go(route);
  }

  Future<void> _handleTap(BuildContext context) async {
    await context.read<NotificationProvider>().markRead(notification.id);
    if (!context.mounted) return;
    final auth = context.read<AuthProvider>();
    final role = auth.user?.role ?? AppRoles.participant;
    final teams = context.read<TeamProvider>().teams;
    final destination = NotificationLink.routeFor(
      notification,
      role: role,
      teams: teams,
      userId: auth.user?.id,
    );
    switch (notification.type) {
      case 'score':
      case 'announcement':
        await _showDetailDialog(
          context,
          title: notification.type == 'score'
              ? L10nService.strings.scoreNotificationDialogTitle
              : L10nService.strings.announcementNotificationDialogTitle,
          actionLabel: notification.type == 'score'
              ? (role == AppRoles.participant
                    ? L10nService.strings.viewSubmissionButton
                    : L10nService.strings.detailsButton)
              : (NotificationLink.eventId(notification.content) == null
                    ? L10nService.strings.closeDialogButton
                    : L10nService.strings.viewEventFromAnnouncementButton),
          destination: destination,
          body: NotificationLink.displayContent(notification.content),
        );
        return;
      default:
        context.go(destination);
    }
  }

  Future<void> _showDetailDialog(
    BuildContext context, {
    required String title,
    required String actionLabel,
    String? destination,
    String? body,
  }) async {
    final shouldNavigate = await NotificationDialogs.showDetail(
      context,
      notification: notification,
      title: title,
      actionLabel: actionLabel,
      destination: destination,
      body: body,
    );
    if (!context.mounted || !shouldNavigate || destination == null) {
      return;
    }
    context.go(destination);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await NotificationDialogs.confirmDelete(context);
    if (!shouldDelete || !context.mounted) return;
    await context.read<NotificationProvider>().deleteNotification(
      notification.id,
    );
  }
}
