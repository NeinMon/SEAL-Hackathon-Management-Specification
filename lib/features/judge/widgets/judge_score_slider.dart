import '../../../shared.dart';

class JudgeScoreSlider extends StatefulWidget {
  const JudgeScoreSlider({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.index,
    this.weight = 1,
  });

  final String label;
  final String description;
  final IconData icon;
  final double value;
  final ValueChanged<double> onChanged;
  final int? index;
  final double weight;

  @override
  State<JudgeScoreSlider> createState() => _JudgeScoreSliderState();
}

class _JudgeScoreSliderState extends State<JudgeScoreSlider> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _scoreText(widget.value));
  }

  @override
  void didUpdateWidget(covariant JudgeScoreSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_rounded(widget.value) != _rounded(oldWidget.value) &&
        _controller.text != _scoreText(widget.value)) {
      _controller.text = _scoreText(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Semantics(
      label: L10nService.strings.scoreSliderSemantic(
        widget.label,
        widget.value.toStringAsFixed(1),
        widget.description,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: context.sealPrimary.withValues(alpha: 0.12),
                  child: Text(
                    widget.index == null ? '' : '${widget.index}',
                    style: TextStyle(
                      color: context.sealPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            widget.icon,
                            color: context.sealPrimary,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: seal.onSurfaceVariant,
                          fontSize: 12,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StatusPill(
                      label: L10nService.strings.scoreOutOfTenLabel(
                        widget.value.toStringAsFixed(1),
                      ),
                      color: context.sealTertiary,
                      icon: Icons.speed_outlined,
                    ),
                    if (widget.weight != 1) ...[
                      const SizedBox(height: 6),
                      StatusPill(
                        label: L10nService.strings.scoreWeightLabel(
                          widget.weight.toStringAsFixed(1),
                        ),
                        color: seal.onSurfaceVariant,
                        icon: Icons.scale_outlined,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 52,
              child: Row(
                children: [
                  IconButton(
                    tooltip: context.l10n.decreaseScoreTooltip,
                    onPressed: () => _step(-0.5),
                    icon: Icon(Icons.remove),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,2}([,.]\d?)?$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        isDense: true,
                        suffixText: '/10',
                      ),
                      onChanged: _applyInput,
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.increaseScoreTooltip,
                    onPressed: () => _step(0.5),
                    icon: Icon(Icons.add),
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
    final next = _rounded((widget.value + delta).clamp(0, 10).toDouble());
    _controller.text = _scoreText(next);
    widget.onChanged(next);
  }

  void _applyInput(String raw) {
    final parsed = double.tryParse(raw.replaceAll(',', '.'));
    if (parsed == null || parsed < 0 || parsed > 10) return;
    widget.onChanged(_rounded(parsed));
  }

  String _scoreText(double value) => value.toStringAsFixed(1);

  double _rounded(double raw) => double.parse(raw.toStringAsFixed(1));
}
