import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'seal_theme_extension.dart';

export 'seal_theme_extension.dart';
import '../constants/app_sizes.dart';

ThemeData buildSealTheme({Brightness brightness = Brightness.dark}) {
  final isDark = brightness == Brightness.dark;
  final colors = isDark
      ? const ColorScheme.dark(
          primary: SealPalette.primary,
          onPrimary: SealPalette.onPrimary,
          primaryContainer: SealPalette.primaryContainer,
          onPrimaryContainer: SealPalette.onPrimaryContainer,
          secondary: SealPalette.secondary,
          onSecondary: SealPalette.onSecondary,
          secondaryContainer: SealPalette.secondaryContainer,
          tertiary: SealPalette.tertiary,
          onTertiary: SealPalette.onSecondary,
          surface: SealPalette.surface,
          onSurface: SealPalette.onSurface,
          error: SealPalette.error,
          errorContainer: SealPalette.errorContainer,
          onErrorContainer: SealPalette.onErrorContainer,
        )
      : ColorScheme.light(
          primary: const Color(0xFF1570EF),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFF2E90FA),
          onPrimaryContainer: Colors.white,
          secondary: const Color(0xFF12B76A),
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFF027A48),
          tertiary: const Color(0xFFF79009),
          onTertiary: const Color(0xFF1D2939),
          surface: const Color(0xFFF7F9FC),
          onSurface: const Color(0xFF101828),
          onSurfaceVariant: const Color(0xFF475467),
          outlineVariant: const Color(0xFFD0D5DD),
          error: const Color(0xFFF04438),
          errorContainer: const Color(0xFFFFE4E6),
          onErrorContainer: const Color(0xFF7F1D1D),
        );
  final sealExtension = isDark
      ? SealThemeExtension.dark
      : SealThemeExtension.light;
  final background = sealExtension.background;
  final surfaceLow = sealExtension.surfaceContainerLow;
  final surfaceContainerLow = sealExtension.surfaceContainerLow;
  final glassPanel = sealExtension.glassPanel;
  final onSurfaceVariant = sealExtension.onSurfaceVariant;
  final outlineVariant = sealExtension.outlineVariant;
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colors,
    scaffoldBackgroundColor: background,
    canvasColor: background,
    dividerColor: outlineVariant,
    appBarTheme: AppBarTheme(
      toolbarHeight: AppSizes.appBarHeight,
      backgroundColor: surfaceLow,
      foregroundColor: colors.onSurface,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: colors.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceLow,
      indicatorColor: colors.primary.withValues(alpha: 0.16),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? colors.primary
              : onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? colors.primary
              : onSurfaceVariant,
        ),
      ),
    ),
    inputDecorationTheme:
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: outlineVariant),
        ).let(
          (border) => InputDecorationTheme(
            filled: true,
            fillColor: surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sectionGap,
              vertical: AppSizes.sectionGap,
            ),
            labelStyle: TextStyle(color: onSurfaceVariant),
            hintStyle: TextStyle(color: onSurfaceVariant),
            prefixIconColor: onSurfaceVariant,
            suffixIconColor: onSurfaceVariant,
            border: border,
            enabledBorder: border.copyWith(
              borderSide: BorderSide(color: outlineVariant),
            ),
            focusedBorder: border.copyWith(
              borderSide: BorderSide(
                color: colors.primary,
                width: 2,
              ),
            ),
            errorBorder: border.copyWith(
              borderSide: BorderSide(color: colors.error),
            ),
          ),
        ),
    cardTheme: CardThemeData(
      color: glassPanel,
      surfaceTintColor: Colors.transparent,
      elevation: isDark ? 0 : 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSizes.radiusSmall),
        ),
        side: BorderSide(color: outlineVariant),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: isDark
          ? SealPalette.surfaceContainerHigh
          : const Color(0xFFF2F4F7),
      selectedColor: colors.primaryContainer,
      side: BorderSide(color: outlineVariant),
      labelStyle: TextStyle(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.primaryContainer,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(color: outlineVariant),
        minimumSize: const Size.fromHeight(AppSizes.buttonHeightCompact),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark
          ? SealPalette.surfaceContainerHighest
          : const Color(0xFF1D2939),
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    ),
    extensions: [sealExtension],
  );
}

extension _InputBorderLet on OutlineInputBorder {
  T let<T>(T Function(OutlineInputBorder border) builder) => builder(this);
}
