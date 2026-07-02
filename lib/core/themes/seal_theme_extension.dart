import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

@immutable
class SealThemeExtension extends ThemeExtension<SealThemeExtension> {
  const SealThemeExtension({
    required this.background,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.glassPanel,
    required this.onSurfaceVariant,
    required this.outlineVariant,
  });

  final Color background;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color glassPanel;
  final Color onSurfaceVariant;
  final Color outlineVariant;

  static const dark = SealThemeExtension(
    background: AppColors.background,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    glassPanel: AppColors.glassPanel,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outlineVariant: AppColors.outlineVariant,
  );

  static const light = SealThemeExtension(
    background: Color(0xFFEEF2F8),
    surfaceContainerLowest: Color(0xFFE8EDF5),
    surfaceContainerLow: Color(0xFFFFFFFF),
    surfaceContainerHigh: Color(0xFFF2F4F7),
    surfaceContainerHighest: Color(0xFFE4E7EC),
    glassPanel: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFF475467),
    outlineVariant: Color(0xFFD0D5DD),
  );

  @override
  SealThemeExtension copyWith({
    Color? background,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? glassPanel,
    Color? onSurfaceVariant,
    Color? outlineVariant,
  }) {
    return SealThemeExtension(
      background: background ?? this.background,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      glassPanel: glassPanel ?? this.glassPanel,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outlineVariant: outlineVariant ?? this.outlineVariant,
    );
  }

  @override
  SealThemeExtension lerp(
    covariant ThemeExtension<SealThemeExtension>? other,
    double t,
  ) {
    if (other is! SealThemeExtension) return this;
    return SealThemeExtension(
      background: Color.lerp(background, other.background, t)!,
      surfaceContainerLowest: Color.lerp(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
        t,
      )!,
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      glassPanel: Color.lerp(glassPanel, other.glassPanel, t)!,
      onSurfaceVariant: Color.lerp(
        onSurfaceVariant,
        other.onSurfaceVariant,
        t,
      )!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
    );
  }
}

extension SealThemeContext on BuildContext {
  SealThemeExtension get sealTheme =>
      Theme.of(this).extension<SealThemeExtension>() ?? SealThemeExtension.dark;

  Color get onSurfaceColor => Theme.of(this).colorScheme.onSurface;

  LinearGradient get sealBackgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [sealTheme.background, sealTheme.surfaceContainerLowest],
  );
}
