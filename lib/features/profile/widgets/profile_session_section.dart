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
      color: SealPalette.errorContainer.withValues(alpha: 0.10),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              AppStrings.sessionSectionTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              AppStrings.logoutDescription,
              style: TextStyle(color: SealPalette.onSurfaceVariant),
            ),
            const SizedBox(height: AppSizes.paddingCompact),
            OutlinedButton.icon(
              onPressed: isLoading ? null : onLogout,
              icon: const Icon(Icons.logout),
              label: const Text(AppStrings.logoutButton),
            ),
          ],
        ),
      ),
    );
  }
}
