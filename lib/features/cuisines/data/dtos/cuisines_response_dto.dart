import 'package:freezed_annotation/freezed_annotation.dart';

import 'cuisine_dto.dart';

part 'cuisines_response_dto.freezed.dart';
part 'cuisines_response_dto.g.dart';

/// Inviluppo della risposta di `/places/labels/by-location-and-type`:
/// `{ "length": n, "data": [...] }`.
///
/// [length] è il conteggio dichiarato dall'API; in pratica coincide con
/// `data.length` (usiamo poi quest'ultima per l'header, coerente col tipo di
/// ritorno `List<Cuisine>` del repository).
@freezed
abstract class CuisinesResponseDto with _$CuisinesResponseDto {
  const factory CuisinesResponseDto({
    @JsonKey(defaultValue: 0) required int length,
    @JsonKey(defaultValue: <CuisineDto>[]) required List<CuisineDto> data,
  }) = _CuisinesResponseDto;

  factory CuisinesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CuisinesResponseDtoFromJson(json);
}
