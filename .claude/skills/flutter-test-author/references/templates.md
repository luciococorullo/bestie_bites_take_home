# Template dei test — copia, rinomina, adatta

Tutti i template ricalcano i test già presenti nel repo. Sostituisci `Feature`,
`Thing`, i percorsi e i campi con quelli reali. Mantieni le descrizioni in italiano.

---

## 1. DTO / parser / logica pura (niente mock)

Modello: [`test/features/city_search/data/city_dto_test.dart`](../../../../test/features/city_search/data/city_dto_test.dart).

```dart
import 'package:bestie_bites_take_home/features/<feature>/data/dtos/<thing>_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('<Thing>Dto.fromJson', () {
    test('analizza il sample dello spec e ignora i campi extra', () {
      final json = <String, dynamic>{
        'id': 1,
        'name': 'Esempio',
        // campi reali dell'API che NON mappiamo: devono essere ignorati
        'slug': 'esempio',
        'extra': 123,
      };

      final dto = <Thing>Dto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.name, 'Esempio');
    });

    test('preserva i nomi UTF-8', () {
      final dto = <Thing>Dto.fromJson(<String, dynamic>{'id': 2, 'name': 'Milanówek'});
      expect(dto.name, 'Milanówek');
    });

    test('accetta num interi esponendoli come double', () {
      final dto = <Thing>Dto.fromJson(<String, dynamic>{'id': 3, 'lat': 45});
      expect(dto.lat, 45.0);
    });
  });

  group('<Thing>Dto.toEntity', () {
    test('mappa i campi e applica i fallback', () {
      final entity = <Thing>Dto.fromJson(<String, dynamic>{'id': 4, 'name': 'Roma'}).toEntity();

      expect(entity.id, 4);
      expect(entity.name, 'Roma');
    });

    test('default sicuri per i campi opzionali mancanti', () {
      final entity = <Thing>Dto.fromJson(<String, dynamic>{'id': 5, 'name': 'X'}).toEntity();

      expect(entity.description, '');
      expect(entity.latitude, 0);
    });
  });
}
```

Asserzioni utili: `closeTo(45.46, 1e-9)` per i double, `isEmpty`/`hasLength(n)` per le liste.

---

## 2. Repository con `Dio` mockato + mapping errore→Failure

Modello: [`test/features/cuisines/data/cuisine_repository_impl_test.dart`](../../../../test/features/cuisines/data/cuisine_repository_impl_test.dart).

```dart
import 'package:bestie_bites_take_home/core/error/failure.dart';
import 'package:bestie_bites_take_home/features/<feature>/data/datasources/<thing>_remote_data_source.dart';
import 'package:bestie_bites_take_home/features/<feature>/data/repositories/<thing>_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late <Thing>RepositoryImpl repository;

  setUpAll(() {
    // Fallback per il matcher any(named: 'queryParameters').
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    dio = MockDio();
    repository = <Thing>RepositoryImpl(<Thing>RemoteDataSource(dio));
  });

  Response<dynamic> responseWith(Object? body) => Response<dynamic>(
        data: body,
        requestOptions: RequestOptions(path: '/<endpoint>'),
      );

  void stubGet(Response<dynamic> response) {
    when(
      () => dio.get<dynamic>(any(), queryParameters: any(named: 'queryParameters')),
    ).thenAnswer((_) async => response);
  }

  void stubThrow(Object error) {
    when(
      () => dio.get<dynamic>(any(), queryParameters: any(named: 'queryParameters')),
    ).thenThrow(error);
  }

  DioException dioError(DioExceptionType type, {Response<dynamic>? response}) {
    return DioException(
      type: type,
      requestOptions: RequestOptions(path: ''),
      response: response,
    );
  }

  group('<Thing>RepositoryImpl.<method> — parsing', () {
    test('mappa il body in entità di dominio', () async {
      stubGet(responseWith(<String, dynamic>{'length': 1, 'data': <Map<String, dynamic>>[
        {'id': 1, 'name': 'X'},
      ]}));

      final result = await repository.<method>(/* args */);

      expect(result, hasLength(1));
      expect(result.first.id, 1);
    });

    test('ritorna lista vuota nel caso empty', () async {
      stubGet(responseWith(<String, dynamic>{'length': 0, 'data': <dynamic>[]}));
      expect(await repository.<method>(/* args */), isEmpty);
    });
  });

  group('<Thing>RepositoryImpl.<method> — error mapping', () {
    test('receiveTimeout → TimeoutFailure', () async {
      stubThrow(dioError(DioExceptionType.receiveTimeout));
      await expectLater(repository.<method>(/* args */), throwsA(isA<TimeoutFailure>()));
    });

    test('connectionError → NetworkFailure', () async {
      stubThrow(dioError(DioExceptionType.connectionError));
      await expectLater(repository.<method>(/* args */), throwsA(isA<NetworkFailure>()));
    });

    test('badResponse → ServerFailure con statusCode', () async {
      stubThrow(dioError(
        DioExceptionType.badResponse,
        response: Response<dynamic>(statusCode: 500, requestOptions: RequestOptions(path: '')),
      ));
      await expectLater(
        repository.<method>(/* args */),
        throwsA(isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 500)),
      );
    });
  });
}
```

I tipi di `Failure` disponibili sono in
[`lib/core/error/failure.dart`](../../../../lib/core/error/failure.dart) — usa quelli
reali del progetto, non inventarne.

---

## 3. Controller / notifier Riverpod (quando ne crei uno)

Non c'è ancora un test di controller nel repo: segui questa struttura, mockando il
repository di dominio e pilotando il `ProviderContainer` con gli override generati da
`riverpod_generator`.

```dart
import 'package:bestie_bites_take_home/features/<feature>/domain/repositories/<thing>_repository.dart';
import 'package:bestie_bites_take_home/features/<feature>/presentation/controllers/<thing>_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class Mock<Thing>Repository extends Mock implements <Thing>Repository {}

void main() {
  late Mock<Thing>Repository repository;
  late ProviderContainer container;

  setUp(() {
    repository = Mock<Thing>Repository();
    container = ProviderContainer(
      overrides: [
        // override del provider generato del repository
        <thing>RepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
  });

  test('espone lo stato corretto al successo', () async {
    when(() => repository.<method>(/* args */)).thenAnswer((_) async => <expected>);

    // pilota il notifier e verifica le transizioni di stato (es. AsyncValue)
  });
}
```

Mantieni i test deterministici: per la logica di **debounce** usa `fakeAsync` /
`FakeAsync().elapse(...)` invece di attese reali, così il test resta veloce.
