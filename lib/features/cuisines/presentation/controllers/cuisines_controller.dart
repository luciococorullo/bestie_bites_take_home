import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/cuisine_repository_impl.dart';
import '../../domain/entities/cuisine.dart';

part 'cuisines_controller.g.dart';

/// Provider delle cucine di una location (lat/lng).
///
/// È volutamente un *future provider* sottile: nessuna logica propria oltre
/// alla chiamata al repository. L'`AsyncValue` risultante copre nativamente i
/// tre stati cucine della spec — loading / data (shown o empty) / error — su
/// cui la UI fa `switch`. Il retry è un `ref.invalidate(cuisinesProvider(...))`
/// che rifà la richiesta da capo.
@riverpod
Future<List<Cuisine>> cuisines(
  Ref ref, {
  required double lat,
  required double lng,
}) {
  return ref.watch(cuisineRepositoryProvider).getCuisines(lat: lat, lng: lng);
}
