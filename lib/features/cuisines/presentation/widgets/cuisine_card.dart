import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/cuisine.dart';

/// Card di una cucina nella griglia: emoji PNG centrata in alto + nome sotto.
///
/// Fill surface, angoli morbidi, label centrata su massimo 2 righe (es.
/// "Senza glutine"). L'emoji è una PNG remota caricata con
/// `cached_network_image`, con placeholder durante il download e fallback a
/// icona se l'URL manca o fallisce.
class CuisineCard extends StatelessWidget {
  const CuisineCard({super.key, required this.cuisine});

  final Cuisine cuisine;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CuisineEmoji(url: cuisine.imageEmojiUrl),
          const SizedBox(height: AppSpacing.sm),
          Text(
            cuisine.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.smallLabel.copyWith(
              color: AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

/// Emoji della cucina: PNG remota con placeholder/errore, o fallback se assente.
class _CuisineEmoji extends StatelessWidget {
  const _CuisineEmoji({required this.url});

  final String url;

  static const double _size = 44;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const _EmojiFallback(size: _size);

    return CachedNetworkImage(
      imageUrl: url,
      width: _size,
      height: _size,
      fit: BoxFit.contain,
      placeholder: (_, _) => const SizedBox.square(
        dimension: _size,
        child: Center(
          child: SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.lightGray,
            ),
          ),
        ),
      ),
      errorWidget: (_, _, _) => const _EmojiFallback(size: _size),
    );
  }
}

/// Icona neutra usata quando l'emoji remota manca o non si carica.
class _EmojiFallback extends StatelessWidget {
  const _EmojiFallback({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.restaurant_rounded,
      size: size,
      color: AppColors.lightGray,
    );
  }
}
