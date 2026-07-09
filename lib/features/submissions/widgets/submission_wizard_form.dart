import '../../../shared.dart';
import 'submission_form_section.dart';
import 'submission_link_field.dart';
import 'submission_submit_button.dart';

class SubmissionWizardForm extends StatefulWidget {
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
  State<SubmissionWizardForm> createState() => _SubmissionWizardFormState();
}

class _SubmissionWizardFormState extends State<SubmissionWizardForm> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    if (widget.readOnly) {
      return _desktopForm();
    }
    if (!compact) {
      return _desktopForm();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stepper(
          currentStep: step,
          controlsBuilder: (context, details) => const SizedBox.shrink(),
          steps: [
            Step(
              title: Text(context.l10n.submitWizardStepTeam),
              isActive: step >= 0,
              state: step > 0 ? StepState.complete : StepState.indexed,
              content: _teamStep(),
            ),
            Step(
              title: Text(context.l10n.submitWizardStepProject),
              isActive: step >= 1,
              state: step > 1 ? StepState.complete : StepState.indexed,
              content: _projectStep(),
            ),
            Step(
              title: Text(context.l10n.submitWizardStepLinks),
              isActive: step >= 2,
              state: StepState.indexed,
              content: _linksStep(),
            ),
          ],
        ),
        Row(
          children: [
            if (step > 0)
              OutlinedButton(
                onPressed: widget.loading ? null : () => setState(() => step--),
                child: Text(context.l10n.submitWizardBack),
              ),
            const Spacer(),
            if (step < 2)
              FilledButton(
                onPressed: widget.loading ? null : _nextStep,
                child: Text(context.l10n.submitWizardNext),
              ),
          ],
        ),
        if (step == 2 && !widget.readOnly) ...[
          const SizedBox(height: 8),
          Text(
            L10nService.strings.submitWizardReviewTitle,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          SubmissionSubmitButton(
            formKey: widget.formKey,
            team: widget.targetTeam,
            event: widget.targetEvent,
            latestSubmission: widget.latestSubmission,
            projectName: widget.projectName,
            github: widget.github,
            video: widget.video,
            description: widget.description,
            loading: widget.loading,
            submissionClosed: widget.submissionClosed,
            label: widget.submitActionLabel,
            onErrorChanged: widget.onErrorChanged,
            onSubmissionSaved: widget.onSubmissionSaved,
          ),
        ],
      ],
    );
  }

  void _nextStep() {
    if (step == 0 && widget.targetTeam == null) {
      widget.onErrorChanged(L10nService.strings.selectTeamToSubmit);
      return;
    }
    if (step == 1 && AppValidators.projectName(widget.projectName.text) != null) {
      widget.formKey.currentState?.validate();
      return;
    }
    widget.onErrorChanged(null);
    setState(() => step++);
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

  Widget _teamStep() => _teamSection();
  Widget _projectStep() => _projectSection();
  Widget _linksStep() => Column(
    children: [
      _linksSection(),
      const SizedBox(height: 12),
      _descriptionSection(),
    ],
  );

  Widget _teamSection() {
    return SubmissionFormSection(
      title: L10nService.strings.teamTitle,
      icon: Icons.groups_outlined,
      child: DropdownButtonFormField<String>(
        key: ValueKey(
          'submission-team-${widget.targetTeam?.id}-${widget.myTeams.length}',
        ),
        initialValue: widget.targetTeam?.id,
        decoration: InputDecoration(
          labelText: L10nService.strings.teamTitle,
          prefixIcon: Icon(Icons.groups_outlined),
        ),
        items: [
          for (final team in widget.myTeams)
            DropdownMenuItem(value: team.id, child: Text(team.name)),
        ],
        onChanged: widget.readOnly || widget.myTeams.isEmpty
            ? null
            : widget.onTeamChanged,
      ),
    );
  }

  Widget _projectSection() {
    return SubmissionFormSection(
      title: L10nService.strings.projectInfoSection,
      icon: Icons.lightbulb_outline,
      child: TextFormField(
        controller: widget.projectName,
        readOnly: widget.readOnly,
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
            controller: widget.github,
            label: L10nService.strings.githubUrlLabel,
            icon: Icons.code_outlined,
            readOnly: widget.readOnly,
          ),
          const SizedBox(height: 12),
          SubmissionLinkField(
            controller: widget.video,
            label: L10nService.strings.demoVideoUrlLabel,
            icon: Icons.play_circle_outline,
            readOnly: widget.readOnly,
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
        controller: widget.description,
        readOnly: widget.readOnly,
        minLines: 3,
        maxLines: 5,
        validator: AppValidators.projectDescription,
        decoration: InputDecoration(
          labelText: L10nService.strings.projectDescriptionHint,
        ),
      ),
    );
  }
}
