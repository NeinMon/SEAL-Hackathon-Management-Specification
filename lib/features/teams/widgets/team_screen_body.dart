import '../../../shared.dart';
import '../helpers/team_screen_view_data.dart';
import '../widgets/team_card.dart';
import '../widgets/team_group_title.dart';
import '../widgets/team_invitation_card.dart';
import '../widgets/team_overview_card.dart';

class TeamScreenBody extends StatelessWidget {
  const TeamScreenBody({
    super.key,
    required this.viewData,
    required this.events,
    required this.teams,
    required this.eventsError,
    required this.onRefresh,
    required this.onEventChanged,
    required this.onShowCreateTeam,
  });

  final TeamScreenViewData viewData;
  final List<HackathonEvent> events;
  final TeamProvider teams;
  final String? eventsError;
  final VoidCallback onRefresh;
  final ValueChanged<String?> onEventChanged;
  final VoidCallback onShowCreateTeam;

  @override
  Widget build(BuildContext context) {
    final user = viewData.user;
    final selectedEvent = viewData.selectedEvent;
    final loading = viewData.loading;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SealSectionHeader(
                title: L10nService.strings.teamTitle,
                subtitle: L10nService.strings.teamSubtitle,
                icon: Icons.groups_outlined,
                trailing: IconButton.filledTonal(
                  tooltip: context.l10n.reloadTeamsTooltip,
                  onPressed: loading ? null : onRefresh,
                  icon: const Icon(Icons.refresh),
                ),
              ),
              if (eventsError != null)
                StatusBanner(message: eventsError!, isError: true),
              if (events.length > 1) ...[
                EventScopePicker(
                  events: events,
                  selectedEventId: selectedEvent?.id,
                  onChanged: onEventChanged,
                ),
                const SizedBox(height: AppSizes.paddingCompact),
              ],
              TeamOverviewCard(
                scopedTeamCount: viewData.scopedTeams.length,
                pendingInvitations: viewData.pendingInvitations.length,
                hasMyTeam: viewData.myTeamForSelectedEvent != null,
                eventTitle: selectedEvent?.title,
              ),
              const SizedBox(height: AppSizes.paddingCompact),
              if (viewData.canCreateTeamRole &&
                  viewData.myTeamForSelectedEvent == null) ...[
                FilledButton.icon(
                  onPressed: loading || !viewData.canCreateTeam
                      ? null
                      : onShowCreateTeam,
                  icon: const Icon(Icons.add),
                  label: Text(context.l10n.createTeamButton),
                ),
                if (!loading &&
                    selectedEvent != null &&
                    !selectedEvent.registrationOpen()) ...[
                  const SizedBox(height: 8),
                  Text(
                    selectedEvent.registrationBlockReason() ??
                        L10nService.strings.errorRegistrationDeadlinePassed,
                    style: TextStyle(color: context.sealTheme.onSurfaceVariant),
                  ),
                ],
                const SizedBox(height: AppSizes.paddingMedium),
              ],
              if (teams.error != null && teams.teams.isEmpty)
                ErrorState(
                  message: teams.error!,
                  onRetry: () =>
                      context.read<TeamProvider>().loadTeamWorkspace(user),
                )
              else if (teams.error != null)
                StatusBanner(message: teams.error!, isError: true),
              if (teams.message != null) StatusBanner(message: teams.message!),
            ]),
          ),
        ),
        if (viewData.pendingInvitations.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                TeamGroupTitle(
                  title: L10nService.strings.pendingInvitationsTitle,
                ),
                for (final invitation in viewData.pendingInvitations)
                  TeamInvitationCard(
                    invitation: invitation,
                    currentUser: user!,
                    event: TeamScreenViewData.eventFor(
                      invitation.team?.eventId ?? '',
                      events,
                    ),
                  ),
                const SizedBox(height: AppSizes.paddingCompact),
              ]),
            ),
          ),
        if (loading)
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
            sliver: SliverToBoxAdapter(child: LoadingCardList(itemCount: 2)),
          )
        else if (viewData.scopedTeams.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            sliver: SliverToBoxAdapter(
              child: EmptyState(
                message: L10nService.strings.emptyTeamsMessage,
                actionLabel: viewData.canCreateTeam
                    ? L10nService.strings.createTeamNowAction
                    : L10nService.strings.reloadTeamsTooltip,
                onAction: viewData.canCreateTeam
                    ? onShowCreateTeam
                    : () =>
                          context.read<TeamProvider>().loadTeamWorkspace(user),
              ),
            ),
          )
        else ...[
          if (viewData.visibleMyTeams.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
              ),
              sliver: SliverToBoxAdapter(
                child: TeamGroupTitle(title: L10nService.strings.myTeamsGroup),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final team = viewData.visibleMyTeams[index];
                    return TeamCard(
                      team: team,
                      currentUser: user,
                      event: TeamScreenViewData.eventFor(team.eventId, events),
                      allTeams: teams.teams,
                      highlighted: true,
                    );
                  },
                  childCount: viewData.visibleMyTeams.length,
                ),
              ),
            ),
          ],
          if (viewData.otherTeams.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
              ),
              sliver: SliverToBoxAdapter(
                child: TeamGroupTitle(title: L10nService.strings.otherTeamsGroup),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final team = viewData.otherTeams[index];
                    return TeamCard(
                      team: team,
                      currentUser: user,
                      event: TeamScreenViewData.eventFor(team.eventId, events),
                      allTeams: teams.teams,
                    );
                  },
                  childCount: viewData.otherTeams.length,
                ),
              ),
            ),
          ],
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ],
    );
  }
}
