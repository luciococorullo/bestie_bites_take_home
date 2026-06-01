import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/city.dart';

part 'city_dto.freezed.dart';
part 'city_dto.g.dart';

/// DTO della risposta di `/places/v2/autocomplete`.
///
/// La risposta reale ha molti più campi (slug, path, adm1-adm4, geometry,
/// population, level…): json_serializable ignora le chiavi sconosciute, quindi
/// mappiamo solo ciò che serve alla UI e alla chiamata cucine. I campi oltre a
/// [id]/[name] sono nullable per robustezza verso payload incompleti.
@freezed
abstract class CityDto with _$CityDto {
  const factory CityDto({
    required int id,
    required String name,
    String? description,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'structured_formatting')
    StructuredFormattingDto? structuredFormatting,
  }) = _CityDto;

  factory CityDto.fromJson(Map<String, dynamic> json) =>
      _$CityDtoFromJson(json);
}

/// Sotto-oggetto `structured_formatting`: titolo e sottotitolo già pronti per
/// il suggerimento (es. "Milano" / "Lombardia, Italia").
@freezed
abstract class StructuredFormattingDto with _$StructuredFormattingDto {
  const factory StructuredFormattingDto({
    @JsonKey(name: 'main_text') String? mainText,
    @JsonKey(name: 'secondary_text') String? secondaryText,
  }) = _StructuredFormattingDto;

  factory StructuredFormattingDto.fromJson(Map<String, dynamic> json) =>
      _$StructuredFormattingDtoFromJson(json);
}

/// Mapping DTO → entità di dominio.
///
/// [City.mainText]/[City.secondaryText] vengono da `structured_formatting`,
/// con fallback su `name`/`description` quando il blocco manca o è vuoto (così
/// il suggerimento resta sempre leggibile).
extension CityDtoMapper on CityDto {
  City toEntity() {
    final main = structuredFormatting?.mainText;
    final secondary = structuredFormatting?.secondaryText;
    return City(
      id: id,
      name: name,
      description: description ?? '',
      latitude: latitude ?? 0,
      longitude: longitude ?? 0,
      countryCode: countryCode ?? '',
      mainText: (main != null && main.isNotEmpty) ? main : name,
      secondaryText: (secondary != null && secondary.isNotEmpty)
          ? secondary
          : (description ?? ''),
    );
  }
}
