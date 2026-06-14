import '../../../shared.dart';
import '../widgets/organizer_announcement_dialog.dart';
import '../widgets/organizer_event_dialog.dart';
import '../widgets/organizer_events_section.dart';
import '../widgets/organizer_operations_section.dart';
import '../widgets/organizer_overview_section.dart';
import '../widgets/organizer_section_picker.dart';
import '../widgets/organizer_submission_details_dialog.dart';
import '../widgets/organizer_submissions_section.dart';
import '../widgets/organizer_team_details_dialog.dart';
import '../widgets/organizer_teams_section.dart';
import '../widgets/organizer_user_roles_dialog.dart';

class OrganizerDashboardScreen extends StatefulWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  State<OrganizerDashboardScreen> createState() =>
      _OrganizerDashboardScreenState();
}

class _OrganizerDashboardScreenState extends State<OrganizerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    await Future.wait([
      context.read<EventProvider>().loadEvents(),
      context.read<TeamProvider>().loadTeams(),
      context.read<SubmissionProvider>().loadSubmissions(),
      context.read<ScoreProvider>().loadScores(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RoleGate(
      allowedRoles: const {AppRoles.organizer},
      message: AppStrings.organizerRoleGateMessage,
      child: _OrganizerDashboardContent(onRefresh: _reload),
    );
  }
}

class _OrganizerDashboardContent extends StatefulWidget {
  const _OrganizerDashboardContent({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  State<_OrganizerDashboardContent> createState() =>
      _OrganizerDashboardContentState();
}

class _OrganizerDashboardContentState
    extends State<_OrganizerDashboardContent> {
  String section = 'overview';

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>();
    final teams = context.watch<TeamProvider>();
    final submissions = context.watch<SubmissionProvider>();
    final scores = context.watch<ScoreProvider>();
    final unscored = submissions.submissions
        .where((submission) => scores.scoreCountFor(submission.id) == 0)
        .length;
    final activeEvents = events.events.where((event) {
      final now = DateTime.now();
      return event.startDate.isBefore(now) && event.endDate.isAfter(now);
    }).length;
    final loading =
        events.isLoading ||
        teams.isLoading ||
        submissions.isLoading ||
        scores.isLoading;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        SealSectionHeader(
          title: AppStrings.organizerTitle,
          subtitle: AppStrings.organizerSubtitle,
          icon: Icons.dashboard_customize_outlined,
          trailing: IconButton.filledTonal(
            tooltip: AppStrings.reloadDashboardTooltip,
            onPressed: loading ? null : widget.onRefresh,
            icon: const Icon(Icons.refresh),
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
        OrganizerSectionPicker(
          value: section,
          onChanged: (value) => setState(() => section = value),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        if (loading) const DashboardMetricSkeleton(),
        if (section == 'overview')
          OrganizerOverviewSection(
            activeEvents: activeEvents,
            unscored: unscored,
            events: events,
            teams: teams,
            submissions: submissions,
            scores: scores,
          ),
        if (section == 'operations')
          OrganizerOperationsSection(
            unscored: unscored,
            onCreateEvent: () => OrganizerEventDialog.show(context),
            onSendAnnouncement: () =>
                OrganizerAnnouncementDialog.show(context),
            onExportLeaderboard: () => _copyLeaderboardCsv(
              context,
              submissions.submissions,
              scores,
              teams.teams,
            ),
            onOpenJudge: () => context.go(AppRoutes.judge),
            onManageRoles: () => OrganizerUserRolesDialog.show(context),
            onResetDemo: () => _resetDemoData(context),
          ),
        if (section == 'events')
          OrganizerEventsSection(
            events: events,
            onCreateEvent: () => OrganizerEventDialog.show(context),
            onEditEvent: (event) =>
                OrganizerEventDialog.show(context, existing: event),
            onCloseRegistration: (event) => _closeRegistration(context, event),
          ),
        if (section == 'submissions')
          OrganizerSubmissionsSection(
            submissions: submissions,
            scores: scores,
            teams: teams,
            onTapSubmission: (submission) =>
                OrganizerSubmissionDetailsDialog.show(
                  context,
                  submission: submission,
                  scores: scores,
                  teams: teams.teams,
                ),
          ),
        if (section == 'teams')
          OrganizerTeamsSection(
            teams: teams,
            onTapTeam: (team) =>
                OrganizerTeamDetailsDialog.show(context, team),
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
      const SnackBar(content: Text(AppStrings.leaderboardCopiedSuccess)),
    );
  }

  Future<void> _closeRegistration(
    BuildContext context,
    HackathonEvent event,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.closeRegistrationTitle),
        content: Text(AppStrings.closeRegistrationBody(event.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.closeRegistrationConfirmButton),
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
    );
    await context.read<EventProvider>().saveEvent(
      closedEvent,
      existingEventId: event.id,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.closeRegistrationSuccess)),
    );
  }

  Future<void> _resetDemoData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.resetDemoTitle),
        content: const Text(AppStrings.resetDemoBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.resetButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final message = await const AdminService().resetDemoData();
      if (!context.mounted) return;
      await widget.onRefresh();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(FriendlyErrorMapper.message(error)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
