import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/app_helpers.dart';
import '../../core/l10n/l10n_service.dart';
import '../../core/themes/seal_theme.dart';

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
          child: Center(
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
    this.label,
  });

  final VoidCallback onPressed;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.expand_more),
        label: Text(label ?? context.l10n.loadMoreButton),
      ),
    );
  }
}
