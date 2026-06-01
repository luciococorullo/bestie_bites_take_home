import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/city.dart';

part 'search_state.freezed.dart';

/// Stato della ricerca città. Copre 5 degli 8 stati della spec (gli altri 3 —
/// loading/shown/empty cucine — vivono nella feature `cuisines`).
///
/// È una union `sealed`: la UI ci fa sopra uno `switch` esaustivo (Dart 3),
/// senza `.when`/`.map`.
@freezed
sealed class SearchState with _$SearchState {
  /// Campo vuoto o meno di 2 caratteri: nessuna ricerca in corso.
  const factory SearchState.idle() = SearchIdle;

  /// L'utente sta digitando: debounce in corso o richiesta in volo.
  const factory SearchState.searching() = SearchSearching;

  /// Risultati di autocomplete da mostrare.
  const factory SearchState.suggestions(List<City> cities) = SearchSuggestions;

  /// Ricerca completata senza alcuna città trovata.
  const factory SearchState.noResults() = SearchNoResults;

  /// La chiamata è fallita: porta con sé il [Failure] user-facing.
  const factory SearchState.error(Failure failure) = SearchError;
}
