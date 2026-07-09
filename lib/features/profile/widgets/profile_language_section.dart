import '../../../shared.dart';

class ProfileLanguageSection extends StatelessWidget {
  const ProfileLanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.languageTitle,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'vi',
                  label: Text(context.l10n.languageVi),
                ),
                ButtonSegment(
                  value: 'en',
                  label: Text(context.l10n.languageEn),
                ),
                ButtonSegment(
                  value: 'ja',
                  label: Text(context.l10n.languageJa),
                ),
              ],
              selected: {
                context.watch<LocaleProvider>().locale.languageCode,
              },
              onSelectionChanged: (selection) {
                final code = selection.first;
                context.read<LocaleProvider>().setLocale(Locale(code));
              },
            ),
          ],
        ),
      ),
    );
  }
}
