import 'package:flutter/material.dart';
import 'package:rockers_admin/app/core/theme/theme.dart';

class AppTheme {
  AppTheme._();
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.frenchWine,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.eerieBlack,
        onPrimaryContainer: AppColors.white,
        secondary: AppColors.oldMauve,
        onSecondary: AppColors.white,
        tertiary: AppColors.frenchWine,
        onTertiary: AppColors.white,
        background: AppColors.smokyBlack,
        surface: AppColors.eerieBlack,
        surfaceTint: AppColors.smokyBlack,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.eerieBlack,
      ),
      fontFamily: 'Roboto',
    );
  }
}
