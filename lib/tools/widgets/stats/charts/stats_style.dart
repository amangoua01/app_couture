import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Repères graphiques communs aux écrans de statistiques : encre verte,
/// or, filets fins. Pas de dégradé, pas d'ombre portée.
abstract class StatsStyle {
  static const ink = AppColors.primary;
  static const gold = AppColors.secondary;
  static const muted = AppColors.textMuted;
  static const dark = AppColors.textDark;
  static const hairline = Color(0xFFDDE3DF);

  /// Chiffres alignés (tabulaires) : les colonnes de montants restent droites.
  static const _tabular = [FontFeature.tabularFigures()];

  static TextStyle number(double size, {Color color = dark}) => TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 1.05,
        letterSpacing: -0.5,
        color: color,
        fontFeatures: _tabular,
      );

  /// Petit libellé en capitales espacées.
  static TextStyle caps({Color color = muted}) => TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        color: color,
      );

  static const rule = Border(bottom: BorderSide(color: hairline));
}
