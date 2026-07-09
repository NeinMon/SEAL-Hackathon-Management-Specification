import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/app_helpers.dart';
import '../../core/l10n/l10n_service.dart';
import '../../core/themes/seal_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import 'basic_widgets.dart';

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
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        SealSectionHeader(
          title: L10nService.strings.accessDeniedTitle,
          subtitle: L10nService.strings.accessDeniedSubtitle,
          icon: Icons.lock_outline,
        ),
        StatusBanner(
          message: message ?? L10nService.strings.accessDeniedDefaultMessage,
          isError: true,
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(AppRoutes.events),
          icon: Icon(Icons.event_outlined),
          label: Text(context.l10n.backToEventsButton),
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
        decoration: BoxDecoration(gradient: context.sealBackgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            children: [
              const HackCommandTopBar(),
              const SizedBox(height: AppSizes.paddingLarge),
              SealSectionHeader(
                title: L10nService.strings.loginRequiredTitle,
                subtitle: L10nService.strings.loginRequiredSubtitle,
                icon: Icons.lock_outline,
              ),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.login),
                icon: Icon(Icons.login),
                label: Text(context.l10n.goToLoginButton),
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
        decoration: BoxDecoration(gradient: context.sealBackgroundGradient),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingLarge),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.storage_outlined,
                          size: 56,
                          color: context.sealPrimary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          L10nService.strings.supabaseRequiredTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          L10nService.strings.supabaseRequiredBody,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.sealTheme.onSurfaceVariant,
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

class RoleOnboardingDialog extends StatelessWidget {
  const RoleOnboardingDialog({super.key, required this.role, required this.onDone});

  final String role;
  final VoidCallback onDone;

  static Future<void> show(BuildContext context, String role) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => RoleOnboardingDialog(
        role: role,
        onDone: () {
          Navigator.of(dialogContext).pop();
          context.read<OnboardingProvider>().complete();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final copy = _copyFor(role);
    return AlertDialog(
      title: Text(copy.title),
      content: Text(copy.body, style: const TextStyle(height: 1.4)),
      actions: [
        TextButton(onPressed: onDone, child: Text(context.l10n.roleOnboardingSkip)),
        FilledButton(
          onPressed: onDone,
          child: Text(context.l10n.roleOnboardingStart),
        ),
      ],
    );
  }

  ({String title, String body}) _copyFor(String role) {
    return switch (role) {
      AppRoles.judge => (
        title: L10nService.strings.roleOnboardingJudgeTitle,
        body: L10nService.strings.roleOnboardingJudgeBody,
      ),
      AppRoles.organizer => (
        title: L10nService.strings.roleOnboardingOrganizerTitle,
        body: L10nService.strings.roleOnboardingOrganizerBody,
      ),
      AppRoles.mentor => (
        title: L10nService.strings.roleOnboardingMentorTitle,
        body: L10nService.strings.roleOnboardingMentorBody,
      ),
      _ => (
        title: L10nService.strings.roleOnboardingParticipantTitle,
        body: L10nService.strings.roleOnboardingParticipantBody,
      ),
    };
  }
}

class DemoOnboardingDialog extends StatelessWidget {
  const DemoOnboardingDialog({super.key, required this.onDone});

  final VoidCallback onDone;

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => DemoOnboardingDialog(
        onDone: () {
          Navigator.of(dialogContext).pop();
          context.read<OnboardingProvider>().complete();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.demoOnboardingTitle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OnboardingStep(
              step: '1',
              title: L10nService.strings.demoOnboardingParticipantTitle,
              body: L10nService.strings.demoOnboardingParticipantBody,
            ),
            SizedBox(height: 12),
            _OnboardingStep(
              step: '2',
              title: L10nService.strings.demoOnboardingJudgeTitle,
              body: L10nService.strings.demoOnboardingJudgeBody,
            ),
            SizedBox(height: 12),
            _OnboardingStep(
              step: '3',
              title: L10nService.strings.demoOnboardingAlertsTitle,
              body: L10nService.strings.demoOnboardingAlertsBody,
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: onDone,
          child: Text(context.l10n.demoOnboardingStartButton),
        ),
      ],
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({
    required this.step,
    required this.title,
    required this.body,
  });

  final String step;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          child: Text(
            step,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(
                body,
                style: TextStyle(color: context.sealTheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
