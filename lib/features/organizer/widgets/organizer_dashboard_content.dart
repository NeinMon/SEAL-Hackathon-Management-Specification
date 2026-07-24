import '../../../shared.dart';
import '../../../core/constants/organizer_task_templates.dart';
import '../helpers/organizer_dashboard_metrics.dart';
import 'organizer_advanced_scaffold.dart';
import 'organizer_mentor_assignment_dialog.dart';
import 'organizer_announcement_dialog.dart';
import 'organizer_event_dialog.dart';
import 'organizer_events_section.dart';
import 'organizer_operations_section.dart';
import 'organizer_overview_section.dart';
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

class OrganizerDashboardContentState extends State<OrganizerDashboardContent> {
  String section = 'overview';
  bool showAdvancedSections = false;
  final _homeScrollController = ScrollController();
  final _sectionScrollController = ScrollController();
  OrganizerDashboardUiProvider? _uiProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uiProvider ??= context.read<OrganizerDashboardUiProvider>();
  }

  @override
  void dispose() {
    _uiProvider?.setAdvancedMode(false);
    _homeScrollController.dispose();
    _sectionScrollController.dispose();
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
    if (_sectionScrollController.hasClients) {
      _sectionScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  void _openAdvanced({String? initialSection}) {
    _uiProvider?.setAdvancedMode(true);
    setState(() {
      showAdvancedSections = true;
      if (initialSection != null) section = initialSection;
    });
  }

  void _closeAdvanced() {
    _uiProvider?.setAdvancedMode(false);
    setState(() => showAdvancedSections = false);
  }

  String _combinedErrors(
    String? eventsError,
    String? teamsError,
    String? submissionsError,
    String? scoresError,
  ) {
    return [
      ?eventsError,
      ?teamsError,
      ?submissionsError,
      ?scoresError,
    ].join('\n');
  }

  Widget _errorBanner(
    EventProvider events,
    TeamProvider teams,
    SubmissionProvider submissions,
    ScoreProvider scores,
  ) {
    final message = _combinedErrors(
      events.error,
      teams.error,
      submissions.error,
      scores.error,
    );
    if (message.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingCompact),
      child: StatusBanner(message: message, isError: true),
    );
  }

  Widget _buildSectionContent({
    required BuildContext context,
    required OrganizerDashboardMetrics metrics,
    required EventProvider events,
    required TeamProvider teams,
    required SubmissionProvider submissions,
    required ScoreProvider scores,
    required String? focusEventId,
  }) {
    if (metrics.loading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        children: const [DashboardMetricSkeleton()],
      );
    }

    return ListView(
      controller: _sectionScrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        switch (section) {
          'operations' => OrganizerOperationsSection(
            unscored: metrics.unscored,
            onCreateEvent: () => _openEventDialog(context),
            onSendAnnouncement: () =>
                OrganizerAnnouncementDialog.show(context),
            onExportLeaderboard: () => _copyLeaderboardCsv(
              context,
              metrics.scopedSubmissions,
              scores,
              metrics.scopedTeams,
            ),
            onOpenJudge: () => _openAdvanced(initialSection: 'submissions'),
            onManageMentors: () => OrganizerMentorAssignmentDialog.show(
              context,
              events: events.events,
              focusEvent: metrics.focusEvent,
            ),
            onManageRoles: () => OrganizerUserRolesDialog.show(context),
            onManageCriteria: () =>
                OrganizerScoreCriteriaDialog.show(context),
          ),
          'events' => OrganizerEventsSection(
            events: events,
            onCreateEvent: () => _openEventDialog(context),
            onEditEvent: (event) =>
                _openEventDialog(context, existing: event),
            onCloseRegistration: (event) =>
                _closeRegistration(context, event),
          ),
          'submissions' => OrganizerSubmissionsSection(
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
          'teams' => OrganizerTeamsSection(
            teams: teams,
            focusEventId: focusEventId,
            onTapTeam: (team) =>
                OrganizerTeamDetailsDialog.show(context, team),
          ),
          _ => OrganizerOverviewSection(
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
        },
      ],
    );
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

    if (showAdvancedSections) {
      return OrganizerAdvancedScaffold(
        section: section,
        focusEventTitle: metrics.focusEvent?.title,
        loading: metrics.loading,
        onSectionChanged: _changeSection,
        onBack: _closeAdvanced,
        onRefresh: widget.onRefresh,
        child: RefreshIndicator(
          onRefresh: widget.onRefresh,
          child: _buildSectionContent(
            context: context,
            metrics: metrics,
            events: events,
            teams: teams,
            submissions: submissions,
            scores: scores,
            focusEventId: focusEventId,
          ),
        ),
      );
    }

    return ListView(
      controller: _homeScrollController,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                metrics.focusEvent == null
                    ? L10nService.strings.organizerSubtitle
                    : L10nService.strings.organizerFocusEventSubtitle(
                        metrics.focusEvent!.title,
                      ),
                style: TextStyle(
                  color: context.sealTheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
            IconButton.filledTonal(
              tooltip: context.l10n.reloadDashboardTooltip,
              onPressed: metrics.loading ? null : widget.onRefresh,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingCompact),
        _errorBanner(events, teams, submissions, scores),
        if (events.message != null) StatusBanner(message: events.message!),
        if (!metrics.loading) ...[
          OrganizerTodayTasksPanel(
            metrics: metrics,
            events: events.events,
            onOpenTeams: () => _openAdvanced(initialSection: 'teams'),
            onOpenEvents: () => _openAdvanced(initialSection: 'events'),
            onOpenJudge: () => _openAdvanced(initialSection: 'submissions'),
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
              onPressed: () => _openAdvanced(),
              icon: const Icon(Icons.unfold_more_outlined),
              label: Text(context.l10n.organizerShowDetailsButton),
            ),
          ),
        ] else
          const DashboardMetricSkeleton(),
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
