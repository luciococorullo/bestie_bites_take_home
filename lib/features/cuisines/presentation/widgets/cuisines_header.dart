import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../city_search/domain/entities/city.dart';

/// Intestazione della vista cucine.
///
/// Back arrow accent (→ [onBack]), titolo grande con il nome città
/// ([City.mainText]), sottotitolo muted ([City.secondaryText]) e una label
/// piccola con il conteggio. Il [count] è opzionale: arriva solo quando le
/// cucine sono state caricate, quindi durante loading/errore non viene mostrato.
class CuisinesHeader extends StatelessWidget {
  const CuisinesHeader({
    super.key,
    required this.city,
    required this.onBack,
    this.count,
  });

  final City city;
  final VoidCallback onBack;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            tooltip: 'Indietro',
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.accent),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          city.mainText,
          style: AppTextStyles.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (city.secondaryText.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            city.secondaryText,
            style: AppTextStyles.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (count != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(_countLabel(count!), style: AppTextStyles.smallLabel),
        ],
      ],
    );
  }

  /// "{n} cucine disponibili", con il singolare gestito per evitare "1 cucine".
  String _countLabel(int count) =>
      count == 1 ? '1 cucina disponibile' : '$count cucine disponibili';
}
