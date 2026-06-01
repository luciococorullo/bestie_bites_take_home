import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/request_cancelled_exception.dart';
import '../../data/repositories/city_repository_impl.dart';
import '../state/search_state.dart';

part 'city_search_controller.g.dart';

/// Controller dell'autocomplete città: fa da application layer (debounce,
/// cancellazione, transizioni di stato) e parla direttamente col repository.
///
/// Due pezzi tecnici chiave:
/// - **debounce**: non chiamiamo l'API a ogni keystroke, ma 300ms dopo l'ultimo
///   (≥250ms richiesti dalla spec);
/// - **CancelToken**: ogni nuova ricerca annulla la precedente, così un
///   risultato superato non sovrascrive quello più recente.
@riverpod
class CitySearchController extends _$CitySearchController {
  /// Soglia minima di caratteri per attivare la ricerca (sotto → idle).
  static const int _minChars = 2;

  /// Ritardo di debounce (≥250ms come da spec).
  static const Duration _debounceDelay = Duration(milliseconds: 300);

  Timer? _debounce;
  CancelToken? _cancelToken;

  /// Ultimo termine ricercato (≥ [_minChars]): serve al retry.
  String _lastTerm = '';

  @override
  SearchState build() {
    ref.onDispose(() {
      _debounce?.cancel();
      _cancelToken?.cancel();
    });
    return const SearchState.idle();
  }

  /// Da chiamare a ogni cambio di testo del campo di ricerca.
  void onQueryChanged(String rawQuery) {
    _debounce?.cancel();
    final term = rawQuery.trim();

    if (term.length < _minChars) {
      // Sotto soglia: annulla l'eventuale richiesta in volo e torna a idle
      // (non noResults: non abbiamo ancora cercato nulla).
      _cancelToken?.cancel();
      _cancelToken = null;
      _lastTerm = '';
      state = const SearchState.idle();
      return;
    }

    _lastTerm = term;
    // Feedback immediato mentre aspettiamo il debounce + la risposta.
    state = const SearchState.searching();
    _debounce = Timer(_debounceDelay, () => _run(term));
  }

  /// Riprova l'ultima ricerca fallita (bottone della `ErrorRetryView`).
  void retry() {
    if (_lastTerm.length < _minChars) {
      state = const SearchState.idle();
      return;
    }
    state = const SearchState.searching();
    _run(_lastTerm);
  }

  Future<void> _run(String term) async {
    // Annulla la richiesta precedente e creane una nuova tracciabile.
    _cancelToken?.cancel();
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    try {
      final cities = await ref.read(cityRepositoryProvider).searchCities(
            term: term,
            cancelToken: cancelToken,
          );
      // Nel frattempo è partita una ricerca più recente: scarta il risultato.
      if (cancelToken != _cancelToken) return;
      state = cities.isEmpty
          ? const SearchState.noResults()
          : SearchState.suggestions(cities);
    } on RequestCancelledException {
      // Annullata di proposito (digitazione veloce): ignora senza errori.
    } on Failure catch (failure) {
      if (cancelToken != _cancelToken) return;
      state = SearchState.error(failure);
    }
  }
}
