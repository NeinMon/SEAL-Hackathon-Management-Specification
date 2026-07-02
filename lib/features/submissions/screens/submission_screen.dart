import '../../../shared.dart';
import '../widgets/submission_content.dart';

class SubmissionScreen extends StatefulWidget {
  const SubmissionScreen({super.key});

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
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
      final teamId = RouteQuery.teamIdFrom(context);
      if (teamId != null && teamId.isNotEmpty) {
        setState(() => selectedTeamId = teamId);
      }
      context.read<TeamProvider>().loadTeams();
      context.read<SubmissionProvider>().loadSubmissions();
      context.read<ScoreProvider>().loadScores();
      context.read<EventProvider>().loadEvents();
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
      message: AppStrings.submissionsRoleGateMessage,
      child: SubmissionContent(
        formKey: _formKey,
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
