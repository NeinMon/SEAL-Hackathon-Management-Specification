import '../../../shared.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.awaitingVerification,
    required this.registerMode,
    required this.isLoading,
    required this.onPressed,
  });

  final bool awaitingVerification;
  final bool registerMode;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = awaitingVerification
        ? AppStrings.confirmOtpButton
        : registerMode
        ? AppStrings.registerButton
        : AppStrings.loginButton;
    return FilledButton.icon(
      key: const Key('auth_submit_button'),
      onPressed: onPressed,
      icon: isLoading
          ? const SizedBox.square(
              dimension: AppSizes.iconSmall,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(awaitingVerification ? Icons.verified_outlined : Icons.login),
      label: Text(label),
    );
  }
}
