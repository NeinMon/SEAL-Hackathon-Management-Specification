import '../../../shared.dart';

class EventQuickActions extends StatelessWidget {
  const EventQuickActions({
    super.key,
    required this.event,
    required this.role,
    required this.myTeam,
  });

  final HackathonEvent event;
  final String? role;
  final Team? myTeam;

  @override
  Widget build(BuildContext context) {
    final action = _primaryAction(context);
    if (action == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10nService.strings.eventQuickActionsTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: action),
          ],
        ),
      ),
    );
  }

  Widget? _primaryAction(BuildContext context) {
    switch (role) {
      case AppRoles.judge:
        return FilledButton.icon(
          onPressed: event.judgingOpen()
              ? () => context.go(RouteQuery.judgeForEvent(event.id))
              : null,
          icon: Icon(Icons.rate_review_outlined),
          label: Text(context.l10n.openJudgeQueueButton),
        );
      case AppRoles.organizer:
        return FilledButton.icon(
          onPressed: () => context.go(RouteQuery.organizerForEvent(event.id)),
          icon: Icon(Icons.dashboard_customize_outlined),
          label: Text(context.l10n.openOrganizerDashboardButton),
        );
      case AppRoles.mentor:
        return FilledButton.icon(
          onPressed: () => context.go(RouteQuery.chatForEvent(event.id)),
          icon: Icon(Icons.chat_outlined),
          label: Text(context.l10n.openMentorChatButton),
        );
      default:
        if (myTeam != null && event.submissionOpen()) {
          return FilledButton.icon(
            onPressed: () => context.go(
              RouteQuery.submitForTeam(myTeam!.id, eventId: event.id),
            ),
            icon: Icon(Icons.upload_file_outlined),
            label: Text(context.l10n.submitForEventButton),
          );
        }
        return FilledButton.icon(
          onPressed: event.registrationOpen()
              ? () => context.go(RouteQuery.teamsForEvent(event.id))
              : null,
          icon: Icon(Icons.group_add_outlined),
          label: Text(context.l10n.joinOrCreateTeamButton),
        );
    }
  }
}
