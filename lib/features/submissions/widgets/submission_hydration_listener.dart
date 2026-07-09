import '../../../shared.dart';

class SubmissionHydrationListener extends StatelessWidget {
  const SubmissionHydrationListener({
    super.key,
    required this.latestSubmission,
    required this.hydratedSubmissionId,
    required this.shouldHydrate,
    required this.onHydrate,
  });

  final ProjectSubmission? latestSubmission;
  final String? hydratedSubmissionId;
  final bool shouldHydrate;
  final ValueChanged<ProjectSubmission> onHydrate;

  @override
  Widget build(BuildContext context) {
    if (latestSubmission != null &&
        latestSubmission!.id != hydratedSubmissionId &&
        shouldHydrate) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => onHydrate(latestSubmission!),
      );
    }
    return const SizedBox.shrink();
  }
}
