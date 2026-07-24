import '../../../shared.dart';

class SubmissionScreenController {
  SubmissionScreenController({
    required this.formKey,
    required this.projectName,
    required this.github,
    required this.video,
    required this.description,
    required this.onStateChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController projectName;
  final TextEditingController github;
  final TextEditingController video;
  final TextEditingController description;
  final VoidCallback onStateChanged;

  String? error;
  String? selectedTeamId;
  String? hydratedSubmissionId;
  String? draftTeamId;
  String? draftSavedAt;
  bool _restoringDraft = false;

  void attachDraftListeners() {
    for (final controller in [projectName, github, video, description]) {
      controller.addListener(_persistDraft);
    }
  }

  void detachDraftListeners() {
    for (final controller in [projectName, github, video, description]) {
      controller.removeListener(_persistDraft);
    }
  }

  Future<void> bootstrap(BuildContext context) async {
    final user = context.read<AuthProvider>().user;
    final eventId = RouteQuery.eventIdFrom(context);
    if (user != null) {
      await Future.wait([
        context.read<TeamProvider>().loadTeamWorkspace(user),
        if (eventId != null) ...[
          context.read<SubmissionProvider>().loadSubmissions(eventId: eventId),
          context.read<ScoreProvider>().loadScores(eventId: eventId),
        ],
      ]);
    }
    if (!context.mounted) return;

    final teamId = RouteQuery.teamIdFrom(context);
    if (teamId != null && teamId.isNotEmpty) {
      selectedTeamId = teamId;
      onStateChanged();
      await _restoreDraft(teamId);
    } else {
      await _preselectTeamFromActiveEvent(context);
    }
    if (!context.mounted) return;
    await _syncActiveEvent(context);
    if (!context.mounted) return;
    _maybeRedirectScopedSubmit(context);
  }

  void _maybeRedirectScopedSubmit(BuildContext context) {
    if (RouteQuery.eventIdFrom(context) != null) return;
    final teamId = RouteQuery.teamIdFrom(context);
    if (teamId == null || teamId.isEmpty) return;
    final redirect = RouteQuery.redirectFlatSubmit(
      context.read<TeamProvider>().teams,
      teamId,
    );
    if (redirect != null && context.mounted) {
      context.go(redirect);
    }
  }

  Future<void> _syncActiveEvent(BuildContext context) async {
    final auth = context.read<AuthProvider>().user;
    final events = context.read<EventProvider>().events;
    final teams = context.read<TeamProvider>().teams;
    await context.read<ActiveEventProvider>().syncContext(
      events: events,
      teams: teams,
      userId: auth?.id,
      routeEventId: RouteQuery.eventIdFrom(context),
    );
  }

  Future<void> _preselectTeamFromActiveEvent(BuildContext context) async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final eventId = context.read<ActiveEventProvider>().selectedEventId ??
        RouteQuery.eventIdFrom(context);
    if (eventId == null) return;
    final teams = context.read<TeamProvider>().teams;
    final team = TeamMembership.teamForUserOnEvent(
      teams: teams,
      userId: user.id,
      eventId: eventId,
    );
    if (team == null) return;
    selectedTeamId = team.id;
    onStateChanged();
    await _restoreDraft(team.id);
  }

  Future<void> _persistDraft() async {
    if (_restoringDraft) return;
    final teamId = selectedTeamId;
    if (teamId == null || teamId.isEmpty) return;
    await SubmissionDraftStore.save(
      teamId: teamId,
      projectName: projectName.text,
      github: github.text,
      video: video.text,
      description: description.text,
    );
    final draft = await SubmissionDraftStore.load(teamId);
    draftTeamId = teamId;
    draftSavedAt = _formatSavedAt(draft?['savedAt']);
    onStateChanged();
  }

  Future<void> _restoreDraft(String teamId) async {
    final draft = await SubmissionDraftStore.load(teamId);
    if (draft == null) return;
    if (!_formIsEmpty()) return;
    _restoringDraft = true;
    projectName.text = draft['projectName'] ?? '';
    github.text = draft['github'] ?? '';
    video.text = draft['video'] ?? '';
    description.text = draft['description'] ?? '';
    draftTeamId = teamId;
    draftSavedAt = _formatSavedAt(draft['savedAt']);
    _restoringDraft = false;
    onStateChanged();
  }

  String? _formatSavedAt(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return null;
    return DateFormat('dd/MM HH:mm').format(parsed);
  }

  bool _formIsEmpty() {
    return projectName.text.trim().isEmpty &&
        github.text.trim().isEmpty &&
        video.text.trim().isEmpty &&
        description.text.trim().isEmpty;
  }

  void selectTeam(BuildContext context, String? value) {
    if (value == selectedTeamId) return;
    selectedTeamId = value;
    hydratedSubmissionId = null;
    draftTeamId = null;
    draftSavedAt = null;
    error = null;
    projectName.clear();
    github.clear();
    video.clear();
    description.clear();
    onStateChanged();
    if (value != null) {
      _restoreDraft(value);
      final teams = context.read<TeamProvider>().teams;
      for (final team in teams) {
        if (team.id == value) {
          context.read<ActiveEventProvider>().setFromUserPick(team.eventId);
          context.read<SubmissionProvider>().loadSubmissions(
            eventId: team.eventId,
          );
          context.read<ScoreProvider>().loadScores(eventId: team.eventId);
          break;
        }
      }
    }
  }

  void hydrateSubmission(ProjectSubmission submission) {
    if (hydratedSubmissionId == submission.id) return;
    hydratedSubmissionId = submission.id;
    draftTeamId = null;
    draftSavedAt = null;
    error = null;
    projectName.text = submission.projectName;
    github.text = submission.githubUrl;
    video.text = submission.videoUrl;
    description.text = submission.description;
    onStateChanged();
  }

  Future<void> clearDraft(BuildContext context) async {
    final teamId = selectedTeamId;
    if (teamId != null) {
      await SubmissionDraftStore.clear(teamId);
    }
    draftTeamId = null;
    draftSavedAt = null;
    projectName.clear();
    github.clear();
    video.clear();
    description.clear();
    onStateChanged();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.draftClearedMessage)),
    );
  }

  Future<void> clearDraftAfterSave() async {
    final teamId = selectedTeamId;
    if (teamId != null) {
      await SubmissionDraftStore.clear(teamId);
    }
    hydratedSubmissionId = null;
    draftTeamId = null;
    draftSavedAt = null;
    onStateChanged();
  }

  void setError(String? value) {
    error = value;
    onStateChanged();
  }
}
