import '../../../shared.dart';

class SubmissionScreenHeader extends StatelessWidget {
  const SubmissionScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SealSectionHeader(
      title: L10nService.strings.submitScreenTitle,
      subtitle: L10nService.strings.submitScreenSubtitle,
      icon: Icons.upload_file_outlined,
    );
  }
}

class SubmissionLoadingView extends StatelessWidget {
  const SubmissionLoadingView({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        children: const [
          SubmissionScreenHeader(),
          SizedBox(height: 12),
          LoadingCardList(itemCount: 2),
        ],
      ),
    );
  }
}

class SubmissionEmptyTeamsView extends StatelessWidget {
  const SubmissionEmptyTeamsView({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        children: [
          const SubmissionScreenHeader(),
          EmptyState(
            message: L10nService.strings.joinTeamBeforeSubmit,
            icon: Icons.groups_outlined,
            actionLabel: L10nService.strings.createTeamNowAction,
            onAction: () {
              final eventId =
                  context.read<ActiveEventProvider>().selectedEventId;
              context.go(
                eventId == null
                    ? AppRoutes.teams
                    : RouteQuery.teamsForEvent(eventId),
              );
            },
          ),
        ],
      ),
    );
  }
}
