import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/cuisine.dart';
import 'cuisine_card.dart';

/// Griglia a 3 colonne delle cucine disponibili (stato cuisines-shown).
class CuisinesGridView extends StatelessWidget {
  const CuisinesGridView({super.key, required this.cuisines});

  final List<Cuisine> cuisines;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 0.8,
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [for (final cuisine in cuisines) CuisineCard(cuisine: cuisine)],
    );
  }
}
