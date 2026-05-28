part of '../main.dart';

class SealPalette {
  const SealPalette._();

  static const background = Color(0xFF0B1326);
  static const surface = Color(0xFF0B1326);
  static const surfaceContainerLowest = Color(0xFF060E20);
  static const surfaceContainerLow = Color(0xFF131B2E);
  static const surfaceContainer = Color(0xFF171F33);
  static const surfaceContainerHigh = Color(0xFF222A3D);
  static const surfaceContainerHighest = Color(0xFF2D3449);
  static const glassPanel = Color(0xB31E293B);
  static const onSurface = Color(0xFFDAE2FD);
  static const onSurfaceVariant = Color(0xFFC2C6D6);
  static const outline = Color(0xFF8C909F);
  static const outlineVariant = Color(0xFF424754);
  static const primary = Color(0xFFADC6FF);
  static const primaryContainer = Color(0xFF4D8EFF);
  static const indigo = Color(0xFF6366F1);
  static const onPrimary = Color(0xFF002E6A);
  static const onPrimaryContainer = Color(0xFF00285D);
  static const secondary = Color(0xFF4EDEA3);
  static const secondaryContainer = Color(0xFF00A572);
  static const onSecondary = Color(0xFF003824);
  static const tertiary = Color(0xFFFFB786);
  static const error = Color(0xFFFFB4AB);
  static const errorContainer = Color(0xFF93000A);
  static const onErrorContainer = Color(0xFFFFDAD6);
}

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: SealPalette.primary),
      label: Text(text),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}

class CommandChip extends StatelessWidget {
  const CommandChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: icon == null
          ? null
          : Icon(
              icon,
              size: 18,
              color: selected ? SealPalette.onSecondary : SealPalette.primary,
            ),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: selected
          ? SealPalette.secondaryContainer
          : SealPalette.surfaceContainerHighest,
      side: BorderSide(
        color: selected
            ? SealPalette.secondaryContainer
            : SealPalette.outlineVariant,
      ),
      labelStyle: TextStyle(
        color: selected ? SealPalette.onSecondary : SealPalette.onSurface,
        fontWeight: FontWeight.w800,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.accent = SealPalette.primary,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: SealPalette.onSurfaceVariant,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: accent,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  const DetailTile({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: SealPalette.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(color: SealPalette.onSurfaceVariant),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: SealPalette.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class EventImageFallback extends StatelessWidget {
  const EventImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SealPalette.surfaceContainerHigh,
      child: const Center(
        child: Icon(
          Icons.event_available_outlined,
          size: 56,
          color: SealPalette.primary,
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  const StatusBanner({super.key, required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError
            ? colors.errorContainer.withValues(alpha: 0.22)
            : SealPalette.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError
              ? SealPalette.error.withValues(alpha: 0.55)
              : SealPalette.secondary.withValues(alpha: 0.45),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isError ? colors.onErrorContainer : SealPalette.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SealSectionHeader extends StatelessWidget {
  const SealSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SealPalette.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: SealPalette.outlineVariant),
              ),
              child: Icon(icon, color: SealPalette.primary),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: SealPalette.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: SealPalette.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HackCommandTopBar extends StatelessWidget {
  const HackCommandTopBar({super.key, this.trailing, this.subtitle});

  final Widget? trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: SealPalette.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: SealPalette.outlineVariant)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: SealPalette.primaryContainer.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: SealPalette.primary.withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.terminal,
              color: SealPalette.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SEAL Hackathon',
                  style: TextStyle(
                    color: SealPalette.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: SealPalette.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
              ],
            ),
          ),
          trailing ??
              IconButton(
                tooltip: 'Support',
                onPressed: () {},
                icon: const Icon(Icons.help_outline),
              ),
        ],
      ),
    );
  }
}

class RoleGate extends StatelessWidget {
  const RoleGate({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.message,
  });

  final Set<String> allowedRoles;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().user?.role;
    if (role != null && allowedRoles.contains(role)) return child;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SealSectionHeader(
          title: 'Access Restricted',
          subtitle: 'This feature is not available for your current role.',
          icon: Icons.lock_outline,
        ),
        StatusBanner(
          message: message ?? 'Please login with a permitted role.',
          isError: true,
        ),
        OutlinedButton.icon(
          onPressed: () => context.go('/events'),
          icon: const Icon(Icons.event_outlined),
          label: const Text('Back to Events'),
        ),
      ],
    );
  }
}

class SessionRequired extends StatelessWidget {
  const SessionRequired({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SealPalette.background,
              SealPalette.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const HackCommandTopBar(),
              const SizedBox(height: 24),
              const SealSectionHeader(
                title: 'Please Sign In',
                subtitle: 'Sign in to continue using SEAL Hackathon.',
                icon: Icons.lock_outline,
              ),
              FilledButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.login),
                label: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupabaseRequiredScreen extends StatelessWidget {
  const SupabaseRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SealPalette.background,
              SealPalette.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Icon(
                          Icons.storage_outlined,
                          size: 56,
                          color: SealPalette.primary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Supabase connection required',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start the app with SUPABASE_URL and SUPABASE_ANON_KEY. The app no longer runs with mock data.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: SealPalette.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
