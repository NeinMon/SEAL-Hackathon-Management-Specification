import 'package:flutter/material.dart';

import '../../core/app_helpers.dart';
import '../../core/l10n/l10n_service.dart';
import '../../core/themes/seal_theme.dart';

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 17, color: Theme.of(context).colorScheme.primary),
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
    this.color,
  });

  final String label;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? context.sealPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: resolved.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: resolved.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: resolved),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: resolved,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
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
              color: selected ? context.sealOnSecondary : context.sealPrimary,
            ),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: selected
          ? context.sealSecondaryContainer
          : seal.surfaceContainerHighest,
      side: BorderSide(
        color: selected ? context.sealSecondaryContainer : seal.outlineVariant,
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
    this.accent,
  });

  final String label;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    final resolvedAccent = accent ?? context.sealPrimary;
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
                color: resolvedAccent,
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
            : context.sealSecondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError
              ? context.sealError.withValues(alpha: 0.55)
              : context.sealSecondary.withValues(alpha: 0.45),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isError ? colors.onErrorContainer : context.sealSecondary,
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
    final accent = context.sealPrimary;
    final compact = MediaQuery.sizeOf(context).width < 400;
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 10 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: compact ? 34 : 40,
              height: compact ? 34 : 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: seal.outlineVariant),
              ),
              child: Icon(icon, color: accent),
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
                    fontSize: compact ? 20 : 23,
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
  const HackCommandTopBar({
    super.key,
    this.trailing,
    this.subtitle,
    this.compact = false,
  });

  final Widget? trailing;
  final String? subtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final seal = context.sealTheme;
    final accent = context.sealPrimary;
    final barHeight =
        compact ? AppSizes.shellHeaderHeight : AppSizes.appBarHeight;
    final logoSize = compact ? 28.0 : 34.0;
    final titleSize = compact ? 15.0 : 18.0;
    return Container(
      height: barHeight,
      padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16),
      decoration: BoxDecoration(
        color: seal.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: seal.outlineVariant.withValues(alpha: 0.8)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(compact ? 6 : 8),
              border: Border.all(
                color: accent.withValues(alpha: 0.28),
              ),
            ),
            child: Icon(
              Icons.shield_outlined,
              color: accent,
              size: compact ? 16 : 20,
            ),
          ),
          SizedBox(width: compact ? 8 : AppSizes.paddingSmall + 2),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.strings.appName,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: titleSize,
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
                tooltip: context.l10n.helpTooltip,
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(context.l10n.helpDialogTitle),
                    content: Text(context.l10n.helpDialogBody),
                    actions: [
                      FilledButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(context.l10n.doneButton),
                      ),
                    ],
                  ),
                ),
                icon: Icon(Icons.help_outline_rounded),
              ),
        ],
      ),
    );
  }
}
