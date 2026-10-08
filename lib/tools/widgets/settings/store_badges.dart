import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Marques Google Play et App Store.
///
/// Les glyphes viennent de Font Awesome, qui reprend la silhouette officielle
/// de chaque marque — un robot Android ou une pomme ne désignent pas les
/// boutiques elles-mêmes. Le triangle Play Store étant quadricolore, un dégradé
/// aux quatre teintes Google lui est appliqué par-dessus le glyphe, faute de
/// pouvoir colorer séparément les faces d'une police monochrome.
class PlayStoreMark extends StatelessWidget {
  final double size;
  const PlayStoreMark({super.key, this.size = 21});

  static const _couleursGoogle = [
    Color(0xFF00A0FF), // bleu
    Color(0xFF00E676), // vert
    Color(0xFFFFCE00), // jaune
    Color(0xFFFF3A44), // rouge
  ];

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _couleursGoogle,
        stops: [0.0, 0.38, 0.68, 1.0],
      ).createShader(bounds),
      child: FaIcon(
        FontAwesomeIcons.googlePlay,
        size: size,
        color: Colors.white,
      ),
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
