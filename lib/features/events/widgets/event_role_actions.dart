import '../../../shared.dart';

class EventRoleActions extends StatelessWidget {
  const EventRoleActions({
    super.key,
    required this.role,
    required this.event,
    this.myTeam,
    this.showVenueButton = true,
  });

  final String? role;
  final HackathonEvent event;
  final Team? myTeam;
  final bool showVenueButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ..._roleActions(context),
        if (showVenueButton) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.go(RouteQuery.mapForEvent(event.id)),
            icon: Icon(Icons.map_outlined),
            label: Text(context.l10n.viewVenueButton),
          ),
        ],
      ],
    );
  }

  List<Widget> _roleActions(BuildContext context) {
    switch (role) {
      case AppRoles.judge:
        return _judgeActions(context);
      case AppRoles.organizer:
        return [
          FilledButton.icon(
            onPressed: () => context.go(RouteQuery.organizerForEvent(event.id)),
            icon: Icon(Icons.dashboard_customize_outlined),
            label: Text(context.l10n.openOrganizerDashboardButton),
          ),
        ];
      case AppRoles.mentor:
        return [
          FilledButton.icon(
            onPressed: () => context.go(RouteQuery.chatForEvent(event.id)),
            icon: Icon(Icons.chat_outlined),
            label: Text(context.l10n.openMentorChatButton),
          ),
        ];
      default:
        return _participantActions(context);
    }
  }

  List<Widget> _judgeActions(BuildContext context) {
    final enabled = event.judgingOpen();
    final disabledReason = event.judgingBlockReason();
    return [
      FilledButton.icon(
        onPressed: enabled
            ? () => context.go(RouteQuery.judgeForEvent(event.id))
            : null,
        icon: Icon(Icons.rate_review_outlined),
        label: Text(context.l10n.openJudgeQueueButton),
      ),
      if (disabledReason != null) ...[
        const SizedBox(height: 8),
        Text(
          disabledReason,
          style: TextStyle(color: context.sealTheme.onSurfaceVariant),
        ),
      ],
    ];
  }

  List<Widget> _participantActions(BuildContext context) {
    if (myTeam != null) {
      // Avoid duplicating actions when the "Team của bạn" card is shown.
      return [];
    }

    final registrationOpen = event.registrationOpen();
    final blockReason = event.registrationBlockReason();
    return [
      FilledButton.icon(
        onPressed: registrationOpen
            ? () => context.go(RouteQuery.teamsForEvent(event.id))
            : null,
        icon: Icon(Icons.group_add_outlined),
        label: Text(context.l10n.joinOrCreateTeamButton),
      ),
      if (blockReason != null) ...[
        const SizedBox(height: 8),
        Text(
          blockReason,
          style: TextStyle(color: context.sealTheme.onSurfaceVariant),
        ),
      ],
    ];
  }
}
