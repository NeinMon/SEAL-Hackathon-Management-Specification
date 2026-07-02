import '../../../shared.dart';

class EventRoleActions extends StatelessWidget {
  const EventRoleActions({
    super.key,
    required this.role,
    required this.event,
    this.myTeam,
  });

  final String? role;
  final HackathonEvent event;
  final Team? myTeam;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ..._roleActions(context),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => context.go(RouteQuery.mapForEvent(event.id)),
          icon: const Icon(Icons.map_outlined),
          label: const Text(AppStrings.viewVenueButton),
        ),
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
            icon: const Icon(Icons.dashboard_customize_outlined),
            label: const Text(AppStrings.openOrganizerDashboardButton),
          ),
        ];
      case AppRoles.mentor:
        return [
          FilledButton.icon(
            onPressed: () => context.go(AppRoutes.chat),
            icon: const Icon(Icons.chat_outlined),
            label: const Text(AppStrings.openMentorChatButton),
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
        icon: const Icon(Icons.rate_review_outlined),
        label: const Text(AppStrings.openJudgeQueueButton),
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
      return const [];
    }

    final registrationOpen = event.registrationOpen();
    final blockReason = event.registrationBlockReason();
    return [
      FilledButton.icon(
        onPressed: registrationOpen
            ? () => context.go(RouteQuery.teamsForEvent(event.id))
            : null,
        icon: const Icon(Icons.group_add_outlined),
        label: const Text(AppStrings.joinOrCreateTeamButton),
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
