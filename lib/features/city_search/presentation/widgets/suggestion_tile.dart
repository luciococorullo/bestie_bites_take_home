import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/city.dart';

/// Tile di un suggerimento di autocomplete.
///
/// Card piena (surface + bordo, angoli morbidi) come nel mockup: main_text in
/// grassetto bianco (es. "Milano"), secondary_text muted sotto (es. "Lombardia,
/// Italia") e chevron muted a destra. Tap → [onTap].
class SuggestionTile extends StatelessWidget {
  const SuggestionTile({super.key, required this.city, required this.onTap});

  final City city;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.mainText,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (city.secondaryText.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          city.secondaryText,
                          style: AppTextStyles.smallLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.mutedText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
