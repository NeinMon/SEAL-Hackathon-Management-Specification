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
              color: SealPalette.primary.withValues(alpha: 0.30),
            ),
          ),
          child: const Icon(
            Icons.workspace_premium_outlined,
            color: SealPalette.primary,
            size: 38,
          ),
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        const Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        Text(
          AppStrings.loginHeroSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: seal.onSurfaceVariant, height: 1.35),
        ),
      ],
    );
  }
}
