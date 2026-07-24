import '../../../shared.dart';
import 'submission_form_section.dart';
import 'submission_link_field.dart';

class SubmissionWizardForm extends StatelessWidget {
  const SubmissionWizardForm({
    super.key,
    required this.formKey,
    required this.projectName,
    required this.github,
    required this.video,
    required this.description,
    required this.myTeams,
    required this.targetTeam,
    required this.targetEvent,
    required this.latestSubmission,
    required this.loading,
    required this.submissionClosed,
    required this.submitActionLabel,
    required this.onTeamChanged,
    required this.onErrorChanged,
    required this.onSubmissionSaved,
    this.readOnly = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController projectName;
  final TextEditingController github;
  final TextEditingController video;
  final TextEditingController description;
  final List<Team> myTeams;
  final Team? targetTeam;
  final HackathonEvent? targetEvent;
  final ProjectSubmission? latestSubmission;
  final bool loading;
  final bool submissionClosed;
  final String submitActionLabel;
  final ValueChanged<String?> onTeamChanged;
  final ValueChanged<String?> onErrorChanged;
  final VoidCallback onSubmissionSaved;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    if (!compact || readOnly) {
      return _desktopForm();
    }
    return _mobileForm();
  }

  Widget _mobileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _teamSection(),
        const SizedBox(height: 12),
        _projectSection(),
        const SizedBox(height: 12),
        _linksSection(),
        const SizedBox(height: 12),
        _descriptionSection(),
      ],
    );
  }

  Widget _desktopForm() {
    return AdaptiveTwoPane(
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _teamSection(),
          const SizedBox(height: 12),
          _projectSection(),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _linksSection(),
          const SizedBox(height: 12),
          _descriptionSection(),
        ],
      ),
    );
  }

  Widget _teamSection() {
    return SubmissionFormSection(
      title: L10nService.strings.teamTitle,
      icon: Icons.groups_outlined,
      child: DropdownButtonFormField<String>(
        key: ValueKey(
          'submission-team-${targetTeam?.id}-${myTeams.length}',
        ),
        isExpanded: true,
        initialValue: targetTeam?.id,
        decoration: InputDecoration(
          labelText: L10nService.strings.teamTitle,
          prefixIcon: Icon(Icons.groups_outlined),
        ),
        items: [
          for (final team in myTeams)
            DropdownMenuItem(
              value: team.id,
              child: Text(team.name, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: readOnly || myTeams.isEmpty ? null : onTeamChanged,
      ),
    );
  }

  Widget _projectSection() {
    return SubmissionFormSection(
      title: L10nService.strings.projectInfoSection,
      icon: Icons.lightbulb_outline,
      child: TextFormField(
        controller: projectName,
        readOnly: readOnly,
        textInputAction: TextInputAction.next,
        validator: AppValidators.projectName,
        decoration: InputDecoration(
          labelText: L10nService.strings.projectNameLabel,
          prefixIcon: Icon(Icons.lightbulb_outline),
        ),
      ),
    );
  }

  Widget _linksSection() {
    return SubmissionFormSection(
      title: L10nService.strings.linksSection,
      icon: Icons.link_outlined,
      child: Column(
        children: [
          SubmissionLinkField(
            controller: github,
            label: L10nService.strings.githubUrlLabel,
            icon: Icons.code_outlined,
            readOnly: readOnly,
          ),
          const SizedBox(height: 12),
          SubmissionLinkField(
            controller: video,
            label: L10nService.strings.demoVideoUrlLabel,
            icon: Icons.play_circle_outline,
            readOnly: readOnly,
          ),
        ],
      ),
    );
  }

  Widget _descriptionSection() {
    return SubmissionFormSection(
      title: L10nService.strings.descriptionSection,
      icon: Icons.notes_outlined,
      child: TextFormField(
        controller: description,
        readOnly: readOnly,
        minLines: 3,
        maxLines: 5,
        validator: AppValidators.projectDescription,
        decoration: InputDecoration(
          labelText: L10nService.strings.projectDescriptionHint,
          helperText: L10nService.strings.submissionDescriptionTip,
          helperMaxLines: 3,
        ),
      ),
    );
  }
}
