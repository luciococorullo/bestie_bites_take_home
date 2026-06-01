import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/city_search/domain/entities/city.dart';
import 'app_view.dart';

part 'app_view_controller.g.dart';

/// Gestisce la modalità dell'unico schermo (ricerca ↔ cucine).
///
/// Tiene lo stato "di navigazione" come [AppView]: parte in [SearchMode],
/// passa a [CuisinesMode] al tap su una città e torna indietro col back.
@riverpod
class AppViewController extends _$AppViewController {
  @override
  AppView build() => const SearchMode();

  /// Tap su un suggerimento: apri le cucine della città scelta.
  void selectCity(City city) => state = CuisinesMode(city);

  /// Back (arrow o gesto di sistema): torna alla ricerca.
  void backToSearch() => state = const SearchMode();
}
