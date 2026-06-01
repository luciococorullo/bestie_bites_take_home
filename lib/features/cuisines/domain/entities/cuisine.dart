import 'package:freezed_annotation/freezed_annotation.dart';

part 'cuisine.freezed.dart';

/// Cucina disponibile in una città, pronta per la griglia.
///
/// Entità *pura* (niente JSON). [imageEmojiUrl] è la PNG pubblica da caricare
/// con `cached_network_image`; [colorHex] è opzionale (colore per-card, polish).
@freezed
abstract class Cuisine with _$Cuisine {
  const factory Cuisine({
    required int id,
    required String name,
    required String imageEmojiUrl,
    String? colorHex,
  }) = _Cuisine;
}
