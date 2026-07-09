import '../../../shared.dart';

class ProfileThemeSection extends StatelessWidget {
  const ProfileThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10nService.strings.themeModeTitle,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(context.l10n.themeModeDark),
                  icon: const Icon(Icons.dark_mode_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(context.l10n.themeModeLight),
                  icon: const Icon(Icons.light_mode_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(context.l10n.themeModeSystem),
                  icon: const Icon(Icons.brightness_auto_outlined),
                ),
              ],
              selected: {context.watch<ThemeProvider>().mode},
              onSelectionChanged: (selection) {
                context.read<ThemeProvider>().setMode(selection.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}
