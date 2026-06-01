import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
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
      itemCount: cities.length,
      separatorBuilder: (_, _) => const Divider(
        height: 1,
        color: AppColors.border,
      ),
      itemBuilder: (context, index) {
        final city = cities[index];
        return SuggestionTile(
          city: city,
          onTap: () => onCitySelected(city),
        );
      },
    );
  }
}
