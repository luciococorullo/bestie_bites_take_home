import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/entities/cuisine.dart';
import '../../domain/repositories/cuisine_repository.dart';
import '../datasources/cuisine_remote_data_source.dart';
import '../dtos/cuisine_dto.dart';

part 'cuisine_repository_impl.g.dart';

/// Implementazione di [CuisineRepository] basata su [CuisineRemoteDataSource].
///
/// Converte le eccezioni di trasporto in `Failure` user-facing, così controller
/// e UI non vedono mai dettagli di dio. Qui non serve `CancelToken`: la chiamata
/// parte una sola volta dopo il tap e il retry rifà la richiesta da capo.
class CuisineRepositoryImpl implements CuisineRepository {
  const CuisineRepositoryImpl(this._remote);

  final CuisineRemoteDataSource _remote;

  @override
  Future<List<Cuisine>> getCuisines({
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await _remote.getCuisines(lat: lat, lng: lng);
      return response.data.map((dto) => dto.toEntity()).toList(growable: false);
    } on DioException catch (exception) {
      throw mapDioException(exception);
    } on FormatException {
      throw const ParseFailure();
    } on TypeError {
      throw const ParseFailure();
    }
  }
}

/// Espone il repository legato al [cuisineRemoteDataSourceProvider].
@riverpod
CuisineRepository cuisineRepository(Ref ref) =>
    CuisineRepositoryImpl(ref.watch(cuisineRemoteDataSourceProvider));
