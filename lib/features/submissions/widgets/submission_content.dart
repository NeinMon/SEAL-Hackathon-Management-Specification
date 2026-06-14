import '../../../shared.dart';
import 'submission_form_section.dart';
import 'submission_history_card.dart';
import 'submission_status_card.dart';

class SubmissionContent extends StatelessWidget {
  const SubmissionContent({
    super.key,
    required this.formKey,
    required this.projectName,
    required this.github,
    required this.video,
    required this.description,
    required this.error,
    required this.selectedTeamId,
    required this.onErrorChanged,
    required this.hydratedSubmissionId,
    required this.onTeamChanged,
    required this.onHydrateSubmission,
    required this.onSubmissionSaved,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController projectName;
  final TextEditingController github;
  final TextEditingController video;
  final TextEditingController description;
  final String? error;
  final String? selectedTeamId;
  final ValueChanged<String?> onErrorChanged;
  final String? hydratedSubmissionId;
  final ValueChanged<String?> onTeamChanged;
  final ValueChanged<ProjectSubmission> onHydrateSubmission;
  final VoidCallback onSubmissionSaved;

  @override
  Widget build(BuildContext context) {
    final teams = context.watch<TeamProvider>().teams;
    final submissions = context.watch<SubmissionProvider>();
    final scores = context.watch<ScoreProvider>();
    final user = context.watch<AuthProvider>().user;
    final loading =
        context.watch<TeamProvider>().isLoading ||
        submissions.isLoading ||
        scores.isLoading;
    final myTeams = user == null
        ? <Team>[]
        : teams
              .where(
                (team) => team.members.any((member) => member.id == user.id),
              )
              .toList();
    final targetTeam = myTeams.isEmpty
        ? null
        : myTeams.firstWhere(
            (team) => team.id == selectedTeamId,
            orElse: () => myTeams.first,
          );
    final latestSubmission = targetTeam == null
        ? null
        : submissions.submissions
              .where((submission) => submission.teamId == targetTeam.id)
              .cast<ProjectSubmission?>()
              .fold<ProjectSubmission?>(
                null,
                (previous, current) =>
                    previous == null ||
                        current!.submittedAt.isAfter(previous.submittedAt)
                    ? current
                    : previous,
              );
    if (latestSubmission != null &&
        latestSubmission.id != hydratedSubmissionId &&
        _formIsEmpty()) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => onHydrateSubmission(latestSubmission),
      );
    }
    final submitActionLabel = latestSubmission == null
        ? AppStrings.submitProjectAction
        : AppStrings.updateSubmissionButton;
    final status = resolveSubmissionStatus(latestSubmission, scores);
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        const SealSectionHeader(
          title: AppStrings.submitScreenTitle,
          subtitle: AppStrings.submitScreenSubtitle,
          icon: Icons.upload_file_outlined,
        ),
        SubmissionStatusCard(
          submission: latestSubmission,
          status: status,
          scoreCount: latestSubmission == null
              ? 0
              : scores.scoreCountFor(latestSubmission.id),
        ),
        const SizedBox(height: 14),
        Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: AdaptiveTwoPane(
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SubmissionFormSection(
                  title: AppStrings.teamTitle,
                  icon: Icons.groups_outlined,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        key: ValueKey(
                          'submission-team-${targetTeam?.id}-${myTeams.length}',
                        ),
                        initialValue: targetTeam?.id,
                        decoration: const InputDecoration(
                          labelText: AppStrings.teamTitle,
                          prefixIcon: Icon(Icons.groups_outlined),
                        ),
                        items: [
                          for (final team in myTeams)
                            DropdownMenuItem(
                              value: team.id,
                              child: Text(team.name),
                            ),
                        ],
                        onChanged: myTeams.isEmpty ? null : onTeamChanged,
                      ),
                      if (myTeams.isEmpty) ...[
                        const SizedBox(height: 10),
                        const StatusBanner(
                          message: AppStrings.joinTeamBeforeSubmit,
                          isError: true,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SubmissionFormSection(
                  title: AppStrings.projectInfoSection,
                  icon: Icons.lightbulb_outline,
                  child: TextFormField(
                    controller: projectName,
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.projectName,
                    decoration: const InputDecoration(
                      labelText: AppStrings.projectNameLabel,
                      prefixIcon: Icon(Icons.lightbulb_outline),
                    ),
                  ),
                ),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SubmissionFormSection(
                  title: AppStrings.linksSection,
                  icon: Icons.link_outlined,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: github,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                        validator: (value) => AppValidators.webUrl(
                          value,
                          label: AppStrings.githubUrlLabel,
                        ),
                        decoration: const InputDecoration(
                          labelText: AppStrings.githubUrlLabel,
                          prefixIcon: Icon(Icons.code_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: video,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                        validator: (value) => AppValidators.webUrl(
                          value,
                          label: AppStrings.demoVideoUrlLabel,
                        ),
                        decoration: const InputDecoration(
                          labelText: AppStrings.demoVideoUrlLabel,
                          prefixIcon: Icon(Icons.play_circle_outline),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SubmissionFormSection(
                  title: AppStrings.descriptionSection,
                  icon: Icons.notes_outlined,
                  child: TextFormField(
                    controller: description,
                    minLines: 3,
                    maxLines: 5,
                    validator: AppValidators.projectDescription,
                    decoration: const InputDecoration(
                      labelText: AppStrings.projectDescriptionHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const StatusBanner(message: AppStrings.submissionDescriptionTip),
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(
            error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        if (submissions.error != null)
          StatusBanner(message: submissions.error!, isError: true),
        if (submissions.message != null)
          StatusBanner(message: submissions.message!),
        const SizedBox(height: AppSizes.paddingMedium),
        FilledButton.icon(
          onPressed: loading
              ? null
              : () async {
                  if (!(formKey.currentState?.validate() ?? false)) return;
                  final payloadError = AppValidators.submissionPayload(
                    teamId: targetTeam?.id ?? '',
                    name: projectName.text,
                    githubUrl: github.text,
                    videoUrl: video.text,
                    description: description.text,
                  );
                  if (payloadError != null) {
                    onErrorChanged(payloadError);
                    return;
                  }
                  if (targetTeam == null) {
                    onErrorChanged(AppStrings.validationJoinTeamBeforeSubmit);
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
                  );
                  if (!context.mounted) return;
                  if (submissionProvider.error != null) return;
                  final recipients = targetTeam.members
                      .map((member) => member.id)
                      .toSet();
                  for (final recipientId in recipients) {
                    await context.read<NotificationProvider>().push(
                      AppStrings.submissionSavedNotificationTitle,
                      AppStrings.submissionSavedNotificationBody(
                        projectName.text.trim(),
                      ),
                      'system',
                      userId: recipientId,
                    );
                  }
                  onErrorChanged(null);
                  onSubmissionSaved();
                },
          icon: loading
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload_file),
          label: Text(submitActionLabel),
        ),
        const SizedBox(height: 20),
        const Text(
          AppStrings.latestSubmissionTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (loading)
          const LoadingCardList(itemCount: 1)
        else if (targetTeam == null)
          EmptyState(
            message: AppStrings.selectTeamToSubmit,
            actionLabel: AppStrings.goToTeamAction,
            onAction: () => context.go(AppRoutes.teams),
          )
        else if (latestSubmission == null)
          const EmptyState(message: AppStrings.teamHasNoSubmission)
        else
          SubmissionHistoryCard(
            submission: latestSubmission,
            history: submissions.historyFor(latestSubmission.id),
            scores: scores.scoresFor(latestSubmission.id),
          ),
      ],
    );
  }

  bool _formIsEmpty() {
    return projectName.text.trim().isEmpty &&
        github.text.trim().isEmpty &&
        video.text.trim().isEmpty &&
        description.text.trim().isEmpty;
  }
}
