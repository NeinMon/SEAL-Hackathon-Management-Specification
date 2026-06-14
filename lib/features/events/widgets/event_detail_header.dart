import '../../../shared.dart';

class EventDetailHeader extends StatelessWidget {
  const EventDetailHeader({super.key, required this.event});

  final HackathonEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 8,
            child: EventNetworkImage(url: event.bannerUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusPill(
                  label: AppStrings.registrationClosedByDate(
                    DateFormat('dd/MM').format(event.registrationDeadline),
                  ),
                  color: SealPalette.tertiary,
                  icon: Icons.schedule_outlined,
                ),
                const SizedBox(height: AppSizes.paddingCompact),
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: const TextStyle(
                    color: SealPalette.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
