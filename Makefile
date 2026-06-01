# Uses fvm if installed (honors the .fvmrc pin: Flutter 3.44.0), otherwise the
# Flutter already on PATH. So `make run` works on any setup, with or without fvm.
ifeq ($(shell command -v fvm >/dev/null 2>&1 && echo yes),yes)
FLUTTER ?= fvm flutter
DART ?= fvm dart
else
FLUTTER ?= flutter
DART ?= dart
endif

.PHONY: init get gen run run-ios run-android test devices

# Onboarding one-shot: dipendenze + codegen. Da lanciare appena clonato il repo.
init: get gen

get:
	$(FLUTTER) pub get

gen:
	$(DART) run build_runner build --delete-conflicting-outputs

# Run on the first connected mobile device (simulator/emulator/phone) — no
# device picker. In `flutter devices` only real devices carry "(mobile)" in the
# 1st column (desktop/web don't); the 2nd column is the device id. Falls back to
# interactive run if no mobile device is found.
run:
	@id=$$($(FLUTTER) devices 2>/dev/null | awk -F' • ' '$$1 ~ /\(mobile\)/ {gsub(/[[:space:]]/,"",$$2); print $$2; exit}'); \
	if [ -n "$$id" ]; then \
		echo "▶  Avvio su $$id"; $(FLUTTER) run -d "$$id"; \
	else \
		echo "▶  Nessun device mobile trovato — avvio interattivo"; $(FLUTTER) run; \
	fi

# Like `run` but restricted to an iOS / Android device (3rd column = platform).
run-ios:
	@id=$$($(FLUTTER) devices 2>/dev/null | awk -F' • ' '$$1 ~ /\(mobile\)/ && $$3 ~ /ios/ {gsub(/[[:space:]]/,"",$$2); print $$2; exit}'); \
	if [ -n "$$id" ]; then echo "▶  Avvio su $$id"; $(FLUTTER) run -d "$$id"; \
	else echo "✗  Nessun device iOS trovato (avvia un simulatore)"; exit 1; fi

run-android:
	@id=$$($(FLUTTER) devices 2>/dev/null | awk -F' • ' '$$1 ~ /\(mobile\)/ && $$3 ~ /android/ {gsub(/[[:space:]]/,"",$$2); print $$2; exit}'); \
	if [ -n "$$id" ]; then echo "▶  Avvio su $$id"; $(FLUTTER) run -d "$$id"; \
	else echo "✗  Nessun device Android trovato (avvia un emulatore)"; exit 1; fi

test:
	$(FLUTTER) test

devices:
	$(FLUTTER) devices
