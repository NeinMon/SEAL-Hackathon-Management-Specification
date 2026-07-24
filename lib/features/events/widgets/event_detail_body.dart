import '../../../shared.dart';
import '../helpers/event_detail_view_data.dart';
import 'event_detail_header.dart';
import 'event_detail_stats.dart';
import 'event_journey_banner.dart';
import 'event_leaderboard.dart';
import 'event_my_team_card.dart';
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

  bool get _isParticipant => role == null || role == AppRoles.participant;

  Widget? _primaryCta(BuildContext context) {
    if (_isParticipant) {
      if (viewData.journey != null) {
        return EventJourneyBanner(journey: viewData.journey!);
      }
      return EventQuickActions(
        event: event,
        role: role,
        myTeam: viewData.myTeam,
      );
    }
    if (role == AppRoles.organizer) {
      return EventQuickActions(
        event: event,
        role: role,
        myTeam: viewData.myTeam,
      );
    }
    return null;
  }

  Widget _detailSections(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    final rules = DetailTile(
      title: L10nService.strings.rulesTitle,
      value: event.rules,
    );
    final prize = DetailTile(
      title: L10nService.strings.prizeTitle,
      value: event.prize,
    );

    if (!compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [rules, prize],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExpansionTile(
          leading: const Icon(Icons.rule_outlined),
          title: Text(
            L10nService.strings.rulesTitle,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(event.rules),
              ),
            ),
          ],
        ),
        ExpansionTile(
          leading: const Icon(Icons.emoji_events_outlined),
          title: Text(
            L10nService.strings.prizeTitle,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(event.prize),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _overviewContent(BuildContext context) {
    final primaryCta = _primaryCta(context);
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EventDetailHeader(event: event),
        if (primaryCta != null) ...[
          const SizedBox(height: AppSizes.paddingMedium),
          primaryCta,
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
            InfoChip(
              icon: Icons.how_to_reg_outlined,
              text: 'Mở đăng ký: đang mở',
            ),
            InfoChip(
              icon: Icons.event_busy_outlined,
              text:
                  'Đóng đăng ký: ${dateFormatter.format(event.registrationDeadline)}',
            ),
            InfoChip(
              icon: Icons.upload_file_outlined,
              text:
                  'Hạn nộp bài: ${dateFormatter.format(event.effectiveSubmissionDeadline)}',
            ),
            InfoChip(icon: Icons.place_outlined, text: event.location),
            InfoChip(
              icon: Icons.groups_outlined,
              text: L10nService.strings.maxMembersChip(event.maxTeamSize),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        _detailSections(context),
        if (viewData.myTeam != null) ...[
          const SizedBox(height: AppSizes.paddingCompact),
          EventMyTeamCard(team: viewData.myTeam!, event: event),
        ],
      ],
    );
  }

  Widget _leaderboardContent(BuildContext context) {
    return EventLeaderboard(
      scoredSubmissions: viewData.scoredSubmissions,
      pendingSubmissions: viewData.pendingSubmissions,
      hasSubmissions: viewData.eventSubmissions.isNotEmpty,
      teams: viewData.eventTeams,
      scores: scores,
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;

    if (compact) {
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Material(
              color: context.sealTheme.surfaceContainerLow,
              child: TabBar(
                tabs: [
                  Tab(text: context.l10n.eventSubNavOverview),
                  Tab(text: context.l10n.leaderboardTitle),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSizes.paddingMedium),
                      children: [_overviewContent(context)],
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSizes.paddingMedium),
                      children: [_leaderboardContent(context)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        children: [
          AdaptiveTwoPane(
            leading: _overviewContent(context),
            trailing: _leaderboardContent(context),
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
