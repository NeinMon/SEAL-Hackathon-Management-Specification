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
    final eventTeamIds = teams
        .where((team) => team.eventId == event.id)
        .map((team) => team.id)
        .toSet();
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
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 16 / 8,
            child: Image.network(
              event.bannerUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const EventImageFallback(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          event.title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          event.description,
          style: const TextStyle(
            color: SealPalette.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        DetailTile(title: 'Rules', value: event.rules),
        DetailTile(title: 'Prize', value: event.prize),
        DetailTile(
          title: 'Registration deadline',
          value: DateFormat('dd/MM/yyyy').format(event.registrationDeadline),
        ),
        DetailTile(
          title: 'Max team size',
          value: '${event.maxTeamSize} members',
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => context.go('/teams'),
          icon: const Icon(Icons.group_add_outlined),
          label: const Text('Create or manage team'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go('/map'),
          icon: const Icon(Icons.map_outlined),
          label: const Text('View event location'),
        ),
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
                leading: const Icon(Icons.emoji_events_outlined),
                title: Text(submission.projectName),
                subtitle: Text(submission.status),
                trailing: Text(
                  scores.averageFor(submission.id).toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
