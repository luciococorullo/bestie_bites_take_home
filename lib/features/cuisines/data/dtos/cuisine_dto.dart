import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/cuisine.dart';

part 'cuisine_dto.freezed.dart';
part 'cuisine_dto.g.dart';

/// DTO di una cucina dentro `data` della risposta cucine.
///
/// Teniamo i nomi localizzati per scegliere quello giusto per la UI italiana;
/// le chiavi sconosciute vengono ignorate da json_serializable.
@freezed
abstract class CuisineDto with _$CuisineDto {
  const factory CuisineDto({
    required int id,
    String? name,
    @JsonKey(name: 'name_it') String? nameIt,
    @JsonKey(name: 'name_eng') String? nameEng,
    @JsonKey(name: 'name_es') String? nameEs,
    String? color,
    @JsonKey(name: 'image_emoji') String? imageEmoji,
    String? type,
    @JsonKey(name: 'eng_label') String? engLabel,
  }) = _CuisineDto;

  factory CuisineDto.fromJson(Map<String, dynamic> json) =>
      _$CuisineDtoFromJson(json);
}

/// Mapping DTO → entità di dominio.
///
/// Nome per la UI italiana con cascata di fallback
/// (`name_it → name → name_eng → eng_label → ''`); `image_emoji` → URL della
/// PNG, `color` → colore opzionale della card.
extension CuisineDtoMapper on CuisineDto {
  Cuisine toEntity() {
    return Cuisine(
      id: id,
      name: nameIt ?? name ?? nameEng ?? engLabel ?? '',
      imageEmojiUrl: imageEmoji ?? '',
      colorHex: color,
    );
  }
}
