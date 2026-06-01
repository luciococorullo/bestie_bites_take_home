import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/city_repository.dart';
import '../datasources/city_remote_data_source.dart';
import '../dtos/city_dto.dart';

part 'city_repository_impl.g.dart';

/// Implementazione di [CityRepository] basata su [CityRemoteDataSource].
///
/// Tutta la gestione degli errori vive qui: le eccezioni di trasporto diventano
/// `Failure` (gerarchia sealed user-facing), così controller e UI non vedono
/// mai dettagli di dio.
class CityRepositoryImpl implements CityRepository {
  const CityRepositoryImpl(this._remote);

  final CityRemoteDataSource _remote;

  @override
  Future<List<City>> searchCities({
    required String term,
    CancelToken? cancelToken,
  }) async {
    try {
      final dtos = await _remote.autocomplete(
        term: term,
        cancelToken: cancelToken,
      );
      return dtos.map((dto) => dto.toEntity()).toList(growable: false);
    } on DioException catch (exception) {
      // mapDioException rilancia RequestCancelledException sui cancel: il
      // controller la intercetta e scarta in silenzio il risultato superato.
      throw mapDioException(exception);
    } on FormatException {
      throw const ParseFailure();
    } on TypeError {
      throw const ParseFailure();
    }
  }
}

/// Espone il repository legato al [cityRemoteDataSourceProvider].
@riverpod
CityRepository cityRepository(Ref ref) =>
    CityRepositoryImpl(ref.watch(cityRemoteDataSourceProvider));
