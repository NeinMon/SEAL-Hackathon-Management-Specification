import '../../../shared.dart';
import 'organizer_action.dart';

class OrganizerOperationsSection extends StatelessWidget {
  const OrganizerOperationsSection({
    super.key,
    required this.unscored,
    required this.onCreateEvent,
    required this.onSendAnnouncement,
    required this.onExportLeaderboard,
    required this.onOpenJudge,
    required this.onManageRoles,
    required this.onResetDemo,
  });

  final int unscored;
  final VoidCallback onCreateEvent;
  final VoidCallback onSendAnnouncement;
  final VoidCallback onExportLeaderboard;
  final VoidCallback onOpenJudge;
  final VoidCallback onManageRoles;
  final VoidCallback onResetDemo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.sectionOperations,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: onCreateEvent,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text(AppStrings.createEventTitle),
                ),
                OutlinedButton.icon(
                  onPressed: onSendAnnouncement,
                  icon: const Icon(Icons.notifications_outlined),
                  label: const Text(AppStrings.sendAnnouncementButton),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: const Text(
                AppStrings.otherActionsTitle,
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              children: [
                OrganizerAction(
                  icon: Icons.download_outlined,
                  title: AppStrings.exportLeaderboardTitle,
                  value: AppStrings.exportLeaderboardDescription,
                  onTap: onExportLeaderboard,
                ),
                OrganizerAction(
                  icon: Icons.rate_review_outlined,
                  title: AppStrings.judgeQueueTitle,
                  value: AppStrings.judgeQueueWaitingLabel(unscored),
                  onTap: onOpenJudge,
                ),
                OrganizerAction(
                  icon: Icons.manage_accounts_outlined,
                  title: AppStrings.userRolesTitle,
                  value: AppStrings.userRolesDescription,
                  onTap: onManageRoles,
                ),
                OrganizerAction(
                  icon: Icons.restore_page_outlined,
                  title: AppStrings.resetDemoTitle,
                  value: AppStrings.resetDemoDescription,
                  onTap: onResetDemo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
