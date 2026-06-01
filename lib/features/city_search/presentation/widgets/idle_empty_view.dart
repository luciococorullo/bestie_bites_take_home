import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Stato **idle**: silhouette muted dell'Italia al centro + testo helper.
///
/// La sagoma è un asset SVG (`assets/images/italy.svg`) tinta in grigio chiaro,
/// per riprodurre il mockup senza dipendere dalla risoluzione di un PNG.
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
            SvgPicture.asset(
              'assets/images/italy.svg',
              height: 180,
              colorFilter: const ColorFilter.mode(
                AppColors.lightGray,
                BlendMode.srcIn,
              ),
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
