import '../../../shared.dart';

class OrganizerAnnouncementForm extends StatelessWidget {
  const OrganizerAnnouncementForm({
    super.key,
    required this.formKey,
    required this.title,
    required this.content,
    required this.role,
    required this.linkedEventId,
    required this.events,
    required this.onRoleChanged,
    required this.onEventChanged,
    required this.onTemplateSelected,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController title;
  final TextEditingController content;
  final String role;
  final String? linkedEventId;
  final List<HackathonEvent> events;
  final ValueChanged<String> onRoleChanged;
  final ValueChanged<String?> onEventChanged;
  final ValueChanged<AnnouncementTemplate> onTemplateSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                L10nService.strings.announcementTemplatesLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: context.onSurfaceColor,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Wrap(
              spacing: AppSizes.paddingSmall,
              runSpacing: AppSizes.paddingSmall,
              children: [
                for (final template in AnnouncementTemplates.demo)
                  ActionChip(
                    label: Text(template.label),
                    onPressed: () => onTemplateSelected(template),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: role,
              decoration: InputDecoration(
                labelText: L10nService.strings.recipientLabel,
                prefixIcon: const Icon(Icons.people_outline),
              ),
              items: [
                DropdownMenuItem(
                  value: 'all',
                  child: Text(context.l10n.allFilter),
                ),
                DropdownMenuItem(
                  value: AppRoles.participant,
                  child: Text(context.l10n.roleParticipant),
                ),
                DropdownMenuItem(
                  value: AppRoles.mentor,
                  child: Text(context.l10n.roleMentor),
                ),
                DropdownMenuItem(
                  value: AppRoles.judge,
                  child: Text(context.l10n.roleJudge),
                ),
              ],
              onChanged: (value) => onRoleChanged(value ?? 'all'),
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            DropdownButtonFormField<String?>(
              isExpanded: true,
              initialValue: linkedEventId,
              decoration: InputDecoration(
                labelText: L10nService.strings.announcementEventLabel,
                prefixIcon: const Icon(Icons.event_outlined),
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(context.l10n.announcementNoEvent),
                ),
                for (final event in events)
                  DropdownMenuItem<String?>(
                    value: event.id,
                    child: Text(event.title, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: onEventChanged,
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            TextFormField(
              controller: title,
              validator: AppValidators.notificationTitle,
              decoration: InputDecoration(
                labelText: L10nService.strings.notificationTitleLabel,
                prefixIcon: const Icon(Icons.campaign_outlined),
              ),
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            TextFormField(
              controller: content,
              minLines: 3,
              maxLines: 5,
              validator: AppValidators.notificationBody,
              decoration: InputDecoration(
                labelText: L10nService.strings.notificationContentLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
