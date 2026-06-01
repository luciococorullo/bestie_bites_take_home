# Cucine in città

Micro-app Flutter single-screen: cerchi una città con autocomplete in tempo reale e sfogli le cucine disponibili come griglia di card. UI in italiano, dark theme brand, dati dalle API pubbliche di BestieBite.

---

## Come runnarlo

Toolchain: **Flutter 3.44.0 / Dart 3.12.0**, pinnata via [fvm](https://fvm.app) (`.fvmrc`).
fvm è **opzionale**: il `Makefile` lo usa se presente, altrimenti ricade sul `flutter` che hai sul PATH (serve un Flutter con Dart ≥ 3.12).

```bash
make init   # flutter pub get + codegen (freezed/riverpod/json) — appena clonato il repo
make run    # build + avvio sul primo device mobile collegato (niente picker)
make test   # unit test
```

> ⚠️ I file generati (`*.g.dart`, `*.freezed.dart`) **non sono committati**: `make init` li rigenera (`get` + `gen`). Senza, il progetto non compila.

`make run` seleziona da solo il primo simulatore / emulatore / telefono collegato — **nessuna lista di device da scegliere**. Avvia prima un simulatore iOS o un emulatore Android. Per forzare la piattaforma: `make run-ios` oppure `make run-android`.

**Device target: iOS / Android.** Il web è volutamente fuori scope: la UI dei mockup è mobile-first e le API pubbliche di terzi avrebbero richiesto un proxy CORS in browser.

---

## Architettura

- **Clean Architecture feature-based** — due feature (`city_search`, `cuisines`), ognuna con `data / domain / presentation`, più un `core` condiviso (network, error, theme, widget). L'unica schermata e lo stato di "navigazione" vivono in un thin shell `app/`.
- **State management: Riverpod con full code-generation** (`@riverpod`) — i notifier fanno da application layer (debounce, cancellazione, transizioni di stato) e chiamano direttamente i repository. Niente layer use-case: con 2 endpoint e zero business logic sarebbe stato over-engineering passthrough.
- **Navigazione-come-stato** — un `AppView` sealed (`searchMode | cuisinesMode(City)`) + `PopScope` per il back Android, al posto di un router: una sola schermata, zero dipendenze di navigazione.
- **8 stati espliciti, type-safe** — la ricerca è un `SearchState` sealed (`idle/searching/suggestions/noResults/error`), le cucine usano `AsyncValue` (loading/data/empty/error); la UI fa `switch` esaustivo Dart 3.
- **Modelli ed errori robusti** — DTO/entity con freezed + json_serializable, HTTP con dio; le `DioException` sono mappate a una gerarchia `Failure` sealed con messaggi user-facing in italiano (network / timeout / server / parse / unknown).

### Perché Riverpod (decisione chiave)

È la prima volta che uso Riverpod: nei progetti precedenti non l'avevo mai adottato, ma per la complessità di questa app mi è sembrata la scelta giusta, in più mi incuriosiva molto e volevo genuinamente provarlo. Il code-gen elimina il boilerplate dei provider e dà reference type-safe a compile time; `AsyncValue` copre nativamente loading/data/error — 4 degli 8 stati richiesti — senza codice di plumbing; e `ref.onDispose` è il posto naturale dove cancellare il timer di debounce e il `CancelToken`. Mi sono fatto aiutare dall'AI per usarlo nel modo corretto (codegen, lifecycle del notifier, `AsyncValue`) invece di forzare pattern presi da altri state manager. Bloc, che conosco molto meglio, sarebbe stato altrettanto valido ma overkill per una micro-app a singola schermata.

---

## Test e uso dell'AI

Test presenti:

- **`test/.../city_search/data/city_dto_test.dart`** — parsing `CityDto.fromJson` + `toEntity`: flatten di `structured_formatting`, fallback su `name`/`description`, nomi UTF-8 (es. *Milanówek*).
- **`test/.../cuisines/data/cuisine_repository_impl_test.dart`** — repository con `Dio` mockato (mocktail): body felice **e** mapping `DioExceptionType` → `Failure` (`receiveTimeout`→`TimeoutFailure`, `connectionError`→`NetworkFailure`, `badResponse`→`ServerFailure` con `statusCode`).

Ma la parte interessante è **come** sono stati scritti. Invece di chiedere test all'AI caso per caso, ho trattato l'AI come parte del toolchain:

- **Skill Claude Code `flutter-test-author`** (`.claude/skills/`) — cattura le convenzioni di test del repo (mirror `lib/ → test/`, mocktail, `group`/`test` in italiano, ricette pronte per DTO e repository). Così l'AI genera test coerenti per stile e struttura, non improvvisati.
- **Hook `PostToolUse` `flutter-test-reminder.sh`** (`.claude/hooks/`) — a ogni `Write`/`Edit` di un `.dart` *testabile* sotto `lib/`, inietta nel contesto un promemoria con il path-mirror del test da creare, saltando widget di presentazione, tema e file generati. La disciplina di test diventa **automatica e self-reinforcing**, non affidata alla memoria.

---

## Di cosa sono orgoglioso

**L'AI come parte del toolchain, non solo come autocompletamento.** La skill + hook qui sopra trasformano "scrivi i test" da richiesta una-tantum a regola del progetto che si auto-applica: l'AI produce test mirror coerenti e non "dimentica" un parser o un repository appena aggiunto. È il pezzo di cui vado più fiero perché risponde alla domanda *come* usare l'AI, non solo *se*, lo stesso approccio con cui mi sono fatto guidare su Riverpod, per me nuovo.

Menzione tecnica ravvicinata: il cuore dell'app — **debounce 300ms + `CancelToken`** nel `CitySearchController` — scarta in silenzio i risultati superati quando si digita veloce (nuova ricerca → annulla la precedente), così nessun flash d'errore e nessuna risposta "in ritardo" che sovrascrive quella più recente.

## Cosa farei con più tempo

- **Test del controller con `fake_async`** per verificare in modo deterministico debounce e cancellazione (oggi sono coperti i layer puri — DTO e repository — ma non la sequenza temporale del notifier).
- **Color-theming per-cucina**: il campo `color` dell'API è già mappato nell'entity ma non ancora usato per tingere le card.

---

> Spec completa della traccia: [`take-home.md`](take-home.md).
