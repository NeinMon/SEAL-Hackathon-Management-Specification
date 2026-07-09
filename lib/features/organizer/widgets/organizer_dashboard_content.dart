import '../../../shared.dart';
import '../../../core/constants/organizer_task_templates.dart';
import '../helpers/organizer_dashboard_metrics.dart';
import 'organizer_mentor_assignment_dialog.dart';
import 'organizer_demo_reset_dialog.dart';
import 'organizer_announcement_dialog.dart';
import 'organizer_event_dialog.dart';
import 'organizer_events_section.dart';
import 'organizer_operations_section.dart';
import 'organizer_overview_section.dart';
import 'organizer_section_picker.dart';
import 'organizer_score_criteria_dialog.dart';
import 'organizer_submission_details_dialog.dart';
import 'organizer_submissions_section.dart';
import 'organizer_team_details_dialog.dart';
import 'organizer_teams_section.dart';
import 'organizer_today_tasks_panel.dart';
import 'organizer_user_roles_dialog.dart';

class OrganizerDashboardContent extends StatefulWidget {
  const OrganizerDashboardContent({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  State<OrganizerDashboardContent> createState() =>
      OrganizerDashboardContentState();
}

class OrganizerDashboardContentState
    extends State<OrganizerDashboardContent> {
  String section = 'overview';
  bool showAdvancedSections = false;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openMentorAssignment(
    BuildContext context, {
    required List<HackathonEvent> events,
    required String? eventId,
  }) {
    HackathonEvent? focus;
    if (eventId != null) {
      for (final event in events) {
        if (event.id == eventId) {
          focus = event;
          break;
        }
      }
    }
    OrganizerMentorAssignmentDialog.show(
      context,
      events: events,
      focusEvent: focus,
    );
  }

  void _openTaskReminder(
    BuildContext context, {
    required OrganizerTaskTemplate template,
    required String? eventId,
  }) {
    OrganizerAnnouncementDialog.show(
      context,
      initialTemplate: template.announcement,
      linkedEventId: eventId,
      actionLabel: template.actionLabel,
      deepRoute: template.deepRoute,
    );
  }

  void _changeSection(String value) {
    setState(() => section = value);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>();
    final teams = context.watch<TeamProvider>();
    final submissions = context.watch<SubmissionProvider>();
    final scores = context.watch<ScoreProvider>();
    final focusEventId = RouteQuery.eventIdFrom(context);
    final metrics = OrganizerDashboardMetrics.compute(
      events: events,
      teams: teams,
      submissions: submissions,
      scores: scores,
      focusEventId: focusEventId,
    );

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        SealSectionHeader(
          title: L10nService.strings.organizerTitle,
          subtitle: metrics.focusEvent == null
              ? L10nService.strings.organizerSubtitle
              : L10nService.strings.organizerFocusEventSubtitle(
                  metrics.focusEvent!.title,
                ),
          icon: Icons.dashboard_customize_outlined,
          trailing: IconButton.filledTonal(
            tooltip: context.l10n.reloadDashboardTooltip,
            onPressed: metrics.loading ? null : widget.onRefresh,
            icon: Icon(Icons.refresh),
          ),
        ),
        if (events.error != null)
          StatusBanner(message: events.error!, isError: true),
        if (events.message != null) StatusBanner(message: events.message!),
        if (teams.error != null)
          StatusBanner(message: teams.error!, isError: true),
        if (submissions.error != null)
          StatusBanner(message: submissions.error!, isError: true),
        if (scores.error != null)
          StatusBanner(message: scores.error!, isError: true),
        if (!metrics.loading && !showAdvancedSections) ...[
          OrganizerTodayTasksPanel(
            metrics: metrics,
            events: events.events,
            onOpenTeams: () => setState(() {
              showAdvancedSections = true;
              section = 'teams';
            }),
            onOpenEvents: () => setState(() {
              showAdvancedSections = true;
              section = 'events';
            }),
            onSendAnnouncement: () => OrganizerAnnouncementDialog.show(context),
            onOpenTaskReminder: (template) => _openTaskReminder(
              context,
              eventId: metrics.reminderEventId,
              template: template,
            ),
            onOpenMentorAssignment: () => _openMentorAssignment(
              context,
              events: events.events,
              eventId: metrics.reminderEventId,
            ),
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonalIcon(
              onPressed: () => setState(() => showAdvancedSections = true),
              icon: Icon(Icons.unfold_more_outlined),
              label: Text(context.l10n.organizerShowDetailsButton),
            ),
          ),
        ],
        if (showAdvancedSections) ...[
          OrganizerSectionPicker(
            value: section,
            onChanged: _changeSection,
          ),
          const SizedBox(height: AppSizes.sectionGap),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => setState(() => showAdvancedSections = false),
              icon: Icon(Icons.unfold_less_outlined),
              label: Text(context.l10n.organizerHideDetailsButton),
            ),
          ),
          const SizedBox(height: AppSizes.paddingCompact),
        ],
        if (metrics.loading) const DashboardMetricSkeleton(),
        if (showAdvancedSections && section == 'overview' && !metrics.loading) ...[
          OrganizerTodayTasksPanel(
            metrics: metrics,
            events: events.events,
            onOpenTeams: () => _changeSection('teams'),
            onOpenEvents: () => _changeSection('events'),
            onSendAnnouncement: () => OrganizerAnnouncementDialog.show(context),
            onOpenTaskReminder: (template) => _openTaskReminder(
              context,
              eventId: metrics.reminderEventId,
              template: template,
            ),
            onOpenMentorAssignment: () => _openMentorAssignment(
              context,
              events: events.events,
              eventId: metrics.reminderEventId,
            ),
          ),
          const SizedBox(height: AppSizes.paddingMedium),
        ],
        if (showAdvancedSections && section == 'overview')
          OrganizerOverviewSection(
            activeEvents: metrics.overviewActiveEvents,
            unscored: metrics.unscored,
            events: events,
            teams: teams,
            submissions: submissions,
            scores: scores,
            focusEvent: metrics.focusEvent,
            teamCount: metrics.scopedTeams.length,
            submissionCount: metrics.scopedSubmissions.length,
          ),
        if (showAdvancedSections && section == 'operations')
          OrganizerOperationsSection(
            unscored: metrics.unscored,
            onCreateEvent: () => _openEventDialog(context),
            onSendAnnouncement: () => OrganizerAnnouncementDialog.show(context),
            onExportLeaderboard: () => _copyLeaderboardCsv(
              context,
              metrics.scopedSubmissions,
              scores,
              metrics.scopedTeams,
            ),
            onOpenJudge: () {
              final route = focusEventId == null
                  ? AppRoutes.judge
                  : RouteQuery.judgeForEvent(focusEventId);
              context.go(route);
            },
            onManageMentors: () => OrganizerMentorAssignmentDialog.show(
              context,
              events: events.events,
              focusEvent: metrics.focusEvent,
            ),
            onManageRoles: () => OrganizerUserRolesDialog.show(context),
            onResetDemo: () => OrganizerDemoResetDialog.show(
              context,
              onResetComplete: widget.onRefresh,
            ),
            onManageCriteria: () => OrganizerScoreCriteriaDialog.show(context),
          ),
        if (showAdvancedSections && section == 'events')
          OrganizerEventsSection(
            events: events,
            onCreateEvent: () => _openEventDialog(context),
            onEditEvent: (event) => _openEventDialog(context, existing: event),
            onCloseRegistration: (event) => _closeRegistration(context, event),
          ),
        if (showAdvancedSections && section == 'submissions')
          OrganizerSubmissionsSection(
            submissions: submissions,
            scores: scores,
            teams: teams,
            focusEventId: focusEventId,
            onTapSubmission: (submission) =>
                OrganizerSubmissionDetailsDialog.show(
                  context,
                  submission: submission,
                  scores: scores,
                  teams: teams.teams,
                ),
          ),
        if (showAdvancedSections && section == 'teams')
          OrganizerTeamsSection(
            teams: teams,
            focusEventId: focusEventId,
            onTapTeam: (team) => OrganizerTeamDetailsDialog.show(context, team),
          ),
      ],
    );
  }

  Future<void> _copyLeaderboardCsv(
    BuildContext context,
    List<ProjectSubmission> submissions,
    ScoreProvider scores,
    List<Team> teams,
  ) async {
    final ranked = [...submissions]
      ..sort(
        (a, b) => scores.averageFor(b.id).compareTo(scores.averageFor(a.id)),
      );
    final rows = [
      'rank,project,team,status,score_count,average',
      for (var index = 0; index < ranked.length; index++)
        '${index + 1},"${ranked[index].projectName.replaceAll('"', '""')}","${OrganizerSubmissionDetailsDialog.teamName(ranked[index].teamId, teams).replaceAll('"', '""')}",${ranked[index].status},${scores.scoreCountFor(ranked[index].id)},${scores.averageFor(ranked[index].id).toStringAsFixed(2)}',
    ];
    await Clipboard.setData(ClipboardData(text: rows.join('\n')));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.leaderboardCopiedSuccess)),
    );
  }

  Future<void> _openEventDialog(
    BuildContext context, {
    HackathonEvent? existing,
  }) async {
    final event = await OrganizerEventDialog.show(context, existing: existing);
    if (event == null || !context.mounted) return;
    await context.read<EventProvider>().saveEvent(
      event,
      existingEventId: existing?.id,
    );
    if (!context.mounted) return;
    final eventProvider = context.read<EventProvider>();
    if (eventProvider.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(eventProvider.error!)));
    }
  }

  Future<void> _closeRegistration(
    BuildContext context,
    HackathonEvent event,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.closeRegistrationTitle),
        content: Text(context.l10n.closeRegistrationBody(event.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.closeRegistrationConfirmButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final closedEvent = HackathonEvent(
      id: event.id,
      title: event.title,
      description: event.description,
      startDate: event.startDate,
      endDate: event.endDate,
      location: event.location,
      bannerUrl: event.bannerUrl,
      registrationDeadline: DateTime.now(),
      maxTeamSize: event.maxTeamSize,
      rules: event.rules,
      prize: event.prize,
      latitude: event.latitude,
      longitude: event.longitude,
      submissionDeadline: event.submissionDeadline,
      supportHotline: event.supportHotline,
      openingHours: event.openingHours,
    );
    await context.read<EventProvider>().saveEvent(
      closedEvent,
      existingEventId: event.id,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.closeRegistrationSuccess)),
    );
  }
}

