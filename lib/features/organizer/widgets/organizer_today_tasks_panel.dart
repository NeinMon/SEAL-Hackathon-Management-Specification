import '../../../shared.dart';
import '../../../core/constants/organizer_task_templates.dart';
import '../helpers/organizer_dashboard_metrics.dart';
import 'organizer_today_tasks_card.dart';

class OrganizerTodayTasksPanel extends StatelessWidget {
  const OrganizerTodayTasksPanel({
    super.key,
    required this.metrics,
    required this.events,
    required this.onOpenTeams,
    required this.onOpenEvents,
    required this.onSendAnnouncement,
    required this.onOpenTaskReminder,
    required this.onOpenMentorAssignment,
  });

  final OrganizerDashboardMetrics metrics;
  final List<HackathonEvent> events;
  final VoidCallback onOpenTeams;
  final VoidCallback onOpenEvents;
  final VoidCallback onSendAnnouncement;
  final void Function(OrganizerTaskTemplate template) onOpenTaskReminder;
  final VoidCallback onOpenMentorAssignment;

  @override
  Widget build(BuildContext context) {
    final reminderEventId = metrics.reminderEventId;
    final reminderEventTitle = metrics.reminderEventTitle;
    return OrganizerTodayTasksCard(
      unscored: metrics.unscored,
      teamsNeedingMembers: metrics.teamsNeedingMembers,
      eventsClosingSoon: metrics.eventsClosingSoon,
      notificationSuggestions: metrics.notificationSuggestions,
      onOpenJudge: () {
        final route = metrics.focusEventId == null
            ? AppRoutes.judge
            : RouteQuery.judgeForEvent(metrics.focusEventId!);
        context.go(route);
      },
      onOpenTeams: onOpenTeams,
      onOpenEvents: onOpenEvents,
      onSendAnnouncement: onSendAnnouncement,
      onRemindUnscored: reminderEventId == null
          ? null
          : () => onOpenTaskReminder(
              OrganizerTaskTemplates.unscoredReminder(
                count: metrics.unscored,
                eventId: reminderEventId,
                eventTitle: reminderEventTitle,
              ),
            ),
      onRemindTeams: reminderEventId == null
          ? null
          : () => onOpenTaskReminder(
              OrganizerTaskTemplates.teamsNeedMembersReminder(
                count: metrics.teamsNeedingMembers,
                eventId: reminderEventId,
                eventTitle: reminderEventTitle,
              ),
            ),
      onRemindClosing: reminderEventId == null
          ? null
          : () => onOpenTaskReminder(
              OrganizerTaskTemplates.closingSoonReminder(
                count: metrics.eventsClosingSoon,
                eventId: reminderEventId,
                eventTitle: reminderEventTitle,
              ),
            ),
      onAssignMentor: reminderEventId == null ? null : onOpenMentorAssignment,
    );
  }
}
