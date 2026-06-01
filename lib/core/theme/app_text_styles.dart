import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Gerarchia tipografica dell'app. Usa il font di sistema (Roboto/SF):
/// nessun font bundle per mantenere leggero il build web.
abstract final class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.foreground,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedText,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.foreground,
  );

  static const TextStyle smallLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedText,
  );
}
