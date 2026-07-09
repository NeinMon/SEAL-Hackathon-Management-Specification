import '../../../shared.dart';

class ProfileSecuritySection extends StatelessWidget {
  const ProfileSecuritySection({
    super.key,
    required this.email,
    required this.isLoading,
    required this.onRequestPasswordReset,
  });

  final String email;
  final bool isLoading;
  final Future<void> Function() onRequestPasswordReset;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              L10nService.strings.profileSecurityTitle,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              L10nService.strings.profileSecuritySubtitle,
              style: TextStyle(
                color: context.sealTheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: isLoading ? null : onRequestPasswordReset,
              icon: Icon(Icons.lock_reset_outlined),
              label: Text(context.l10n.sendPasswordResetTo(email)),
            ),
          ],
        ),
      ),
    );
  }
}
