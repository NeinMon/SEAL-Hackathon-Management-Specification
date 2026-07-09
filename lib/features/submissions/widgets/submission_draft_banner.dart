import '../../../shared.dart';

class SubmissionDraftBanner extends StatelessWidget {
  const SubmissionDraftBanner({
    super.key,
    required this.draftSavedAt,
    required this.onClearDraft,
  });

  final String? draftSavedAt;
  final VoidCallback onClearDraft;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.save_outlined, color: context.sealSecondary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                draftSavedAt == null || draftSavedAt!.isEmpty
                    ? L10nService.strings.submissionDraftAutoSaving
                    : L10nService.strings.submissionDraftSavedAt(draftSavedAt!),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(
              onPressed: onClearDraft,
              child: Text(context.l10n.clearDraftButton),
            ),
          ],
        ),
      ),
    );
  }
}
