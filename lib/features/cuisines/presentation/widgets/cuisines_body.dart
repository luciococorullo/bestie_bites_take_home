import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../../city_search/domain/entities/city.dart';
import '../controllers/cuisines_controller.dart';
import 'cuisines_grid_view.dart';
import 'cuisines_header.dart';

/// Vista cucine di una città: header (con back + conteggio) + corpo guidato
/// dall'`AsyncValue` del [cuisinesProvider].
///
/// Lo `switch` esaustivo copre i 3 stati cucine della spec:
/// - loading → [AppLoadingIndicator];
/// - data **non vuota** → [CuisinesGridView] (cuisines-shown);
/// - data **vuota** → [_EmptyCuisinesView] (empty-cuisines, branch esplicito);
/// - error → [ErrorRetryView] con retry = `ref.invalidate(...)`.
class CuisinesBody extends ConsumerWidget {
  const CuisinesBody({super.key, required this.city, required this.onBack});

  /// Città selezionata: ne usiamo lat/lng per la query e main/secondary text
  /// per l'header.
  final City city;

  /// Torna alla modalità ricerca (back arrow + back di sistema).
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = cuisinesProvider(lat: city.latitude, lng: city.longitude);
    final cuisinesAsync = ref.watch(provider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CuisinesHeader(
              city: city,
              count: cuisinesAsync.value?.length,
              onBack: onBack,
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: switch (cuisinesAsync) {
                AsyncData(:final value) =>
                  value.isEmpty
                      ? const _EmptyCuisinesView()
                      : CuisinesGridView(cuisines: value),
                AsyncError(:final error) => ErrorRetryView(
                  message: error is Failure
                      ? error.message
                      : 'Impossibile caricare le cucine. Riprova.',
                  onRetry: () => ref.invalidate(provider),
                ),
                _ => const AppLoadingIndicator(message: 'Carico le cucine…'),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Stato **empty-cuisines**: la città non ha cucine disponibili.
class _EmptyCuisinesView extends StatelessWidget {
  const _EmptyCuisinesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_meals_rounded,
              size: 64,
              color: AppColors.mutedText,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Nessuna cucina disponibile\nper questa città.',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
