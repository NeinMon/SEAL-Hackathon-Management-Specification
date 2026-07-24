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
    required this.onManageMentors,
    required this.onManageRoles,
    required this.onManageCriteria,
  });

  final int unscored;
  final VoidCallback onCreateEvent;
  final VoidCallback onSendAnnouncement;
  final VoidCallback onExportLeaderboard;
  final VoidCallback onOpenJudge;
  final VoidCallback onManageMentors;
  final VoidCallback onManageRoles;
  final VoidCallback onManageCriteria;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10nService.strings.sectionOperations,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: onCreateEvent,
                  icon: Icon(Icons.add_circle_outline),
                  label: Text(context.l10n.createEventTitle),
                ),
                OutlinedButton.icon(
                  onPressed: onSendAnnouncement,
                  icon: Icon(Icons.notifications_outlined),
                  label: Text(context.l10n.sendAnnouncementButton),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                L10nService.strings.otherActionsTitle,
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              children: [
                OrganizerAction(
                  icon: Icons.download_outlined,
                  title: L10nService.strings.exportLeaderboardTitle,
                  value: L10nService.strings.exportLeaderboardDescription,
                  onTap: onExportLeaderboard,
                ),
                OrganizerAction(
                  icon: Icons.rate_review_outlined,
                  title: L10nService.strings.judgeQueueTitle,
                  value: L10nService.strings.judgeQueueWaitingLabel(unscored),
                  onTap: onOpenJudge,
                ),
                OrganizerAction(
                  icon: Icons.school_outlined,
                  title: L10nService.strings.manageEventMentorsTitle,
                  value: L10nService.strings.manageEventMentorsDescription,
                  onTap: onManageMentors,
                ),
                OrganizerAction(
                  icon: Icons.rule_folder_outlined,
                  title: L10nService.strings.manageScoreCriteriaTitle,
                  value: L10nService.strings.manageScoreCriteriaDescription,
                  onTap: onManageCriteria,
                ),
                OrganizerAction(
                  icon: Icons.manage_accounts_outlined,
                  title: L10nService.strings.userRolesTitle,
                  value: L10nService.strings.userRolesDescription,
                  onTap: onManageRoles,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
