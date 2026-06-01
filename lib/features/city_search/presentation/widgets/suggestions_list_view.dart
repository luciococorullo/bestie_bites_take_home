import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/city.dart';
import 'suggestion_tile.dart';

/// Lista verticale dei suggerimenti di autocomplete.
class SuggestionsListView extends StatelessWidget {
  const SuggestionsListView({
    super.key,
    required this.cities,
    required this.onCitySelected,
  });

  final List<City> cities;
  final ValueChanged<City> onCitySelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      itemCount: cities.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final city = cities[index];
        return SuggestionTile(city: city, onTap: () => onCitySelected(city));
      },
    );
  }
}
