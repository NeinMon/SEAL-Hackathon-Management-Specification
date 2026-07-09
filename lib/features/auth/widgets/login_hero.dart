import '../../../shared.dart';

class LoginHero extends StatelessWidget {
  const LoginHero({super.key});

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: seal.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: context.sealPrimary.withValues(alpha: 0.30),
            ),
          ),
          child: Icon(
            Icons.workspace_premium_outlined,
            color: context.sealPrimary,
            size: 38,
          ),
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        Text(
          L10nService.strings.appName,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        Text(
          L10nService.strings.loginHeroSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: seal.onSurfaceVariant, height: 1.35),
        ),
      ],
    );
  }
}
