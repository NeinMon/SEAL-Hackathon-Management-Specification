import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  static const double paddingSmall = 8;
  static const double paddingCompact = 12;
  static const double paddingMedium = 16;
  static const double paddingLarge = 24;

  static const double radiusSmall = 8;
  static const double radiusMedium = 12;

  static const double buttonHeight = 48;
  static const double buttonHeightCompact = 40;

  static const double appBarHeight = 56;
  static const double shellHeaderHeight = 48;

  static double topChromeHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600
        ? shellHeaderHeight
        : appBarHeight;
  }

  static bool compactChrome(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  static const double shellNavHeight = 58;
  static const double iconSmall = 18;
  static const double sectionGap = 14;
}
