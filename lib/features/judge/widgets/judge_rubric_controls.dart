import '../../../shared.dart';
import 'judge_score_slider.dart';

class JudgeRubricControls extends StatelessWidget {
  const JudgeRubricControls({
    super.key,
    required this.criteria,
    required this.values,
    required this.feedback,
    required this.inlineError,
    required this.onChanged,
  });

  final List<ScoreCriterion> criteria;
  final Map<String, double> values;
  final TextEditingController feedback;
  final String? inlineError;
  final void Function(String id, double value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < criteria.length; index++) ...[
          Builder(
            builder: (context) {
              final criterion = criteria[index];
              return JudgeScoreSlider(
                index: index + 1,
                label: criterion.label,
                description: criterion.description,
                icon: _iconFor(criterion.id),
                value: values[criterion.id] ?? 8,
                weight: criterion.weight <= 0 ? 1 : criterion.weight,
                onChanged: (value) => onChanged(criterion.id, value),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 10),
        TextField(
          controller: feedback,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: L10nService.strings.feedbackLabel,
            prefixIcon: Icon(Icons.rate_review_outlined),
          ),
        ),
        if (inlineError != null) ...[
          const SizedBox(height: 8),
          Text(
            inlineError!,
            style: TextStyle(
              color: context.sealError,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  IconData _iconFor(String id) {
    return switch (id) {
      'technical' => Icons.memory_outlined,
      'ui' => Icons.design_services_outlined,
      'innovation' => Icons.auto_awesome_outlined,
      _ => Icons.fact_check_outlined,
    };
  }
}
