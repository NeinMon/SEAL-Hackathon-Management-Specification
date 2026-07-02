import '../../../shared.dart';

class JudgeScoreSlider extends StatelessWidget {
  const JudgeScoreSlider({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String description;
  final IconData icon;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Semantics(
      label: AppStrings.scoreSliderSemantic(
        label,
        value.toStringAsFixed(1),
        description,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: seal.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: seal.outlineVariant),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: SealPalette.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                    color: SealPalette.tertiary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                description,
                style: TextStyle(
                  color: seal.onSurfaceVariant,
                  fontSize: 12,
                  height: 1.25,
                ),
              ),
            ),
            SizedBox(
              height: 38,
              child: Row(
                children: [
                  IconButton(
                    tooltip: AppStrings.decreaseScoreTooltip,
                    onPressed: () => _step(-0.5),
                    icon: const Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Slider(
                      value: value.clamp(0, 10).toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 20,
                      label: value.toStringAsFixed(1),
                      onChanged: (next) => onChanged(_rounded(next)),
                    ),
                  ),
                  IconButton(
                    tooltip: AppStrings.increaseScoreTooltip,
                    onPressed: () => _step(0.5),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _step(double delta) {
    onChanged(_rounded((value + delta).clamp(0, 10).toDouble()));
  }

  double _rounded(double raw) => double.parse(raw.toStringAsFixed(1));
}
