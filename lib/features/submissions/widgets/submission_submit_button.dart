import '../../../shared.dart';

class SubmissionSubmitButton extends StatelessWidget {
  const SubmissionSubmitButton({
    super.key,
    required this.formKey,
    required this.team,
    required this.event,
    required this.latestSubmission,
    required this.projectName,
    required this.github,
    required this.video,
    required this.description,
    required this.loading,
    required this.submissionClosed,
    required this.label,
    required this.onErrorChanged,
    required this.onSubmissionSaved,
  });

  final GlobalKey<FormState> formKey;
  final Team? team;
  final HackathonEvent? event;
  final ProjectSubmission? latestSubmission;
  final TextEditingController projectName;
  final TextEditingController github;
  final TextEditingController video;
  final TextEditingController description;
  final bool loading;
  final bool submissionClosed;
  final String label;
  final ValueChanged<String?> onErrorChanged;
  final VoidCallback onSubmissionSaved;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: loading || team == null || submissionClosed
          ? null
          : () => _submit(context, team!),
      icon: loading
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(Icons.upload_file),
      label: Text(label),
    );
  }

  Future<void> _submit(BuildContext context, Team targetTeam) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final payloadError = AppValidators.submissionPayload(
      teamId: targetTeam.id,
      name: projectName.text,
      githubUrl: github.text,
      videoUrl: video.text,
      description: description.text,
    );
    if (payloadError != null) {
      onErrorChanged(payloadError);
      return;
    }
    if (event == null) {
      onErrorChanged(L10nService.strings.eventNotLoadedForSubmit);
      return;
    }

    final submissionProvider = context.read<SubmissionProvider>();
    await submissionProvider.submit(
      ProjectSubmission(
        id: 'submission-${DateTime.now().millisecondsSinceEpoch}',
        teamId: targetTeam.id,
        projectName: projectName.text.trim(),
        githubUrl: github.text.trim(),
        videoUrl: video.text.trim(),
        description: description.text.trim(),
        status: 'submitted',
      ),
      existingSubmissionId: latestSubmission?.id,
      event: event,
    );
    if (!context.mounted || submissionProvider.error != null) return;

    await context.read<NotificationProvider>().notifySubmissionSaved(
      team: targetTeam,
      projectName: projectName.text.trim(),
    );
    onErrorChanged(null);
    onSubmissionSaved();
  }
}
