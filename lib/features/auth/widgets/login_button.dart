import '../../../shared.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.awaitingVerification,
    required this.registerMode,
    required this.passwordRecoveryMode,
    required this.isLoading,
    required this.onPressed,
  });

  final bool awaitingVerification;
  final bool registerMode;
  final bool passwordRecoveryMode;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = passwordRecoveryMode
        ? 'Cập nhật mật khẩu'
        : awaitingVerification
        ? L10nService.strings.confirmOtpButton
        : registerMode
        ? L10nService.strings.registerButton
        : L10nService.strings.loginButton;
    return FilledButton.icon(
      key: const Key('auth_submit_button'),
      onPressed: onPressed,
      icon: isLoading
          ? const SizedBox.square(
              dimension: AppSizes.iconSmall,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              passwordRecoveryMode
                  ? Icons.lock_reset_outlined
                  : awaitingVerification
                  ? Icons.verified_outlined
                  : Icons.login,
            ),
      label: Text(label),
    );
  }
}
