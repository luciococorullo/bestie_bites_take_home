# Cosa devi costruire

Una micro-app Flutter standalone — "Cucine in città" — con una sola schermata che permette di esplorare le cucine disponibili in una città usando le API pubbliche di BestieBite.

## Flow utente

- L'utente vede una barra di ricerca
- Digita il nome di una città → compaiono suggerimenti in tempo reale (autocomplete)
- Tappa un suggerimento → la schermata mostra le cucine disponibili in quella città come grid di card con emoji + nome
- Può tornare indietro alla ricerca per cambiare città

## API da usare

Tutte pubbliche, no auth, no API key.

### 1) Autocomplete città — durante la digitazione (debounced):

```
GET https://api.bestiebite.com/places/v2/autocomplete?term=mila&lang=it&limit=8
```

Risposta di esempio (campi più rilevanti per la UI, la risposta reale contiene altri campi come slug, path, adm1-adm4, country_code, geometry, population, level):

```json
[ { "id": 8047, "name": "Milano", "description": "Milano, Lombardia, Italia", "latitude": 45.4612939, "longitude": 9.172356290785304, "country_code": "IT", "structured_formatting": { "main_text": "Milano", "secondary_text": "Lombardia, Italia" } } ]
```

Note pratiche:

- Con term di 0 o 1 caratteri, l'API ritorna [] con HTTP 200 (non errore). Questo è il caso "nessun suggerimento": gestiscilo come no-results se vuoi attivare la ricerca solo da 2+ char.
- I caratteri unicode nel nome (es. Milanówek) sono UTF-8.

### 2) Cucine in una location — dopo tap su un suggerimento:

```
GET https://api.bestiebite.com/places/labels/by-location-and-type?lat=45.46&lng=9.17&type=cuisine
```

Risposta di esempio:

```json
{ "length": 34, "data": [ { "id": 52, "name": "Cinese", "name_it": "Cinese", "name_eng": "Chinese", "name_es": "China", "color": "#5B50A1", "image_emoji": "https://firebasestorage.googleapis.com/v0/b/bestie-bite.appspot.com/o/categories%2Fcuisine%2Fcucina_cinese.png?alt=media&token=...", "type": "cuisine", "eng_label": "chinese" } ] }
```

Note pratiche:

- image_emoji è una URL pubblica di una PNG (Firebase Storage o Google Cloud Storage). Caricala con Image.network o cached_network_image.
- L'API tende a ritornare almeno alcune cucine fallback anche per coordinate strane (es. mare aperto). Lo stato "empty cuisines" è quindi raro in pratica — gestiscilo comunque per robustezza ma non sprecare troppo tempo a forzarlo manualmente.

## Stati che la UI deve gestire

Vogliamo vedere come tratti questi casi:

- Idle — campo vuoto, niente in pagina
- Searching — l'utente sta digitando; mostra spinner o skeleton
- Suggestions — lista risultati autocomplete (debounce ≥250ms consigliato)
- No results — nessuna città trovata per il termine
- Loading cuisines — dopo tap, prima che arrivino le cucine
- Cuisines shown — grid con le cucine
- Empty cuisines — la città non ha cucine censite (caso reale, capita)
- Error — con bottone retry (su entrambe le chiamate)

## Requisiti tecnici minimi

- State management a tua scelta (Bloc / Riverpod / Provider / GetX) — argomenta la scelta nel Loom
- Debounce sull'autocomplete (non chiamare l'API a ogni keystroke)
- Almeno 1 test unitario su una parte pura del codice (parser DTO, repository con mock HTTP, formatter)
- Build runnabile su iOS, Android o Web (uno qualsiasi va bene — purché documentato)

## Mockup di riferimento

Trovi in allegato a questa email 3 mockup (idle / suggerimenti / griglia cucine) che mostrano come ci aspettiamo la UI. Aderisci il più possibile a:

- Layout dei tre stati
- Gerarchia visiva (search bar in cima, lista o griglia sotto, header con titolo + sottotitolo nella vista cucine)
- Palette brand (dark theme):
  - Background: `#0a0a0a`
  - Foreground: `#ffffff`
  - Primary/accent: `#ff5c5c`
  - Dark gray (surface): `#0e0e0e` · Medium gray (border): `#252525` · Light gray: `#3e4142` · Muted text: `#a7a7a7`
- Tipografia (sans-serif moderna, gerarchia tra titolo / sottotitolo / corpo / label piccola)
- Spaziatura e radius (rounded corners morbidi tipo 12-16px, padding generoso)

Non ci aspettiamo aderenza pixel-perfect: ci aspettiamo che tu legga il mockup e ne rispetti l'intent.

## Cosa NON richiediamo

- Login, persistenza, navigazione multi-schermata
- Mappa (lat/lng possono restare nei dati senza visualizzazione)
- Internazionalizzazione (it va bene)
- Test E2E o widget test estesi
- Animazioni complesse
- Niente CI/CD setup

## Tempo atteso

2-3 ore. Se ne impieghi di più non penalizza, ma dichiaralo nel Loom.

## AI consentita

Sì, anzi incoraggiata. Claude, Cursor, Copilot, quello che usi. Ci interessa come la usi.

## Deliverables

- Repo GitHub pubblico — link da inviarci. Commit history visibile (non squashare tutto in 1 commit).
- README che includa:
  - Come runnarlo (flutter run, eventuali setup, device target)
  - Architettura sintetica (3-5 bullet)
  - 1 cosa di cui sei orgoglioso
  - 1 cosa che faresti diversamente con più tempo
- Loom (o video registrato di 5 min max) in cui:
  - Mostri l'app girare con tutti gli stati
  - Spieghi 1 decisione tecnica chiave (es. perché Bloc invece di Riverpod)
  - Mostri come hai usato l'AI: un prompt memorabile e/o un momento in cui l'hai rifiutata
