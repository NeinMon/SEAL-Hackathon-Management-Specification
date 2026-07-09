import 'package:flutter/material.dart';

import '../../core/app_helpers.dart';
import '../../core/l10n/l10n_service.dart';
import '../../core/themes/seal_theme.dart';

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
    this.actionLabel,
    this.onRetry,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final noInternet = FriendlyErrorMapper.looksLikeNetworkError(message);
    final resolvedActionLabel =
        actionLabel ?? context.l10n.retryButton;
    return EmptyState(
      icon: noInternet ? Icons.wifi_off_outlined : Icons.error_outline,
      message: noInternet ? context.l10n.networkOfflineMessage : message,
      actionLabel: onRetry == null ? null : resolvedActionLabel,
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
                _LoadingBar(widthFactor: 0.92),
                const SizedBox(height: 10),
                _LoadingBar(widthFactor: 0.64),
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
              children: [
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
      children: [
        Expanded(child: _MetricSkeletonCard()),
        SizedBox(width: 10),
        Expanded(child: _MetricSkeletonCard()),
      ],
    );
  }
}

class ChatSkeleton extends StatelessWidget {
  const ChatSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      child: Column(
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
          child: Column(
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

class _LoadingBar extends StatefulWidget {
  const _LoadingBar({required this.widthFactor});

  final double widthFactor;

  @override
  State<_LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<_LoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulse = 0.35 + (_controller.value * 0.35);
        return FractionallySizedBox(
          widthFactor: widget.widthFactor,
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: Color.lerp(
                seal.surfaceContainerHigh,
                seal.surfaceContainerHighest,
                pulse,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      },
    );
  }
}
