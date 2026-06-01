part of '../../main.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});
  final String eventId;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamProvider>().loadTeams();
      context.read<SubmissionProvider>().loadSubmissions();
      context.read<ScoreProvider>().loadScores();
      context.read<EventProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final event = eventProvider.byIdOrNull(widget.eventId);
    if (event == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SealSectionHeader(
            title: 'Event Detail',
            subtitle: 'Loading hackathon information from the event catalog.',
            icon: Icons.event_outlined,
          ),
          if (eventProvider.error != null)
            StatusBanner(message: eventProvider.error!, isError: true),
          if (eventProvider.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else
            const EmptyState(message: 'Event not found.'),
        ],
      );
    }
    final teams = context.watch<TeamProvider>().teams;
    final submissions = context.watch<SubmissionProvider>().submissions;
    final scores = context.watch<ScoreProvider>();
    final role = context.watch<AuthProvider>().user?.role;
    final eventTeams = teams.where((team) => team.eventId == event.id).toList();
    final eventTeamIds = eventTeams.map((team) => team.id).toSet();
    final eventSubmissions =
        submissions
            .where((submission) => eventTeamIds.contains(submission.teamId))
            .toList()
          ..sort(
            (a, b) =>
                scores.averageFor(b.id).compareTo(scores.averageFor(a.id)),
          );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 8,
                child: Image.network(
                  event.bannerUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const EventImageFallback(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusPill(
                      label:
                          'Registration closes ${DateFormat('dd/MM').format(event.registrationDeadline)}',
                      color: SealPalette.tertiary,
                      icon: Icons.schedule_outlined,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: const TextStyle(
                        color: SealPalette.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _EventTimeline(event: event),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            InfoChip(
              icon: Icons.calendar_month_outlined,
              text:
                  '${DateFormat('dd/MM/yyyy').format(event.startDate)} - ${DateFormat('dd/MM/yyyy').format(event.endDate)}',
            ),
            InfoChip(icon: Icons.place_outlined, text: event.location),
            InfoChip(
              icon: Icons.groups_outlined,
              text: 'Max ${event.maxTeamSize} members',
            ),
          ],
        ),
        const SizedBox(height: 16),
        DetailTile(title: 'Rules', value: event.rules),
        DetailTile(title: 'Prize', value: event.prize),
        const SizedBox(height: 12),
        _EventRoleActions(role: role),
        const SizedBox(height: 16),
        const Text(
          'Leaderboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        if (eventSubmissions.isEmpty)
          const EmptyState(message: 'No scored submissions yet')
        else
          for (final submission in eventSubmissions)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: SealPalette.primary.withValues(alpha: 0.14),
                  child: Text(
                    '#${eventSubmissions.indexOf(submission) + 1}',
                    style: const TextStyle(
                      color: SealPalette.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                title: Text(submission.projectName),
                subtitle: Text(
                  '${_teamName(submission.teamId, eventTeams)}\n${scores.scoreCountFor(submission.id)} judge score${scores.scoreCountFor(submission.id) == 1 ? '' : 's'}',
                ),
                isThreeLine: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      scores.averageFor(submission.id).toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'avg',
                      style: TextStyle(
                        color: SealPalette.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  String _teamName(String teamId, List<Team> teams) {
    for (final team in teams) {
      if (team.id == teamId) return team.name;
    }
    return 'Team not loaded';
  }
}

class _EventRoleActions extends StatelessWidget {
  const _EventRoleActions({required this.role});

  final String? role;

  @override
  Widget build(BuildContext context) {
    final primary = switch (role) {
      AppRoles.judge => (
        path: AppRoutes.judge,
        icon: Icons.rate_review_outlined,
        label: 'Open judging queue',
      ),
      AppRoles.organizer => (
        path: AppRoutes.organizer,
        icon: Icons.dashboard_customize_outlined,
        label: 'Open organizer dashboard',
      ),
      AppRoles.mentor => (
        path: AppRoutes.chat,
        icon: Icons.chat_outlined,
        label: 'Open mentor chat',
      ),
      _ => (
        path: AppRoutes.teams,
        icon: Icons.group_add_outlined,
        label: 'Create or manage team',
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () => context.go(primary.path),
          icon: Icon(primary.icon),
          label: Text(primary.label),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => context.go(AppRoutes.map),
          icon: const Icon(Icons.map_outlined),
          label: const Text('View event location'),
        ),
      ],
    );
  }
}

class _EventTimeline extends StatelessWidget {
  const _EventTimeline({required this.event});

  final HackathonEvent event;

  @override
  Widget build(BuildContext context) {
    final items = [
      _TimelineItem(
        icon: Icons.how_to_reg_outlined,
        label: 'Register',
        date: event.registrationDeadline,
      ),
      _TimelineItem(
        icon: Icons.flag_outlined,
        label: 'Kickoff',
        date: event.startDate,
      ),
      _TimelineItem(
        icon: Icons.emoji_events_outlined,
        label: 'Final',
        date: event.endDate,
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SealPalette.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SealPalette.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Timeline',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(item.icon, color: SealPalette.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(item.date),
                    style: const TextStyle(
                      color: SealPalette.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineItem {
  const _TimelineItem({
    required this.icon,
    required this.label,
    required this.date,
  });

  final IconData icon;
  final String label;
  final DateTime date;
}
