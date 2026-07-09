import '../../../shared.dart';
import 'participant_home_card.dart';
import 'participant_pick_event_card.dart';

class ParticipantHomeSection extends StatelessWidget {
  const ParticipantHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null || user.role != AppRoles.participant) {
      return const SizedBox.shrink();
    }

    final eventProvider = context.watch<EventProvider>();
    final teams = context.watch<TeamProvider>().teams;
    final events = eventProvider.events;

    if (eventProvider.isLoading && events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: AppSizes.paddingMedium),
        child: EventCardSkeleton(),
      );
    }

    if (events.isEmpty) {
      return const ParticipantPickEventCard();
    }

    final activeEvent = context.watch<ActiveEventProvider>().eventFor(
      events: events,
      userId: user.id,
      teams: teams,
    );

    if (activeEvent == null) {
      return const ParticipantPickEventCard();
    }

    final hasTeam = TeamMembership.teamForUserOnEvent(
      teams: teams,
      userId: user.id,
      eventId: activeEvent.id,
    );
    if (hasTeam == null) {
      return const ParticipantPickEventCard();
    }

    final journey = ParticipantJourney.forUser(
      event: activeEvent,
      userId: user.id,
      teams: teams,
      submissions: context.watch<SubmissionProvider>().submissions,
      scores: context.watch<ScoreProvider>(),
    );
    if (journey == null) {
      return const ParticipantPickEventCard();
    }

    return ParticipantHomeCard(journey: journey);
  }
}
