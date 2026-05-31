import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_theme.dart';

/// Root dell'app: MaterialApp con il tema scuro del brand.
///
/// Per ora mostra un placeholder; la `HomeScreen` con la navigazione-as-stato
/// (ricerca città → cucine) verrà introdotta in una fase successiva.
class CucineApp extends StatelessWidget {
  const CucineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cucine in città',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const _HomePlaceholder(),
    );
  }
}

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cucine in città', style: AppTextStyles.title),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Cerca una città per scoprire le cucine disponibili.',
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
