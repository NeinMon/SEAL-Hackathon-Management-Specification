import '../../../shared.dart';

class OrganizerTodayTasksCard extends StatelessWidget {
  const OrganizerTodayTasksCard({
    super.key,
    required this.unscored,
    required this.teamsNeedingMembers,
    required this.eventsClosingSoon,
    required this.notificationSuggestions,
    required this.onOpenJudge,
    required this.onOpenTeams,
    required this.onOpenEvents,
    required this.onSendAnnouncement,
    this.onRemindUnscored,
    this.onRemindTeams,
    this.onRemindClosing,
    this.onAssignMentor,
  });

  final int unscored;
  final int teamsNeedingMembers;
  final int eventsClosingSoon;
  final int notificationSuggestions;
  final VoidCallback onOpenJudge;
  final VoidCallback onOpenTeams;
  final VoidCallback onOpenEvents;
  final VoidCallback onSendAnnouncement;
  final VoidCallback? onRemindUnscored;
  final VoidCallback? onRemindTeams;
  final VoidCallback? onRemindClosing;
  final VoidCallback? onAssignMentor;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.today_outlined, color: context.sealPrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    L10nService.strings.organizerTodayTasksTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                StatusPill(
                  label: L10nService.strings.organizerNotificationSuggestions(
                    notificationSuggestions,
                  ),
                  color: notificationSuggestions == 0
                      ? context.sealSecondary
                      : context.sealTertiary,
                  icon: Icons.campaign_outlined,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _TaskRow(
              icon: Icons.fact_check_outlined,
              value: unscored,
              label: L10nService.strings.organizerUnscoredTasksLabel,
              color: unscored == 0 ? context.sealSecondary : context.sealError,
              onTap: onOpenJudge,
              onRemind: unscored > 0 ? onRemindUnscored : null,
            ),
            _TaskRow(
              icon: Icons.group_add_outlined,
              value: teamsNeedingMembers,
              label: L10nService.strings.organizerTeamsNeedMembersLabel,
              color: teamsNeedingMembers == 0
                  ? context.sealSecondary
                  : context.sealTertiary,
              onTap: onOpenTeams,
              onRemind: teamsNeedingMembers > 0 ? onRemindTeams : null,
              onSecondary: teamsNeedingMembers > 0 ? onAssignMentor : null,
              secondaryLabel: L10nService.strings.organizerAssignMentorButton,
            ),
            _TaskRow(
              icon: Icons.event_busy_outlined,
              value: eventsClosingSoon,
              label: L10nService.strings.organizerClosingSoonLabel,
              color: eventsClosingSoon == 0
                  ? context.sealSecondary
                  : context.sealTertiary,
              onTap: onOpenEvents,
              onRemind: eventsClosingSoon > 0 ? onRemindClosing : null,
            ),
            Divider(color: seal.outlineVariant),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onSendAnnouncement,
                icon: Icon(Icons.campaign_outlined),
                label: Text(context.l10n.sendAnnouncementButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.onTap,
    this.onRemind,
    this.onSecondary,
    this.secondaryLabel,
  });

  final IconData icon;
  final int value;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback? onRemind;
  final VoidCallback? onSecondary;
  final String? secondaryLabel;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '$value',
                  style: TextStyle(
                    color: value == 0 ? seal.onSurfaceVariant : color,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            if (onRemind != null || onSecondary != null) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.end,
                children: [
                  if (onRemind != null)
                    TextButton(
                      onPressed: onRemind,
                      child: Text(context.l10n.organizerSendReminderButton),
                    ),
                  if (onSecondary != null)
                    TextButton(
                      onPressed: onSecondary,
                      child: Text(secondaryLabel ?? L10nService.strings.detailsButton),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
