import '../entities/cuisine.dart';

/// Contratto per il recupero delle cucine di una location.
///
/// L'implementazione converte gli errori di rete in `Failure` (vedi
/// `core/error/`): chi consuma il repository ragiona solo su [Cuisine] e su
/// `Failure`, mai su dettagli di dio/HTTP.
abstract interface class CuisineRepository {
  Future<List<Cuisine>> getCuisines({
    required double lat,
    required double lng,
  });
}
