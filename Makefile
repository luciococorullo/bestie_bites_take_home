# All commands go through fvm to honor the .fvmrc pin (Flutter 3.44.0).
FLUTTER ?= fvm flutter
DART ?= fvm dart

.PHONY: gen run-web run-android run-ios test

gen:
	$(DART) run build_runner build --delete-conflicting-outputs

run-web:
	$(FLUTTER) run -d chrome

run-android:
	$(FLUTTER) run -d android

run-ios:
	$(FLUTTER) run -d ios

test:
	$(FLUTTER) test
