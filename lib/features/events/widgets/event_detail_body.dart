import '../../../shared.dart';
import '../helpers/event_detail_view_data.dart';
import 'event_detail_header.dart';
import 'event_detail_stats.dart';
import 'event_journey_banner.dart';
import 'event_leaderboard.dart';
import 'event_my_team_card.dart';
import 'event_role_actions.dart';
import 'event_quick_actions.dart';
import 'event_timeline.dart';

class EventDetailBody extends StatelessWidget {
  const EventDetailBody({
    super.key,
    required this.event,
    required this.viewData,
    required this.scores,
    required this.role,
    required this.onRefresh,
  });

  final HackathonEvent event;
  final EventDetailViewData viewData;
  final ScoreProvider scores;
  final String? role;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final overview = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EventDetailHeader(
          event: event,
          onBack: () => context.go(AppRoutes.events),
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        EventQuickActions(
          event: event,
          role: role,
          myTeam: viewData.myTeam,
        ),
        if (viewData.journey != null) ...[
          const SizedBox(height: AppSizes.paddingMedium),
          EventJourneyBanner(journey: viewData.journey!),
        ],
        const SizedBox(height: AppSizes.paddingMedium),
        EventDetailStats(
          teamCount: viewData.eventTeams.length,
          submissionCount: viewData.eventSubmissions.length,
          unscoredCount: viewData.unscoredCount,
        ),
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
              text: L10nService.strings.maxMembersChip(event.maxTeamSize),
            ),
            ActionChip(
              avatar: const Icon(Icons.map_outlined, size: 18),
              label: Text(context.l10n.journeyActionOpenMap),
              onPressed: () => context.go(RouteQuery.mapForEvent(event.id)),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        DetailTile(title: L10nService.strings.rulesTitle, value: event.rules),
        DetailTile(title: L10nService.strings.prizeTitle, value: event.prize),
        if (viewData.myTeam != null) ...[
          const SizedBox(height: AppSizes.paddingCompact),
          EventMyTeamCard(team: viewData.myTeam!, event: event),
        ],
        const SizedBox(height: AppSizes.paddingCompact),
        EventRoleActions(
          role: role,
          event: event,
          myTeam: viewData.myTeam,
        ),
      ],
    );

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        children: [
          AdaptiveTwoPane(
            leading: overview,
            trailing: EventLeaderboard(
              scoredSubmissions: viewData.scoredSubmissions,
              pendingSubmissions: viewData.pendingSubmissions,
              hasSubmissions: viewData.eventSubmissions.isNotEmpty,
              teams: viewData.eventTeams,
              scores: scores,
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailMissingView extends StatelessWidget {
  const EventDetailMissingView({
    super.key,
    required this.isLoading,
    required this.error,
  });

  final bool isLoading;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        SealSectionHeader(
          title: L10nService.strings.eventDetailTitle,
          subtitle: L10nService.strings.eventDetailLoadingSubtitle,
          icon: Icons.event_outlined,
        ),
        if (error != null) StatusBanner(message: error!, isError: true),
        if (isLoading)
          const LoadingCardList(itemCount: 2)
        else
          EmptyState(message: context.l10n.eventNotFound),
      ],
    );
  }
}
