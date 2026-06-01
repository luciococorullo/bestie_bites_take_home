import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../features/city_search/presentation/widgets/search_body.dart';
import '../features/cuisines/presentation/widgets/cuisines_body.dart';
import 'application/app_view.dart';
import 'application/app_view_controller.dart';

/// Unico schermo dell'app: fa `switch` sull'[AppView] per mostrare la ricerca
/// città oppure le cucine della città scelta.
///
/// Niente router: la "navigazione" è solo cambio di stato dell'[AppViewController].
/// Il [PopScope] intercetta il back di sistema (Android/gesto) quando si è sulle
/// cucine, riportando alla ricerca invece di chiudere l'app.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(appViewControllerProvider);
    final controller = ref.read(appViewControllerProvider.notifier);

    return PopScope(
      // Sulle cucine il pop è gestito a mano (torna alla ricerca); nella
      // ricerca lasciamo che il back chiuda l'app come da comportamento nativo.
      canPop: view is SearchMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && view is CuisinesMode) {
          controller.backToSearch();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: switch (view) {
          SearchMode() => SearchBody(onCitySelected: controller.selectCity),
          CuisinesMode(:final city) => CuisinesBody(
            city: city,
            onBack: controller.backToSearch,
          ),
        },
      ),
    );
  }
}
