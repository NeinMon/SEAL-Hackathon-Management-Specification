import '../../../shared.dart';

class OrganizerSubmissionTile extends StatelessWidget {
  const OrganizerSubmissionTile({
    super.key,
    required this.submission,
    required this.averageLabel,
    required this.subtitle,
    required this.onTap,
  });

  final ProjectSubmission submission;
  final String averageLabel;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.assignment_turned_in_outlined),
        title: Text(submission.projectName),
        subtitle: Text(subtitle),
        trailing: Text(
          averageLabel,
          style: TextStyle(
            color: context.sealPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
