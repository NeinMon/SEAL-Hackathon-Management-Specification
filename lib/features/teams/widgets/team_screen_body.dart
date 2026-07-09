import '../../../shared.dart';
import '../helpers/team_screen_view_data.dart';
import '../widgets/team_card.dart';
import '../widgets/team_create_form.dart';
import '../widgets/team_group_title.dart';
import '../widgets/team_invitation_card.dart';
import '../widgets/team_overview_card.dart';

class TeamScreenBody extends StatelessWidget {
  const TeamScreenBody({
    super.key,
    required this.viewData,
    required this.events,
    required this.teams,
    required this.showCreateTeam,
    required this.createFormKey,
    required this.nameController,
    required this.eventsError,
    required this.onRefresh,
    required this.onEventChanged,
    required this.onCancelCreate,
    required this.onSubmitCreate,
    required this.onShowCreateTeam,
    required this.onSubmitProject,
  });

  final TeamScreenViewData viewData;
  final List<HackathonEvent> events;
  final TeamProvider teams;
  final bool showCreateTeam;
  final GlobalKey<FormState> createFormKey;
  final TextEditingController nameController;
  final String? eventsError;
  final VoidCallback onRefresh;
  final ValueChanged<String?> onEventChanged;
  final VoidCallback onCancelCreate;
  final VoidCallback onSubmitCreate;
  final VoidCallback onShowCreateTeam;
  final VoidCallback onSubmitProject;

  @override
  Widget build(BuildContext context) {
    final user = viewData.user;
    final selectedEvent = viewData.selectedEvent;
    final loading = viewData.loading;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
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
        if (viewData.myTeamForSelectedEvent != null) ...[
          FilledButton.icon(
            onPressed: loading ? null : onSubmitProject,
            icon: const Icon(Icons.upload_file_outlined),
            label: Text(context.l10n.submitProjectButton),
          ),
          const SizedBox(height: AppSizes.paddingMedium),
        ],
        if (showCreateTeam ||
            (teams.teams.isEmpty && viewData.myTeamForSelectedEvent == null))
          TeamCreateForm(
            formKey: createFormKey,
            nameController: nameController,
            events: events,
            selectedEvent: selectedEvent,
            loading: loading,
            canCreateTeam: viewData.canCreateTeam,
            showCancel: teams.teams.isNotEmpty,
            user: user,
            onEventChanged: onEventChanged,
            onCancel: onCancelCreate,
            onSubmit: onSubmitCreate,
          )
        else if (viewData.canCreateTeamRole &&
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
        ],
        const SizedBox(height: AppSizes.paddingMedium),
        if (teams.error != null && teams.teams.isEmpty)
          ErrorState(
            message: teams.error!,
            onRetry: () => context.read<TeamProvider>().loadTeamWorkspace(user),
          )
        else if (teams.error != null)
          StatusBanner(message: teams.error!, isError: true),
        if (teams.message != null) StatusBanner(message: teams.message!),
        if (viewData.pendingInvitations.isNotEmpty) ...[
          TeamGroupTitle(title: L10nService.strings.pendingInvitationsTitle),
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
        ],
        if (loading)
          const LoadingCardList(itemCount: 2)
        else if (teams.teams.isEmpty)
          EmptyState(
            message: L10nService.strings.emptyTeamsMessage,
            actionLabel: viewData.canCreateTeam
                ? L10nService.strings.createTeamNowAction
                : L10nService.strings.reloadTeamsTooltip,
            onAction: viewData.canCreateTeam
                ? onShowCreateTeam
                : () => context.read<TeamProvider>().loadTeamWorkspace(user),
          )
        else ...[
          if (viewData.visibleMyTeams.isNotEmpty) ...[
            TeamGroupTitle(title: L10nService.strings.myTeamsGroup),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewData.visibleMyTeams.length,
              itemBuilder: (context, index) {
                final team = viewData.visibleMyTeams[index];
                return TeamCard(
                  team: team,
                  currentUser: user,
                  event: TeamScreenViewData.eventFor(team.eventId, events),
                  allTeams: teams.teams,
                  highlighted: true,
                );
              },
            ),
          ],
          if (viewData.otherTeams.isNotEmpty) ...[
            TeamGroupTitle(title: L10nService.strings.otherTeamsGroup),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewData.otherTeams.length,
              itemBuilder: (context, index) {
                final team = viewData.otherTeams[index];
                return TeamCard(
                  team: team,
                  currentUser: user,
                  event: TeamScreenViewData.eventFor(team.eventId, events),
                  allTeams: teams.teams,
                );
              },
            ),
          ],
        ],
      ],
    );
  }
}
