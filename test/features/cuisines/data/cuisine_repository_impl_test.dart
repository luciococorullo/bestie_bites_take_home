import 'package:bestie_bites_take_home/core/error/failure.dart';
import 'package:bestie_bites_take_home/features/cuisines/data/datasources/cuisine_remote_data_source.dart';
import 'package:bestie_bites_take_home/features/cuisines/data/repositories/cuisine_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late CuisineRepositoryImpl repository;

  setUpAll(() {
    // Fallback per il matcher any(named: 'queryParameters').
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    dio = MockDio();
    repository = CuisineRepositoryImpl(CuisineRemoteDataSource(dio));
  });

  Response<dynamic> responseWith(Object? body) => Response<dynamic>(
        data: body,
        requestOptions: RequestOptions(
          path: '/places/labels/by-location-and-type',
        ),
      );

  void stubGet(Response<dynamic> response) {
    when(
      () => dio.get<dynamic>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => response);
  }

  void stubThrow(Object error) {
    when(
      () => dio.get<dynamic>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenThrow(error);
  }

  DioException dioError(DioExceptionType type, {Response<dynamic>? response}) {
    return DioException(
      type: type,
      requestOptions: RequestOptions(path: ''),
      response: response,
    );
  }

  group('CuisineRepositoryImpl.getCuisines — parsing', () {
    test('mappa il body in cucine di dominio con priorità su name_it', () async {
      stubGet(
        responseWith(<String, dynamic>{
          'length': 2,
          'data': <Map<String, dynamic>>[
            {
              'id': 52,
              'name': 'Cinese',
              'name_it': 'Cinese',
              'name_eng': 'Chinese',
              'name_es': 'China',
              'color': '#5B50A1',
              'image_emoji': 'https://example.com/cucina_cinese.png',
              'type': 'cuisine',
              'eng_label': 'chinese',
            },
            {
              'id': 99,
              'name': 'Gluten free',
              'name_it': 'Senza glutine',
              'name_eng': 'Gluten free',
              'color': '#FFAA00',
              'image_emoji': 'https://example.com/senza_glutine.png',
              'type': 'cuisine',
              'eng_label': 'gluten_free',
            },
          ],
        }),
      );

      final cuisines = await repository.getCuisines(lat: 45.46, lng: 9.17);

      expect(cuisines, hasLength(2));
      expect(cuisines.first.id, 52);
      expect(cuisines.first.name, 'Cinese');
      expect(
        cuisines.first.imageEmojiUrl,
        'https://example.com/cucina_cinese.png',
      );
      expect(cuisines.first.colorHex, '#5B50A1');
      // name_it vince su name/name_eng/eng_label.
      expect(cuisines[1].name, 'Senza glutine');
    });

    test('ritorna lista vuota nel caso empty-cuisines', () async {
      stubGet(responseWith(<String, dynamic>{'length': 0, 'data': <dynamic>[]}));

      final cuisines = await repository.getCuisines(lat: 0, lng: 0);

      expect(cuisines, isEmpty);
    });
  });

  group('CuisineRepositoryImpl.getCuisines — error mapping', () {
    test('receiveTimeout → TimeoutFailure', () async {
      stubThrow(dioError(DioExceptionType.receiveTimeout));

      await expectLater(
        repository.getCuisines(lat: 1, lng: 2),
        throwsA(isA<TimeoutFailure>()),
      );
    });

    test('connectionError → NetworkFailure', () async {
      stubThrow(dioError(DioExceptionType.connectionError));

      await expectLater(
        repository.getCuisines(lat: 1, lng: 2),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('badResponse → ServerFailure con statusCode', () async {
      stubThrow(
        dioError(
          DioExceptionType.badResponse,
          response: Response<dynamic>(
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      await expectLater(
        repository.getCuisines(lat: 1, lng: 2),
        throwsA(
          isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 500),
        ),
      );
    });
  });
}
