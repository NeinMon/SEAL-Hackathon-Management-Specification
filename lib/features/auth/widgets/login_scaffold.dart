import '../../../shared.dart';

class LoginScaffold extends StatelessWidget {
  const LoginScaffold({
    super.key,
    required this.child,
    this.includeSurfaceTone = true,
  });

  final Widget child;
  final bool includeSurfaceTone;

  BoxDecoration _background(BuildContext context) {
    final colors = [
      context.sealPrimary.withValues(alpha: 0.16),
      context.sealTheme.background,
      if (includeSurfaceTone) context.sealTheme.surfaceContainerLowest,
    ];
    return BoxDecoration(
      color: context.sealTheme.background,
      gradient: RadialGradient(
        center: const Alignment(-0.65, -0.85),
        radius: 1.1,
        colors: colors,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: DecoratedBox(
        decoration: _background(context),
        child: SafeArea(child: child),
      ),
    );
  }
}

class LoginSessionBootstrapView extends StatelessWidget {
  const LoginSessionBootstrapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: context.sealTheme.background,
          gradient: RadialGradient(
            center: const Alignment(-0.65, -0.85),
            radius: 1.1,
            colors: [
              context.sealPrimary.withValues(alpha: 0.16),
              context.sealTheme.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HackCommandTopBar(),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(context.l10n.sessionBootstrapMessage),
            ],
          ),
        ),
      ),
    );
  }
}
