import '../../../shared.dart';

class OrganizerScoreCriteriaDialog {
  const OrganizerScoreCriteriaDialog._();

  static Future<void> show(BuildContext context) async {
    final events = context.read<EventProvider>().events;
    final scores = context.read<ScoreProvider>();
    if (events.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.noEventsYet)));
      return;
    }
    final compact = MediaQuery.sizeOf(context).width < 640;
    if (compact) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.95,
          child: _OrganizerScoreCriteriaForm(
            events: events,
            scores: scores,
            compact: true,
          ),
        ),
      );
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (_) => _OrganizerScoreCriteriaForm(
        events: events,
        scores: scores,
        compact: false,
      ),
    );
  }
}

class _OrganizerScoreCriteriaForm extends StatefulWidget {
  const _OrganizerScoreCriteriaForm({
    required this.events,
    required this.scores,
    required this.compact,
  });

  final List<HackathonEvent> events;
  final ScoreProvider scores;
  final bool compact;

  @override
  State<_OrganizerScoreCriteriaForm> createState() =>
      _OrganizerScoreCriteriaFormState();
}

class _OrganizerScoreCriteriaFormState
    extends State<_OrganizerScoreCriteriaForm> {
  late String eventId;
  late List<_CriterionDraft> drafts;
  String? errorText;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    eventId = widget.events.first.id;
    drafts = _draftsFor(eventId);
  }

  @override
  void dispose() {
    for (final draft in drafts) {
      draft.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.manageScoreCriteriaTitle),
          leading: IconButton(
            tooltip: context.l10n.cancelButton,
            onPressed: isSaving ? null : () => Navigator.of(context).pop(),
            icon: Icon(Icons.close),
          ),
          actions: [
            TextButton.icon(
              onPressed: isSaving ? null : _submit,
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.save_outlined),
              label: Text(context.l10n.saveButton),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: _buildForm(),
          ),
        ),
      );
    }
    return AlertDialog(
      title: Text(context.l10n.manageScoreCriteriaTitle),
      content: SizedBox(width: 520, child: _buildForm()),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancelButton),
        ),
        FilledButton.icon(
          onPressed: isSaving ? null : _submit,
          icon: isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(Icons.save_outlined),
          label: Text(context.l10n.saveButton),
        ),
      ],
    );
  }

  Widget _buildForm() {
    final hasCustomCriteria = widget.scores.criteria.any(
      (item) => item.eventId == eventId,
    );
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: eventId,
            decoration: InputDecoration(
              labelText: L10nService.strings.eventLabel,
              prefixIcon: Icon(Icons.event_outlined),
            ),
            items: [
              for (final event in widget.events)
                DropdownMenuItem(value: event.id, child: Text(event.title)),
            ],
            onChanged: isSaving
                ? null
                : (value) {
                    if (value == null) return;
                    setState(() {
                      for (final draft in drafts) {
                        draft.dispose();
                      }
                      eventId = value;
                      drafts = _draftsFor(value);
                      errorText = null;
                    });
                  },
          ),
          const SizedBox(height: 12),
          if (!hasCustomCriteria) ...[
            StatusBanner(message: L10nService.strings.defaultRubricHint),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: isSaving ? null : _resetToDefaultCriteria,
                icon: Icon(Icons.restart_alt_outlined),
                label: Text(context.l10n.useDefaultRubricButton),
              ),
            ),
            const SizedBox(height: 8),
          ],
          for (var index = 0; index < drafts.length; index++)
            _CriterionEditor(
              draft: drafts[index],
              onDelete: drafts.length <= 1
                  ? null
                  : () {
                      setState(() {
                        drafts.removeAt(index).dispose();
                      });
                    },
            ),
          OutlinedButton.icon(
            onPressed: drafts.length >= AppValidators.maxScoreCriteria
                ? null
                : () => setState(() {
                    drafts.add(_CriterionDraft.empty(drafts.length));
                  }),
            icon: Icon(Icons.add),
            label: Text(context.l10n.addScoreCriterionButton),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 10),
            Text(
              errorText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<_CriterionDraft> _draftsFor(String eventId) {
    return widget.scores
        .criteriaForEvent(eventId)
        .asMap()
        .entries
        .map((entry) => _CriterionDraft.fromCriterion(entry.value, entry.key))
        .toList();
  }

  void _resetToDefaultCriteria() {
    setState(() {
      for (final draft in drafts) {
        draft.dispose();
      }
      drafts = ScoreCriterion.defaultCriteria
          .asMap()
          .entries
          .map((entry) => _CriterionDraft.fromCriterion(entry.value, entry.key))
          .toList();
      errorText = null;
    });
  }

  Future<void> _submit() async {
    final criteria = <ScoreCriterion>[];
    for (var index = 0; index < drafts.length; index++) {
      final draft = drafts[index];
      criteria.add(
        ScoreCriterion(
          id: draft.id,
          eventId: eventId,
          label: draft.label.text,
          description: draft.description.text,
          weight: 1,
          sortOrder: index,
        ),
      );
    }
    final validationError = AppValidators.scoreCriteria(criteria);
    if (validationError != null) {
      setState(() => errorText = validationError);
      return;
    }
    setState(() {
      isSaving = true;
      errorText = null;
    });
    await widget.scores.saveCriteria(eventId: eventId, criteria: criteria);
    if (!mounted) return;
    if (widget.scores.error != null) {
      setState(() {
        errorText = widget.scores.error;
        isSaving = false;
      });
      return;
    }
    Navigator.of(context).pop();
  }
}

class _CriterionEditor extends StatelessWidget {
  const _CriterionEditor({required this.draft, required this.onDelete});

  final _CriterionDraft draft;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: draft.label,
                    decoration: InputDecoration(
                      labelText: L10nService.strings.scoreCriterionLabel,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.deleteButton,
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),
            TextField(
              controller: draft.description,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: L10nService.strings.scoreCriterionDescription,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CriterionDraft {
  _CriterionDraft({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final TextEditingController label;
  final TextEditingController description;

  factory _CriterionDraft.fromCriterion(ScoreCriterion criterion, int index) {
    return _CriterionDraft(
      id: criterion.id.isEmpty ? 'criterion_$index' : criterion.id,
      label: TextEditingController(text: criterion.label),
      description: TextEditingController(text: criterion.description),
    );
  }

  factory _CriterionDraft.empty(int index) {
    return _CriterionDraft(
      id: 'criterion_${DateTime.now().millisecondsSinceEpoch}_$index',
      label: TextEditingController(),
      description: TextEditingController(),
    );
  }

  void dispose() {
    label.dispose();
    description.dispose();
  }
}
