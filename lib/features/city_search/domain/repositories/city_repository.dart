import 'package:dio/dio.dart';

import '../entities/city.dart';

/// Contratto per la ricerca città (autocomplete).
///
/// L'implementazione converte gli errori di rete in `Failure` (vedi
/// `core/error/`): chi consuma il repository ragiona solo su [City] e su
/// `Failure`, mai su dettagli di dio/HTTP.
///
/// [cancelToken] è l'unica concessione al trasporto: serve ad annullare la
/// richiesta di autocomplete precedente quando l'utente continua a digitare.
/// Un'astrazione dedicata sarebbe over-engineering per una micro-app a due
/// endpoint, quindi riusiamo direttamente il `CancelToken` di dio.
abstract interface class CityRepository {
  Future<List<City>> searchCities({
    required String term,
    CancelToken? cancelToken,
  });
}
