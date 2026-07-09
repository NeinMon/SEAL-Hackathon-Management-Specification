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
      final eventId = GoRouter.maybeOf(
        context,
      )?.state.uri.queryParameters['event'];
      context.read<SubmissionProvider>().loadSubmissions(eventId: eventId);
      context.read<ScoreProvider>().loadScores(eventId: eventId);
      context.read<ScoreProvider>().loadCriteria();
      context.read<TeamProvider>().loadTeams(eventId: eventId);
      context.read<EventProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventId = GoRouter.maybeOf(
      context,
    )?.state.uri.queryParameters['event'];
    return RoleGate(
      allowedRoles: AppRoles.judgeAccess,
      message: L10nService.strings.judgeRoleGateMessage,
      child: JudgeContent(eventId: eventId),
    );
  }
}
