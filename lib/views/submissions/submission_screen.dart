import '../../shared.dart';

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
  String? hydratedSubmissionId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamProvider>().loadTeams();
      context.read<SubmissionProvider>().loadSubmissions();
      context.read<ScoreProvider>().loadScores();
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
      message: 'Chỉ thí sinh mới có thể nộp project.',
      child: _SubmissionContent(
        projectName: projectName,
        github: github,
        video: video,
        description: description,
        error: error,
        selectedTeamId: selectedTeamId,
        onErrorChanged: (value) => setState(() => error = value),
        hydratedSubmissionId: hydratedSubmissionId,
        onTeamChanged: _selectTeam,
        onHydrateSubmission: _hydrateSubmission,
        onSubmissionSaved: () => setState(() => hydratedSubmissionId = null),
      ),
    );
  }

  void _selectTeam(String? value) {
    if (value == selectedTeamId) return;
    setState(() {
      selectedTeamId = value;
      hydratedSubmissionId = null;
      error = null;
      projectName.clear();
      github.clear();
      video.clear();
      description.clear();
    });
  }

  void _hydrateSubmission(ProjectSubmission submission) {
    if (!mounted || hydratedSubmissionId == submission.id) return;
    setState(() {
      hydratedSubmissionId = submission.id;
      error = null;
      projectName.text = submission.projectName;
      github.text = submission.githubUrl;
      video.text = submission.videoUrl;
      description.text = submission.description;
    });
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
    required this.hydratedSubmissionId,
    required this.onTeamChanged,
    required this.onHydrateSubmission,
    required this.onSubmissionSaved,
  });

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
        ? 'Nộp project'
        : 'Cập nhật bài nộp';
    final status = _submissionStatus(latestSubmission, scores);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Nộp bài',
          subtitle: 'Gửi GitHub, video demo và mô tả project cho giám khảo.',
          icon: Icons.upload_file_outlined,
        ),
        _SubmissionStatusCard(
          submission: latestSubmission,
          status: status,
          scoreCount: latestSubmission == null
              ? 0
              : scores.scoreCountFor(latestSubmission.id),
        ),
        const SizedBox(height: 14),
        AdaptiveTwoPane(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FormSection(
                title: 'Team',
                icon: Icons.groups_outlined,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      key: ValueKey(
                        'submission-team-${targetTeam?.id}-${myTeams.length}',
                      ),
                      initialValue: targetTeam?.id,
                      decoration: const InputDecoration(
                        labelText: 'Team',
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
                        message: 'Tạo hoặc tham gia team trước khi nộp bài.',
                        isError: true,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _FormSection(
                title: 'Thông tin project',
                icon: Icons.lightbulb_outline,
                child: TextField(
                  controller: projectName,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Tên project',
                    prefixIcon: Icon(Icons.lightbulb_outline),
                  ),
                ),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FormSection(
                title: 'Links',
                icon: Icons.link_outlined,
                child: Column(
                  children: [
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
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _FormSection(
                title: 'Mô tả',
                icon: Icons.notes_outlined,
                child: TextField(
                  controller: description,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Project giải quyết vấn đề gì?',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const StatusBanner(
          message:
              'Gợi ý: nêu vấn đề, giải pháp, tính năng chính, tech stack và tác động đo được.',
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
          onPressed: loading
              ? null
              : () async {
                  final valid =
                      AppValidators.isValidWebUrl(github.text) &&
                      AppValidators.isValidWebUrl(video.text);
                  if (projectName.text.trim().isEmpty ||
                      description.text.trim().isEmpty) {
                    onErrorChanged('Tên project và mô tả là bắt buộc.');
                    return;
                  }
                  if (!valid) {
                    onErrorChanged('Nhập GitHub URL và Demo video URL hợp lệ.');
                    return;
                  }
                  if (targetTeam == null) {
                    onErrorChanged('Tạo hoặc tham gia team trước khi nộp bài.');
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
                      'Đã lưu bài nộp',
                      '${projectName.text.trim()} đã được nộp thành công.',
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
          'Bài nộp mới nhất',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (loading)
          const LoadingCardList(itemCount: 1)
        else if (targetTeam == null)
          EmptyState(
            message: 'Chọn hoặc tạo team để nộp project.',
            actionLabel: 'Đến Team',
            onAction: () => context.go(AppRoutes.teams),
          )
        else if (latestSubmission == null)
          const EmptyState(message: 'Team này chưa nộp project.')
        else
          _SubmissionHistoryCard(
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

  _SubmissionStatus _submissionStatus(
    ProjectSubmission? submission,
    ScoreProvider scores,
  ) {
    if (submission == null) {
      return const _SubmissionStatus(
        label: 'Cần nộp bài',
        helper: 'Chưa có project được nộp.',
        color: SealPalette.tertiary,
        icon: Icons.pending_actions_outlined,
      );
    }
    final scoreCount = scores.scoreCountFor(submission.id);
    if (scoreCount > 0 || submission.status == 'reviewed') {
      return const _SubmissionStatus(
        label: 'Đã chấm',
        helper: 'Giám khảo đã công bố feedback.',
        color: SealPalette.secondary,
        icon: Icons.verified_outlined,
      );
    }
    return const _SubmissionStatus(
      label: 'Đã nộp',
      helper: 'Đang chờ giám khảo chấm.',
      color: SealPalette.primary,
      icon: Icons.task_alt_outlined,
    );
  }
}

class _SubmissionStatusCard extends StatelessWidget {
  const _SubmissionStatusCard({
    required this.submission,
    required this.status,
    required this.scoreCount,
  });

  final ProjectSubmission? submission;
  final _SubmissionStatus status;
  final int scoreCount;

  @override
  Widget build(BuildContext context) {
    final current = submission;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: status.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: status.color.withValues(alpha: 0.42)),
              ),
              child: Icon(status.icon, color: status.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusPill(
                    label: status.label,
                    color: status.color,
                    icon: status.icon,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    current?.projectName ?? 'Chưa nộp project',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    current == null
                        ? status.helper
                        : '${DateFormat('dd/MM HH:mm').format(current.submittedAt)} - $scoreCount lượt chấm',
                    style: const TextStyle(
                      color: SealPalette.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: SealPalette.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _SubmissionStatus {
  const _SubmissionStatus({
    required this.label,
    required this.helper,
    required this.color,
    required this.icon,
  });

  final String label;
  final String helper;
  final Color color;
  final IconData icon;
}

class _SubmissionHistoryCard extends StatelessWidget {
  const _SubmissionHistoryCard({
    required this.submission,
    required this.history,
    required this.scores,
  });

  final ProjectSubmission submission;
  final List<SubmissionHistory> history;
  final List<ProjectScore> scores;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.code_outlined, color: SealPalette.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    submission.projectName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ),
                StatusPill(
                  label: AppLabels.submissionStatus(submission.status),
                  icon: submission.status == 'reviewed'
                      ? Icons.verified_outlined
                      : Icons.task_alt_outlined,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${formatter.format(submission.submittedAt)}\n${submission.githubUrl}',
              style: const TextStyle(color: SealPalette.onSurfaceVariant),
            ),
            if (history.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Lịch sử cập nhật',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.take(3).length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Text(
                    '${formatter.format(item.changedAt)} - ${AppLabels.submissionStatus(item.status)} - ${item.projectName}',
                    style: const TextStyle(color: SealPalette.onSurfaceVariant),
                  );
                },
              ),
            ],
            if (scores.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Feedback từ giám khảo',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  final score = scores[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${score.average.toStringAsFixed(1)} - ${score.feedback}',
                      style: const TextStyle(
                        color: SealPalette.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
