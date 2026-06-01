import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../domain/entities/city.dart';
import '../controllers/city_search_controller.dart';
import '../state/search_state.dart';
import 'idle_empty_view.dart';
import 'search_bar_field.dart';
import 'suggestions_list_view.dart';

/// Corpo della modalità ricerca: titolo + campo + contenuto guidato dallo stato.
///
/// Fa uno `switch` esaustivo su [SearchState] (idle/searching/suggestions/
/// noResults/error), così ogni stato della spec ha una resa dedicata.
class SearchBody extends ConsumerWidget {
  const SearchBody({super.key, required this.onCitySelected});

  /// Invocata al tap su un suggerimento (in step 10 → naviga alle cucine).
  final ValueChanged<City> onCitySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(citySearchControllerProvider.notifier);
    final state = ref.watch(citySearchControllerProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Text(
              'Cucine in città',
              textAlign: TextAlign.center,
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.xl),
            SearchBarField(onChanged: controller.onQueryChanged),
            const SizedBox(height: AppSpacing.lg),
            Expanded(child: _buildContent(state, controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(SearchState state, CitySearchController controller) {
    return switch (state) {
      SearchIdle() => const IdleEmptyView(),
      SearchSearching() => const AppLoadingIndicator(),
      SearchSuggestions(:final cities) => SuggestionsListView(
        cities: cities,
        onCitySelected: onCitySelected,
      ),
      SearchNoResults() => const _NoResultsView(),
      SearchError(:final failure) => ErrorRetryView(
        message: failure.message,
        onRetry: controller.retry,
      ),
    };
  }
}

/// Stato **no-results**: nessuna città per il termine cercato.
class _NoResultsView extends StatelessWidget {
  const _NoResultsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.mutedText,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Nessuna città trovata.\nProva con un altro nome.',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
