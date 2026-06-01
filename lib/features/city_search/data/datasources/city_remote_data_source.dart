import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_providers.dart';
import '../dtos/city_dto.dart';

part 'city_remote_data_source.g.dart';

/// Accesso HTTP grezzo all'endpoint di autocomplete città.
///
/// Si limita a fare la GET e a deserializzare l'array in [CityDto]; non gestisce
/// gli errori (li lascia emergere come `DioException`): la traduzione in
/// `Failure` è compito del repository.
class CityRemoteDataSource {
  const CityRemoteDataSource(this._dio);

  final Dio _dio;

  static const String _path = '/places/v2/autocomplete';

  /// Cerca le città che combaciano con [term]. La risposta è un **array** JSON
  /// ([] con HTTP 200 quando non ci sono match). [cancelToken] consente di
  /// annullare la richiesta superata quando l'utente continua a digitare.
  Future<List<CityDto>> autocomplete({
    required String term,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<dynamic>(
      _path,
      queryParameters: <String, dynamic>{
        'term': term,
        'lang': 'it',
        'limit': 8,
      },
      cancelToken: cancelToken,
    );
    final data = response.data as List<dynamic>;
    return data
        .map((item) => CityDto.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}

/// Espone il data source legato al [dioProvider] condiviso.
@riverpod
CityRemoteDataSource cityRemoteDataSource(Ref ref) =>
    CityRemoteDataSource(ref.watch(dioProvider));
