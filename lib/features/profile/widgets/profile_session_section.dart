import '../../../shared.dart';

class ProfileSessionSection extends StatelessWidget {
  const ProfileSessionSection({
    super.key,
    required this.isLoading,
    required this.onLogout,
  });

  final bool isLoading;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.sealErrorContainer.withValues(alpha: 0.10),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              L10nService.strings.sessionSectionTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              L10nService.strings.logoutDescription,
              style: TextStyle(color: context.sealTheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            OutlinedButton.icon(
              onPressed: isLoading ? null : onLogout,
              icon: Icon(Icons.logout),
              label: Text(context.l10n.logoutButton),
            ),
          ],
        ),
      ),
    );
  }
}
