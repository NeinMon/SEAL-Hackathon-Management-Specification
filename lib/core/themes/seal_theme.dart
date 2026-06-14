import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

ThemeData buildSealTheme() {
  const colors = ColorScheme.dark(
    primary: SealPalette.primary,
    onPrimary: SealPalette.onPrimary,
    primaryContainer: SealPalette.primaryContainer,
    onPrimaryContainer: SealPalette.onPrimaryContainer,
    secondary: SealPalette.secondary,
    onSecondary: SealPalette.onSecondary,
    surface: SealPalette.surface,
    onSurface: SealPalette.onSurface,
    error: SealPalette.error,
    errorContainer: SealPalette.errorContainer,
    onErrorContainer: SealPalette.onErrorContainer,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colors,
    scaffoldBackgroundColor: SealPalette.background,
    canvasColor: SealPalette.background,
    dividerColor: SealPalette.outlineVariant,
    appBarTheme: const AppBarTheme(
      toolbarHeight: AppSizes.appBarHeight,
      backgroundColor: SealPalette.surfaceContainerLow,
      foregroundColor: SealPalette.onSurface,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: SealPalette.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: SealPalette.surfaceContainerLow,
      indicatorColor: SealPalette.primary.withValues(alpha: 0.16),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? SealPalette.primary
              : SealPalette.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? SealPalette.primary
              : SealPalette.onSurfaceVariant,
        ),
      ),
    ),
    inputDecorationTheme:
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: const BorderSide(color: SealPalette.outlineVariant),
        ).let(
          (border) => InputDecorationTheme(
            filled: true,
            fillColor: SealPalette.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sectionGap,
              vertical: AppSizes.sectionGap,
            ),
            labelStyle: const TextStyle(color: SealPalette.onSurfaceVariant),
            hintStyle: const TextStyle(color: SealPalette.onSurfaceVariant),
            prefixIconColor: SealPalette.onSurfaceVariant,
            suffixIconColor: SealPalette.onSurfaceVariant,
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(
                color: SealPalette.primary,
                width: 2,
              ),
            ),
            errorBorder: border.copyWith(
              borderSide: const BorderSide(color: SealPalette.error),
            ),
          ),
        ),
    cardTheme: const CardThemeData(
      color: SealPalette.glassPanel,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusSmall)),
        side: BorderSide(color: SealPalette.outlineVariant),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: SealPalette.surfaceContainerHigh,
      selectedColor: SealPalette.primaryContainer,
      side: const BorderSide(color: SealPalette.outlineVariant),
      labelStyle: const TextStyle(
        color: SealPalette.onSurface,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: SealPalette.primaryContainer,
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
        foregroundColor: SealPalette.primary,
        side: const BorderSide(color: SealPalette.outlineVariant),
        minimumSize: const Size.fromHeight(AppSizes.buttonHeightCompact),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: SealPalette.surfaceContainerHighest,
      contentTextStyle: const TextStyle(color: SealPalette.onSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: SealPalette.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: SealPalette.onSurface,
      displayColor: SealPalette.onSurface,
    ),
  );
}

extension _InputBorderLet on OutlineInputBorder {
  T let<T>(T Function(OutlineInputBorder border) builder) => builder(this);
}
