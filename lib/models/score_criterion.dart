import '../core/l10n/l10n_service.dart';

class ScoreCriterion {
  const ScoreCriterion({
    required this.id,
    required this.eventId,
    required this.label,
    required this.description,
    required this.weight,
    required this.sortOrder,
  });

  final String id;
  final String eventId;
  final String label;
  final String description;
  final double weight;
  final int sortOrder;

  /// Weighted mean aligned with the judge scoring UI.
  static double weightedAverage(
    Map<String, double> scores,
    List<ScoreCriterion> criteria,
  ) {
    if (criteria.isNotEmpty) {
      var total = 0.0;
      var weightTotal = 0.0;
      for (final criterion in criteria) {
        final value = scores[criterion.id];
        if (value == null) continue;
        final weight = criterion.weight <= 0 ? 1.0 : criterion.weight;
        total += value * weight;
        weightTotal += weight;
      }
      if (weightTotal > 0) return total / weightTotal;
    }
    if (scores.isEmpty) return 0;
    return scores.values.reduce((a, b) => a + b) / scores.length;
  }

  static List<ScoreCriterion> get defaultCriteria => [
    ScoreCriterion(
      id: 'technical',
      eventId: '',
      label: L10nService.strings.rubricTechnicalLabel,
      description: L10nService.strings.rubricTechnicalDescription,
      weight: 1,
      sortOrder: 0,
    ),
    ScoreCriterion(
      id: 'ui',
      eventId: '',
      label: L10nService.strings.rubricUiLabel,
      description: L10nService.strings.rubricUiDescription,
      weight: 1,
      sortOrder: 1,
    ),
    ScoreCriterion(
      id: 'innovation',
      eventId: '',
      label: L10nService.strings.rubricInnovationLabel,
      description: L10nService.strings.rubricInnovationDescription,
      weight: 1,
      sortOrder: 2,
    ),
  ];

  factory ScoreCriterion.fromJson(Map<String, dynamic> json) {
    return ScoreCriterion(
      id: (json['id'] ?? '') as String,
      eventId: (json['event_id'] ?? '') as String,
      label: (json['label'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      weight: ((json['weight'] ?? 1) as num).toDouble(),
      sortOrder: ((json['sort_order'] ?? 0) as num).toInt(),
    );
  }

  Map<String, dynamic> toJson({required String eventId, required int order}) {
    return {
      'id': id,
      'event_id': eventId,
      'label': label.trim(),
      'description': description.trim(),
      'weight': weight,
      'sort_order': order,
    };
  }

  ScoreCriterion copyWith({
    String? id,
    String? eventId,
    String? label,
    String? description,
    double? weight,
    int? sortOrder,
  }) {
    return ScoreCriterion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      label: label ?? this.label,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
