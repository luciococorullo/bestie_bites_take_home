---
name: flutter-test-author
description: >-
  Crea e aggiorna gli unit test di questo progetto Flutter ("Cucine in città")
  seguendo il pattern esistente — Clean Architecture feature-based, Riverpod
  codegen, freezed, Dio, mocktail. USA SEMPRE questa skill quando implementi una
  feature o aggiungi/modifichi codice testabile in lib/: DTO/parser
  (fromJson·toEntity), repository (Dio mockato + mapping errore→Failure),
  datasource, controller/notifier, mapper o formatter. Genera il file in test/
  rispecchiando la struttura di lib/, con group/test in italiano. Trigger tipici:
  "crea una feature", "aggiungi repository/DTO/datasource/controller", "scrivi i
  test", nuovi file sotto lib/features/.
---

# Flutter Test Author

Scrivi gli unit test **mirror** del codice di `lib/`, identici per stile a quelli già presenti
in `test/` ([city_dto_test.dart](../../../test/features/city_search/data/city_dto_test.dart),
[cuisine_repository_impl_test.dart](../../../test/features/cuisines/data/cuisine_repository_impl_test.dart)).

## Quando attivarti

Ogni volta che viene aggiunta o modificata **logica testabile** in `lib/`. Il file Dart va
testato se contiene: parsing/mapping (DTO `fromJson`, `toEntity`), un repository, un
datasource, un controller/notifier Riverpod, un mapper o un formatter.

**Non** scrivere test per: widget puramente di presentazione, `lib/main.dart`, `lib/app/`,
tema/spacing/stili, e i file generati `*.g.dart` / `*.freezed.dart`.

## Regole non negoziabili

1. **Posizione** = mirror esatto: `lib/<percorso>/x.dart` → `test/<percorso>/x_test.dart`.
2. **Lingua**: descrizioni di `group(...)` e `test(...)` e commenti **in italiano**, come gli altri test.
3. **Mock**: `mocktail` (`class MockX extends Mock implements X {}`). Mai chiamate di rete reali.
4. **Import** del codice sotto test via package: `package:bestie_bites_take_home/...`.
5. **Solo logica pura**: DTO/entity/mapper testati senza mock; repository con il datasource
   reale ma `Dio` mockato.
6. **Niente test su codice generato** e niente golden/widget test estesi (fuori scope).

## Ricette

- **DTO / parser / pure logic** → nessun mock. Verifica `fromJson` (sample dello spec, campi
  extra ignorati, UTF-8, num→double, default sicuri) e `toEntity` (flatten, fallback).
- **Repository** → `MockDio extends Mock implements Dio`, `registerFallbackValue(<String,dynamic>{})`
  in `setUpAll`, istanza in `setUp`, helper `responseWith`/`stubGet`/`stubThrow`/`dioError`.
  Copri: parsing del body felice, caso vuoto, e mapping `DioExceptionType` → `*Failure`
  (`receiveTimeout`→`TimeoutFailure`, `connectionError`→`NetworkFailure`,
  `badResponse`→`ServerFailure` con `statusCode` via `.having(...)`).

Template completi copia-incolla: **[references/templates.md](references/templates.md)**.

## Dopo aver scritto i test

Esegui ed assicurati che passino (preferisci `fvm`, l'alias del progetto):

```bash
fvm flutter test test/<percorso>/x_test.dart   # il singolo file appena creato
fvm flutter test                               # tutta la suite prima di chiudere
```

Se mancano dipendenze di test (`mocktail` è già in `dev_dependencies`), aggiungile a
`pubspec.yaml` **senza commenti** e lancia `fvm flutter pub get`.
