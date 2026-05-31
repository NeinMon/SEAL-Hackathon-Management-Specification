part of '../../main.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().loadEvents();
      context.read<TeamProvider>().loadTeams();
      context.read<SubmissionProvider>().loadSubmissions();
      context.read<ScoreProvider>().loadScores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const RoleGate(
      allowedRoles: {AppRoles.organizer},
      message: 'Only organizers can access the operations dashboard.',
      child: _OrganizerDashboardContent(),
    );
  }
}

class _OrganizerDashboardContent extends StatelessWidget {
  const _OrganizerDashboardContent();

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
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Organizer',
          subtitle: 'Monitor event health, team progress, and judging status.',
          icon: Icons.dashboard_customize_outlined,
        ),
        if (events.error != null)
          StatusBanner(message: events.error!, isError: true),
        if (teams.error != null)
          StatusBanner(message: teams.error!, isError: true),
        if (submissions.error != null)
          StatusBanner(message: submissions.error!, isError: true),
        if (scores.error != null)
          StatusBanner(message: scores.error!, isError: true),
        if (loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'Events',
                value: '${events.events.length}',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                label: 'Active',
                value: '$activeEvents',
                accent: SealPalette.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(label: 'Teams', value: '${teams.teams.length}'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                label: 'Unscored',
                value: '$unscored',
                accent: unscored == 0
                    ? SealPalette.secondary
                    : SealPalette.tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Operations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                _OrganizerAction(
                  icon: Icons.groups_outlined,
                  title: 'Team readiness',
                  value: '${teams.teams.length} teams registered',
                  onTap: () => context.go(AppRoutes.teams),
                ),
                _OrganizerAction(
                  icon: Icons.rate_review_outlined,
                  title: 'Judging queue',
                  value: '$unscored submissions waiting for scores',
                  onTap: () => context.go(AppRoutes.judge),
                ),
                _OrganizerAction(
                  icon: Icons.notifications_outlined,
                  title: 'Announcements',
                  value: 'Review inbox and system alerts',
                  onTap: () => context.go(AppRoutes.notifications),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Recent submissions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        if (submissions.submissions.isEmpty)
          const EmptyState(
            message: 'No submissions yet',
            icon: Icons.assignment_outlined,
          )
        else
          for (final submission in submissions.submissions.take(5))
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.assignment_turned_in_outlined),
                title: Text(submission.projectName),
                subtitle: Text(
                  '${submission.status} • ${scores.scoreCountFor(submission.id)} score${scores.scoreCountFor(submission.id) == 1 ? '' : 's'}',
                ),
                trailing: Text(
                  scores.averageFor(submission.id).toStringAsFixed(1),
                  style: const TextStyle(
                    color: SealPalette.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}

class _OrganizerAction extends StatelessWidget {
  const _OrganizerAction({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: SealPalette.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
