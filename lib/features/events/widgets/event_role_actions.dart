import '../../../shared.dart';

class EventRoleActions extends StatelessWidget {
  const EventRoleActions({super.key, required this.role});

  final String? role;

  @override
  Widget build(BuildContext context) {
    final primary = switch (role) {
      AppRoles.judge => (
        path: AppRoutes.judge,
        icon: Icons.rate_review_outlined,
        label: AppStrings.openJudgeQueueButton,
      ),
      AppRoles.organizer => (
        path: AppRoutes.organizer,
        icon: Icons.dashboard_customize_outlined,
        label: AppStrings.openOrganizerDashboardButton,
      ),
      AppRoles.mentor => (
        path: AppRoutes.chat,
        icon: Icons.chat_outlined,
        label: AppStrings.openMentorChatButton,
      ),
      _ => (
        path: AppRoutes.teams,
        icon: Icons.group_add_outlined,
        label: AppStrings.manageTeamButton,
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
          label: const Text(AppStrings.viewVenueButton),
        ),
      ],
    );
  }
}
