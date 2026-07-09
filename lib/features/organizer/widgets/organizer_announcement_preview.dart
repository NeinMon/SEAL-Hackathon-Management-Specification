import '../../../shared.dart';

class OrganizerAnnouncementPreview {
  const OrganizerAnnouncementPreview._();

  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String content,
    required String role,
    required String? eventTitle,
    required int recipientCount,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.announcementPreviewTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PreviewLine(
              label: L10nService.strings.notificationTitleLabel,
              value: title,
            ),
            _PreviewLine(
              label: L10nService.strings.notificationContentLabel,
              value: content,
            ),
            _PreviewLine(
              label: L10nService.strings.recipientLabel,
              value: L10nService.strings.announcementRolePreview(
                role == 'all'
                    ? L10nService.strings.allFilter
                    : AppRoles.label(role),
              ),
            ),
            _PreviewLine(
              label: L10nService.strings.eventLabel,
              value: eventTitle ?? L10nService.strings.announcementNoEvent,
            ),
            _PreviewLine(
              label: L10nService.strings.recipientCountLabel,
              value: L10nService.strings.recipientCountValue(recipientCount),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancelButton),
          ),
          FilledButton.icon(
            onPressed: recipientCount == 0
                ? null
                : () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.send_outlined),
            label: Text(context.l10n.confirmSendAnnouncementButton),
          ),
        ],
      ),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  const _PreviewLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: context.sealTheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
