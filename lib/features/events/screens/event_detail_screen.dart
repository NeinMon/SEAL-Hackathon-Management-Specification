import '../../../shared.dart';
import '../widgets/event_detail_header.dart';
import '../widgets/event_leaderboard.dart';
import '../widgets/event_role_actions.dart';
import '../widgets/event_timeline.dart';

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
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        children: [
          const SealSectionHeader(
            title: AppStrings.eventDetailTitle,
            subtitle: AppStrings.eventDetailLoadingSubtitle,
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
            const EmptyState(message: AppStrings.eventNotFound),
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
    final overview = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EventDetailHeader(event: event),
        const SizedBox(height: AppSizes.paddingMedium),
        EventTimeline(event: event),
        const SizedBox(height: AppSizes.paddingMedium),
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
              text: AppStrings.maxMembersChip(event.maxTeamSize),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        DetailTile(title: AppStrings.rulesTitle, value: event.rules),
        DetailTile(title: AppStrings.prizeTitle, value: event.prize),
        const SizedBox(height: AppSizes.paddingCompact),
        EventRoleActions(role: role),
      ],
    );
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        SealSectionHeader(
          title: AppStrings.eventDetailTitle,
          subtitle: AppStrings.eventDetailSubtitle,
          icon: Icons.event_outlined,
          trailing: IconButton.filledTonal(
            tooltip: AppStrings.backToEventsButton,
            onPressed: () => context.go(AppRoutes.events),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        AdaptiveTwoPane(
          leading: overview,
          trailing: EventLeaderboard(
            submissions: eventSubmissions,
            teams: eventTeams,
            scores: scores,
          ),
        ),
      ],
    );
  }
}
