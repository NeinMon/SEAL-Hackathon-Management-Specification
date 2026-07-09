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
        ? L10nService.strings.verifyEmailTitle
        : registerMode
        ? L10nService.strings.registerTitle
        : L10nService.strings.loginTitle;
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
        color: context.sealTheme.onSurfaceVariant,
      ),
    );
  }
}
