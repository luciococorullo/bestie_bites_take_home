import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Campo di ricerca a **pill** (raggio pieno) dello stato idle/suggestions.
///
/// Icona search in tinta accent, fill surface, bordo #252525 (accent al focus),
/// hint muted "Cerca una città…". Override del raggio del tema (più squadrato)
/// per ottenere la pill dei mockup.
class SearchBarField extends StatelessWidget {
  const SearchBarField({
    super.key,
    required this.onChanged,
    this.autofocus = false,
  });

  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final pillBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return TextField(
      onChanged: onChanged,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.body,
      cursorColor: AppColors.accent,
      decoration: InputDecoration(
        hintText: 'Cerca una città…',
        hintStyle: AppTextStyles.subtitle,
        filled: true,
        fillColor: AppColors.surface,
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.accent),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: pillBorder,
        enabledBorder: pillBorder,
        focusedBorder: pillBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.accent),
        ),
      ),
    );
  }
}
