#!/usr/bin/env bash
# PostToolUse (Write|Edit) hook.
#
# Quando viene scritto/modificato del codice Dart testabile sotto lib/, inietta
# nel contesto un promemoria per creare o aggiornare il test corrispondente
# usando la skill `flutter-test-author`.
#
# Riceve su stdin il JSON dell'hook ({ tool_input.file_path, ... }) ed emette su
# stdout un oggetto con hookSpecificOutput.additionalContext (testo iniettato nel
# contesto del modello). Esce 0 senza output quando il file non e' rilevante.

input="$(cat)"
f="$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_response.filePath // empty' 2>/dev/null)"

# Nessun path → niente da fare.
[ -n "$f" ] || exit 0

# Salta i sorgenti generati: esclusi dall'analisi, non si testano a mano.
case "$f" in
  *.g.dart | *.freezed.dart) exit 0 ;;
esac

# Reagisci solo ai file Dart sotto lib/.
case "$f" in
  */lib/*.dart | lib/*.dart) ;;
  *) exit 0 ;;
esac

# Mirror lib/<rel> → test/<rel>_test.dart
rel="${f#*/lib/}"
rel="${rel#lib/}"
test_path="test/${rel%.dart}_test.dart"

jq -n --arg src "$f" --arg t "$test_path" '{
  hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext: ("Hai appena scritto/modificato codice in \($src). Se contiene logica testabile (DTO/parser fromJson·toEntity, repository con Dio mockato + mapping errore→Failure, datasource, controller/notifier, mapper o formatter), attiva la skill `flutter-test-author` e crea o aggiorna il test in `\($t)`, rispecchiando la struttura di lib/ e usando mocktail con group/test in italiano. Salta i widget puramente di presentazione, lib/main.dart, il tema e i file generati (*.g.dart / *.freezed.dart): per quelli non serve un unit test.")
  }
}'
