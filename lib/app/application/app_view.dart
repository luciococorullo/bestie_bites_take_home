import '../../features/city_search/domain/entities/city.dart';

/// Modalità correnti dell'unico schermo dell'app ("navigazione-as-stato").
///
/// Le due feature (ricerca città e cucine) condividono una sola schermata: non
/// serve un router, basta uno stato sealed su cui `HomeScreen` fa `switch`.
/// È una `sealed class` scritta a mano (niente freezed): due varianti banali,
/// di cui una porta con sé la [City] selezionata.
sealed class AppView {
  const AppView();
}

/// Modalità ricerca: campo di autocomplete + suggerimenti (stato iniziale).
final class SearchMode extends AppView {
  const SearchMode();
}

/// Modalità cucine: griglia delle cucine della [city] selezionata.
final class CuisinesMode extends AppView {
  const CuisinesMode(this.city);

  final City city;
}
