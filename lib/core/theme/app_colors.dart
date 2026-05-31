import 'package:flutter/material.dart';

/// Palette del brand (dark theme) definita nella spec di "Cucine in città".
abstract final class AppColors {
  const AppColors._();

  static const Color background = Color(0xFF0A0A0A);
  static const Color foreground = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFFF5C5C);
  static const Color surface = Color(0xFF0E0E0E);
  static const Color border = Color(0xFF252525);
  static const Color lightGray = Color(0xFF3E4142);
  static const Color mutedText = Color(0xFFA7A7A7);
}
