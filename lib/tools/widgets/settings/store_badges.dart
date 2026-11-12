import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Marques Google Play et App Store.
///
/// Les glyphes viennent de Font Awesome, qui reprend la silhouette officielle
/// de chaque marque — un robot Android ou une pomme ne désignent pas les
/// boutiques elles-mêmes. Le triangle Play Store est rendu en un seul vert, à
/// plat : le projet n'emploie pas de dégradé.
class PlayStoreMark extends StatelessWidget {
  final double size;
  const PlayStoreMark({super.key, this.size = 21});


  @override
  Widget build(BuildContext context) {
    return FaIcon(
      FontAwesomeIcons.googlePlay,
      size: size,
      color: const Color(0xFF01875F), // vert Google Play, à plat
    );
  }
}

class AppStoreMark extends StatelessWidget {
  final double size;
  const AppStoreMark({super.key, this.size = 22});

  /// Bleu de la vignette App Store.
  static const bleuAppStore = Color(0xFF0D96F6);

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      FontAwesomeIcons.appStoreIos,
      size: size,
      color: bleuAppStore,
    );
  }
}
