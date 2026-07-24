import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/themes/seal_theme.dart';

class CompactShellHeader extends StatelessWidget {
  const CompactShellHeader({
    super.key,
    this.onBack,
    required this.title,
    this.subtitle,
    this.backTooltip,
    this.trailing = const [],
    this.showSubtitleOnCompact = false,
    this.showBack = true,
  });

  final VoidCallback? onBack;
  final String title;
  final String? subtitle;
  final String? backTooltip;
  final List<Widget> trailing;
  final bool showSubtitleOnCompact;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final showSubtitle =
        subtitle != null && (!compact || showSubtitleOnCompact);

    return Material(
      color: context.sealTheme.surfaceContainerLow,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: showSubtitle
              ? AppSizes.shellHeaderHeight + 14
              : AppSizes.shellHeaderHeight,
          child: Row(
            children: [
              if (showBack && onBack != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                  tooltip: backTooltip,
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                )
              else if (!showBack)
                const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: compact ? 15 : 16,
                        color: context.onSurfaceColor,
                      ),
                    ),
                    if (showSubtitle)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.sealTheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              ...trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class CompactShellNavBar extends StatelessWidget {
  const CompactShellNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: NavigationBar(
        height: AppSizes.shellNavHeight,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelBehavior: destinations.length > 3
            ? NavigationDestinationLabelBehavior.onlyShowSelected
            : NavigationDestinationLabelBehavior.alwaysShow,
        destinations: destinations,
      ),
    );
  }
}

class EmbeddedScreenHeader extends StatelessWidget {
  const EmbeddedScreenHeader({
    super.key,
    required this.title,
    this.onBack,
  });

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 36, height: 36),
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: context.onSurfaceColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
