import '../../../shared.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({
    super.key,
    required this.awaitingVerification,
    required this.registerMode,
  });

  final bool awaitingVerification;
  final bool registerMode;

  @override
  Widget build(BuildContext context) {
    final title = awaitingVerification
        ? AppStrings.verifyEmailTitle
        : registerMode
        ? AppStrings.registerTitle
        : AppStrings.loginTitle;
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
        color: SealPalette.onSurfaceVariant,
      ),
    );
  }
}
