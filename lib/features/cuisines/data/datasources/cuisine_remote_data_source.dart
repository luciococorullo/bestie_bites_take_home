import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_providers.dart';
import '../dtos/cuisines_response_dto.dart';

part 'cuisine_remote_data_source.g.dart';

/// Accesso HTTP grezzo all'endpoint delle cucine per location.
///
/// Fa la GET e deserializza l'inviluppo `{length, data}`; non gestisce gli
/// errori (li lascia emergere come `DioException`): la traduzione in `Failure`
/// è compito del repository.
class CuisineRemoteDataSource {
  const CuisineRemoteDataSource(this._dio);

  final Dio _dio;

  static const String _path = '/places/labels/by-location-and-type';

  Future<CuisinesResponseDto> getCuisines({
    required double lat,
    required double lng,
  }) async {
    final response = await _dio.get<dynamic>(
      _path,
      queryParameters: <String, dynamic>{
        'lat': lat,
        'lng': lng,
        'type': 'cuisine',
      },
    );
    return CuisinesResponseDto.fromJson(response.data as Map<String, dynamic>);
  }
}

/// Espone il data source legato al [dioProvider] condiviso.
@riverpod
CuisineRemoteDataSource cuisineRemoteDataSource(Ref ref) =>
    CuisineRemoteDataSource(ref.watch(dioProvider));
