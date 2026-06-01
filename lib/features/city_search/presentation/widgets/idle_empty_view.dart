import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Stato **idle**: illustrazione muted al centro + testo helper.
///
/// Il mockup mostra una silhouette dell'Italia. Per non introdurre una
/// dipendenza (SVG) né un asset binario, usiamo qui il fallback previsto dal
/// piano — una grande icona muted coerente col palette. Per la silhouette vera
/// basta sostituire l'[Icon] con `Image.asset('assets/images/italy_silhouette.png')`
/// dichiarando l'asset in `pubspec.yaml`.
class IdleEmptyView extends StatelessWidget {
  const IdleEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.public_rounded,
              size: 120,
              color: AppColors.lightGray,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'inizia a cercare una città\nper scoprire le cucine disponibili',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
