import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Habillage visuel commun aux cartes de l'app (lignes de liste, groupes de
/// réglages...), pour que toute nouvelle liste ressemble aux autres sans
/// redéfinir ses propres ombres et rayons.
abstract class CardStyle {
  static const double radius = 18;

  static BoxDecoration decoration({bool selected = false}) => BoxDecoration(
    color: selected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color:
          selected
              ? AppColors.primary.withValues(alpha: 0.45)
              : AppColors.primary.withValues(alpha: 0.08),
      width: selected ? 1.4 : 1,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.07),
        blurRadius: 16,
        offset: const Offset(0, 5),
      ),
    ],
  );

  /// Un pastel de [color] : même teinte, luminosité forcée vers le clair.
  ///
  /// Un simple `withValues(alpha: ...)` sur une couleur sombre comme notre
  /// vert principal donne, une fois mélangé au blanc, un gris terne — toutes
  /// les icônes de réglages ressortaient alors de la même couleur fade. En
  /// pilotant directement la luminosité (teinte Saturation/Lightness), la
  /// couleur reste identifiable même très claire.
  static Color pastel(Color color, {double minSaturation = 0.4}) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withSaturation(hsl.saturation.clamp(minSaturation, 1.0))
        .withLightness(0.88)
        .toColor();
  }

  /// Badge d'icône (carré arrondi) pastel, dans la couleur passée.
  static BoxDecoration iconBadge(Color color) => BoxDecoration(
    color: pastel(color),
    borderRadius: BorderRadius.circular(12),
  );
}
