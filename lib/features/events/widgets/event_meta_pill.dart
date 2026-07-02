import '../../../shared.dart';

class EventMetaPill extends StatelessWidget {
  const EventMetaPill({super.key, required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: seal.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: seal.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: SealPalette.primary),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
