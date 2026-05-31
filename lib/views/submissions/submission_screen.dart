part of '../../main.dart';

class SubmissionScreen extends StatefulWidget {
  const SubmissionScreen({super.key});

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  final projectName = TextEditingController();
  final github = TextEditingController();
  final video = TextEditingController();
  final description = TextEditingController();
  String? error;
  String? selectedTeamId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamProvider>().loadTeams();
      context.read<SubmissionProvider>().loadSubmissions();
    });
  }

  @override
  void dispose() {
    projectName.dispose();
    github.dispose();
    video.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoleGate(
      allowedRoles: const {AppRoles.participant},
      message: 'Only participants can submit hackathon projects.',
      child: _SubmissionContent(
        projectName: projectName,
        github: github,
        video: video,
        description: description,
        error: error,
        selectedTeamId: selectedTeamId,
        onErrorChanged: (value) => setState(() => error = value),
        onTeamChanged: (value) => setState(() => selectedTeamId = value),
      ),
    );
  }
}

class _SubmissionContent extends StatelessWidget {
  const _SubmissionContent({
    required this.projectName,
    required this.github,
    required this.video,
    required this.description,
    required this.error,
    required this.selectedTeamId,
    required this.onErrorChanged,
    required this.onTeamChanged,
  });

  final TextEditingController projectName;
  final TextEditingController github;
  final TextEditingController video;
  final TextEditingController description;
  final String? error;
  final String? selectedTeamId;
  final ValueChanged<String?> onErrorChanged;
  final ValueChanged<String?> onTeamChanged;

  @override
  Widget build(BuildContext context) {
    final teams = context.watch<TeamProvider>().teams;
    final submissions = context.watch<SubmissionProvider>();
    final user = context.watch<AuthProvider>().user;
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
                (previous, current) => previous ?? current,
              );
    final submitActionLabel = latestSubmission == null
        ? 'Finalize Submission'
        : 'Update Submission';
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Submission',
          subtitle: 'Send repository, demo video, and project brief to judges.',
          icon: Icons.upload_file_outlined,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Submission status',
                        style: TextStyle(
                          color: SealPalette.onSurfaceVariant,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current Status: ${latestSubmission?.status ?? 'Not Submitted'}',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          color: latestSubmission == null
                              ? SealPalette.error
                              : SealPalette.secondary,
                        ),
                      ),
                      if (latestSubmission != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          latestSubmission.projectName,
                          style: const TextStyle(
                            color: SealPalette.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: SealPalette.outline,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.history, color: SealPalette.outline),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          key: ValueKey('submission-team-${targetTeam?.id}-${myTeams.length}'),
          initialValue: targetTeam?.id,
          decoration: const InputDecoration(
            labelText: 'Team',
            prefixIcon: Icon(Icons.groups_outlined),
          ),
          items: [
            for (final team in myTeams)
              DropdownMenuItem(value: team.id, child: Text(team.name)),
          ],
          onChanged: myTeams.isEmpty ? null : onTeamChanged,
        ),
        if (myTeams.isEmpty) ...[
          const SizedBox(height: 10),
          const StatusBanner(
            message: 'Create or join a team before submitting a project.',
            isError: true,
          ),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: projectName,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Project name',
            prefixIcon: Icon(Icons.lightbulb_outline),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: github,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'GitHub URL',
            prefixIcon: Icon(Icons.code_outlined),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: video,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Demo video URL',
            prefixIcon: Icon(Icons.play_circle_outline),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: description,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
        const SizedBox(height: 12),
        const StatusBanner(
          message:
              'Tip: include the problem, solution, core features, tech stack, and measurable impact.',
        ),
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
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: submissions.isLoading
              ? null
              : () async {
                  final valid =
                      AppValidators.isValidWebUrl(github.text) &&
                      AppValidators.isValidWebUrl(video.text);
                  if (projectName.text.trim().isEmpty ||
                      description.text.trim().isEmpty) {
                    onErrorChanged(
                      'Project name and description are required.',
                    );
                    return;
                  }
                  if (!valid) {
                    onErrorChanged('Enter valid GitHub and demo video URLs.');
                    return;
                  }
                  if (targetTeam == null) {
                    onErrorChanged('Create or join a team before submitting.');
                    return;
                  }
                  await context.read<SubmissionProvider>().submit(
                    ProjectSubmission(
                      id: 'submission-${DateTime.now().millisecondsSinceEpoch}',
                      teamId: targetTeam.id,
                      projectName: projectName.text.trim(),
                      githubUrl: github.text.trim(),
                      videoUrl: video.text.trim(),
                      description: description.text.trim(),
                    ),
                    existingSubmissionId: latestSubmission?.id,
                  );
                  if (!context.mounted) return;
                  final recipients = targetTeam.members
                      .map((member) => member.id)
                      .toSet();
                  for (final recipientId in recipients) {
                    await context.read<NotificationProvider>().push(
                      'Submission saved',
                      '${projectName.text.trim()} was submitted successfully.',
                      'system',
                      userId: recipientId,
                    );
                  }
                  projectName.clear();
                  github.clear();
                  video.clear();
                  description.clear();
                  onErrorChanged(null);
                },
          icon: submissions.isLoading
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload_file),
          label: Text(submitActionLabel),
        ),
        const SizedBox(height: 20),
        const Text(
          'Submitted projects',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (submissions.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (submissions.submissions.isEmpty)
          const EmptyState(message: 'No submissions yet')
        else
          for (final submission in submissions.submissions)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.code_outlined),
                title: Text(submission.projectName),
                subtitle: Text('${submission.status}\n${submission.githubUrl}'),
                isThreeLine: true,
              ),
            ),
      ],
    );
  }
}
