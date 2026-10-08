import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Photo d'un article de boutique.
///
/// Deux raisons à ce composant plutôt qu'un `Image.network` direct :
///
/// 1. **Cache disque.** `Image.network` ne garde ses images qu'en mémoire :
///    chaque démarrage de l'application retéléchargeait toutes les photos du
///    stock, ce qui dominait le temps d'affichage de la boutique.
/// 2. **Décodage à la taille utile.** Une photo de produit fait souvent plus
///    de mille pixels de large ; la décoder entière pour l'afficher dans une
///    vignette de 46 px coûte du temps et beaucoup de mémoire. [largeurAffichee]
///    indique la taille réellement rendue.
class PhotoProduit extends StatelessWidget {
  final String? url;
  final double largeurAffichee;
  final BoxFit fit;

  /// Image de repli quand l'article n'a pas de photo.
  final Widget? placeholder;

  const PhotoProduit({
    super.key,
    required this.url,
    required this.largeurAffichee,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final lien = url;
    if (lien == null || lien.isEmpty) return _repli();

    // On décode au double de la taille affichée pour rester net sur les écrans
    // à forte densité, sans aller jusqu'à la résolution d'origine.
    final largeurDecodage =
        (largeurAffichee * MediaQuery.devicePixelRatioOf(context))
            .clamp(80, 900)
            .round();

    return CachedNetworkImage(
      imageUrl: lien,
      fit: fit,
      memCacheWidth: largeurDecodage,
      fadeInDuration: const Duration(milliseconds: 180),
      placeholder: (_, __) => Container(color: const Color(0xFFF2F4F3)),
      errorWidget: (_, __, ___) => _repli(),
    );
  }

  Widget _repli() =>
      placeholder ??
      Container(
        color: const Color(0xFFF4F6F5),
        child: Icon(
          Icons.checkroom_rounded,
          size: largeurAffichee * 0.45,
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      );
}
