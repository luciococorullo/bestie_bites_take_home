import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Tema scuro dell'app, derivato dalla palette del brand.
abstract final class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.foreground,
      secondary: AppColors.accent,
      onSecondary: AppColors.foreground,
      surface: AppColors.surface,
      onSurface: AppColors.foreground,
      error: AppColors.accent,
      onError: AppColors.foreground,
      outline: AppColors.border,
    );

    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      textTheme: const TextTheme(
        headlineMedium: AppTextStyles.title,
        titleMedium: AppTextStyles.subtitle,
        bodyMedium: AppTextStyles.body,
        labelSmall: AppTextStyles.smallLabel,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppTextStyles.subtitle,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.accent),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
