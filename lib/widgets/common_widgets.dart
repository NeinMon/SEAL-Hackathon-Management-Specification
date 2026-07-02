import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/app_helpers.dart';
import '../core/themes/seal_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 17, color: SealPalette.primary),
      label: Text(text),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.icon,
    this.color = SealPalette.primary,
  });

  final String label;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
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
    final seal = context.sealTheme;
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
          : seal.surfaceContainerHighest,
      side: BorderSide(
        color: selected ? SealPalette.secondaryContainer : seal.outlineVariant,
      ),
      labelStyle: TextStyle(
        color: selected ? Colors.white : context.onSurfaceColor,
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
    final seal = context.sealTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: seal.onSurfaceVariant,
                fontSize: 12,
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
    final seal = context.sealTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: context.onSurfaceColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(value, style: TextStyle(color: seal.onSurfaceVariant)),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: seal.onSurfaceVariant),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: seal.onSurfaceVariant),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSizes.sectionGap),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    this.actionLabel = AppStrings.retryButton,
    this.onRetry,
  });

  final String message;
  final String actionLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final noInternet = FriendlyErrorMapper.looksLikeNetworkError(message);
    return EmptyState(
      icon: noInternet ? Icons.wifi_off_outlined : Icons.error_outline,
      message: noInternet ? AppStrings.networkOfflineMessage : message,
      actionLabel: onRetry == null ? null : actionLabel,
      onAction: onRetry,
    );
  }
}

class LoadingCardList extends StatelessWidget {
  const LoadingCardList({super.key, int? count, int? itemCount})
    : count = itemCount ?? count ?? 3;

  final int count;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Column(
      children: [
        for (var index = 0; index < count; index++) ...[
          Container(
            height: 112,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: seal.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: seal.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LoadingBar(widthFactor: index.isEven ? 0.52 : 0.72),
                const SizedBox(height: AppSizes.sectionGap),
                const _LoadingBar(widthFactor: 0.92),
                const SizedBox(height: 10),
                const _LoadingBar(widthFactor: 0.64),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class EventCardSkeleton extends StatelessWidget {
  const EventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 156, color: seal.surfaceContainerHigh),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _LoadingBar(widthFactor: 0.72),
                SizedBox(height: 14),
                _LoadingBar(widthFactor: 0.94),
                SizedBox(height: 10),
                _LoadingBar(widthFactor: 0.55),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardMetricSkeleton extends StatelessWidget {
  const DashboardMetricSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _MetricSkeletonCard()),
        SizedBox(width: 10),
        Expanded(child: _MetricSkeletonCard()),
      ],
    );
  }
}

class _MetricSkeletonCard extends StatelessWidget {
  const _MetricSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Container(
      height: 84,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: seal.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: seal.outlineVariant),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LoadingBar(widthFactor: 0.45),
          SizedBox(height: 16),
          _LoadingBar(widthFactor: 0.25),
        ],
      ),
    );
  }
}

class ChatSkeleton extends StatelessWidget {
  const ChatSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ChatSkeletonBubble(widthFactor: 0.72, alignment: Alignment.centerLeft),
        _ChatSkeletonBubble(
          widthFactor: 0.56,
          alignment: Alignment.centerRight,
        ),
        _ChatSkeletonBubble(widthFactor: 0.82, alignment: Alignment.centerLeft),
      ],
    );
  }
}

class _ChatSkeletonBubble extends StatelessWidget {
  const _ChatSkeletonBubble({
    required this.widthFactor,
    required this.alignment,
  });

  final double widthFactor;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 84,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: seal.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LoadingBar(widthFactor: 0.35),
              SizedBox(height: 14),
              _LoadingBar(widthFactor: 0.88),
            ],
          ),
        ),
      ),
    );
  }
}

class AdaptiveTwoPane extends StatelessWidget {
  const AdaptiveTwoPane({
    super.key,
    required this.leading,
    required this.trailing,
    this.breakpoint = 760,
    this.leadingFlex = 5,
    this.trailingFlex = 7,
  });

  final Widget leading;
  final Widget trailing;
  final double breakpoint;
  final int leadingFlex;
  final int trailingFlex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              leading,
              const SizedBox(height: AppSizes.paddingMedium),
              trailing,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: leadingFlex, child: leading),
            const SizedBox(width: 16),
            Expanded(flex: trailingFlex, child: trailing),
          ],
        );
      },
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          color: seal.surfaceContainerHighest.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class EventImageFallback extends StatelessWidget {
  const EventImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return Container(
      color: seal.surfaceContainerHigh,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 56,
          color: seal.onSurfaceVariant,
        ),
      ),
    );
  }
}

class EventNetworkImage extends StatelessWidget {
  const EventNetworkImage({super.key, required this.url, required this.fit});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (context, url) {
        return Container(
          color: seal.surfaceContainerHigh,
          child: const Center(
            child: SizedBox.square(
              dimension: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => const EventImageFallback(),
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
      padding: const EdgeInsets.all(AppSizes.paddingCompact),
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
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
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
                border: Border.all(color: seal.outlineVariant),
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
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: context.onSurfaceColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: seal.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSizes.paddingSmall + 2),
            trailing!,
          ],
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
    final seal = context.sealTheme;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: seal.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: seal.outlineVariant.withValues(alpha: 0.8)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: SealPalette.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: SealPalette.primary.withValues(alpha: 0.28),
              ),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: SealPalette.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSizes.paddingSmall + 2),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: seal.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
              ],
            ),
          ),
          trailing ??
              IconButton(
                tooltip: AppStrings.helpTooltip,
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text(AppStrings.helpDialogTitle),
                    content: const Text(AppStrings.helpDialogBody),
                    actions: [
                      FilledButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text(AppStrings.doneButton),
                      ),
                    ],
                  ),
                ),
                icon: const Icon(Icons.help_outline_rounded),
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
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      children: [
        const SealSectionHeader(
          title: AppStrings.accessDeniedTitle,
          subtitle: AppStrings.accessDeniedSubtitle,
          icon: Icons.lock_outline,
        ),
        StatusBanner(
          message: message ?? AppStrings.accessDeniedDefaultMessage,
          isError: true,
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(AppRoutes.events),
          icon: const Icon(Icons.event_outlined),
          label: const Text(AppStrings.backToEventsButton),
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
              const SealSectionHeader(
                title: AppStrings.loginRequiredTitle,
                subtitle: AppStrings.loginRequiredSubtitle,
                icon: Icons.lock_outline,
              ),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.login),
                icon: const Icon(Icons.login),
                label: const Text(AppStrings.goToLoginButton),
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
                        const Icon(
                          Icons.storage_outlined,
                          size: 56,
                          color: SealPalette.primary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          AppStrings.supabaseRequiredTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.supabaseRequiredBody,
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

class RefreshableListView extends StatelessWidget {
  const RefreshableListView({
    super.key,
    required this.onRefresh,
    required this.children,
    this.padding,
  });

  final Future<void> Function() onRefresh;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding ?? const EdgeInsets.all(AppSizes.paddingMedium),
        children: children,
      ),
    );
  }
}

class LoadMoreButton extends StatelessWidget {
  const LoadMoreButton({
    super.key,
    required this.onPressed,
    this.label = AppStrings.loadMoreButton,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.expand_more),
        label: Text(label),
      ),
    );
  }
}

class DemoOnboardingDialog extends StatelessWidget {
  const DemoOnboardingDialog({super.key, required this.onDone});

  final VoidCallback onDone;
  static const _title = 'Hướng dẫn demo nhanh';
  static const _startButton = 'Bắt đầu demo';
  static const _participantTitle = 'Thí sinh';
  static const _participantBody =
      'Sự kiện -> Đội -> Nộp bài. Dùng tài khoản demo nếu môi trường có seed dữ liệu.';
  static const _judgeTitle = 'Giám khảo';
  static const _judgeBody =
      'Tab Chấm điểm -> chọn bài -> nhập tiêu chí và nhận xét -> Gửi điểm.';
  static const _alertsTitle = 'Thông báo';
  static const _alertsBody =
      'Icon chuông góc phải. Bấm thông báo điểm để xem chi tiết.';

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
      title: const Text(_title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _OnboardingStep(
              step: '1',
              title: _participantTitle,
              body: _participantBody,
            ),
            SizedBox(height: 12),
            _OnboardingStep(step: '2', title: _judgeTitle, body: _judgeBody),
            SizedBox(height: 12),
            _OnboardingStep(step: '3', title: _alertsTitle, body: _alertsBody),
          ],
        ),
      ),
      actions: [
        FilledButton(onPressed: onDone, child: const Text(_startButton)),
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
                style: const TextStyle(color: SealPalette.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
