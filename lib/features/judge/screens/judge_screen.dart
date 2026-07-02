import '../../../shared.dart';
import '../widgets/judge_content.dart';

class JudgeScreen extends StatefulWidget {
  const JudgeScreen({super.key});

  @override
  State<JudgeScreen> createState() => _JudgeScreenState();
}

class _JudgeScreenState extends State<JudgeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubmissionProvider>().loadSubmissions();
      context.read<ScoreProvider>().loadScores();
      context.read<TeamProvider>().loadTeams();
      context.read<EventProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventId = GoRouter.maybeOf(
      context,
    )?.state.uri.queryParameters['event'];
    return RoleGate(
      allowedRoles: AppRoles.scorers,
      message: AppStrings.judgeRoleGateMessage,
      child: JudgeContent(eventId: eventId),
    );
  }
}
