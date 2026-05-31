import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';

/// Città del dominio, già pronta per la UI e per la chiamata alle cucine.
///
/// È un'entità *pura*: niente JSON né dipendenze di trasporto. I campi
/// [mainText]/[secondaryText] sono la versione appiattita di
/// `structured_formatting` (titolo + sottotitolo del suggerimento), mentre
/// [latitude]/[longitude] servono poi a interrogare le cucine della location.
@freezed
abstract class City with _$City {
  const factory City({
    required int id,
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    required String countryCode,
    required String mainText,
    required String secondaryText,
  }) = _City;
}
