import '../../../shared.dart';
import '../helpers/submission_screen_controller.dart';
import '../widgets/submission_content.dart';

class SubmissionScreen extends StatefulWidget {
  const SubmissionScreen({super.key});

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  late final SubmissionScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SubmissionScreenController(
      formKey: GlobalKey<FormState>(),
      projectName: TextEditingController(),
      github: TextEditingController(),
      video: TextEditingController(),
      description: TextEditingController(),
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );
    _controller.attachDraftListeners();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _controller.bootstrap(context),
    );
  }

  @override
  void dispose() {
    _controller.detachDraftListeners();
    _controller.projectName.dispose();
    _controller.github.dispose();
    _controller.video.dispose();
    _controller.description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoleGate(
      allowedRoles: const {AppRoles.participant},
      message: L10nService.strings.submissionsRoleGateMessage,
      child: SubmissionContent(
        formKey: _controller.formKey,
        projectName: _controller.projectName,
        github: _controller.github,
        video: _controller.video,
        description: _controller.description,
        error: _controller.error,
        selectedTeamId: _controller.selectedTeamId,
        onErrorChanged: _controller.setError,
        hydratedSubmissionId: _controller.hydratedSubmissionId,
        draftTeamId: _controller.draftTeamId,
        draftSavedAt: _controller.draftSavedAt,
        onTeamChanged: (value) => _controller.selectTeam(context, value),
        onHydrateSubmission: _controller.hydrateSubmission,
        onSubmissionSaved: _controller.clearDraftAfterSave,
        onClearDraft: () => _controller.clearDraft(context),
      ),
    );
  }
}
