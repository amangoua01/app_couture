import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Bordures et styles partagés par tous les champs de saisie.
///
/// Point unique de réglage : modifier une valeur ici se répercute sur les
/// champs texte, dates, sélecteurs simples et multiples de toute l'app.
abstract class FieldBorder {
  static const double radius = 16;

  static OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: color, width: width),
      );

  /// État par défaut : un filet neutre et discret — la couleur de marque
  /// n'apparaît qu'au focus, pour que son apparition soit elle-même le
  /// signal visuel (plutôt que d'avoir des champs colorés en permanence).
  static final enabled = _border(AppColors.fieldBorder, 1.3);

  /// État actif : la couleur de marque entre en scène, trait épaissi pour
  /// bien marquer le champ actuellement édité.
  static final focused = _border(AppColors.primary, 1.8);

  /// Valeur choisie dans un sélecteur (sans y être pour autant "en focus") :
  /// une teinte de marque diluée fait comprendre d'un coup d'œil que ce
  /// champ n'est plus vide, sans le colorer aussi franchement qu'au focus.
  static final selected = _border(AppColors.primary.withValues(alpha: 0.45), 1.4);

  static final error = _border(AppColors.danger, 1.2);

  static final focusedError = _border(AppColors.danger, 1.6);

  /// Champ non modifiable : plus clair pour ne pas attirer l'œil.
  static final disabled = _border(AppColors.ligthGrey);

  static final enabledSearch = OutlineInputBorder(
    borderRadius: BorderRadius.circular(33),
    borderSide: const BorderSide(color: AppColors.primary),
  );

  /// Libellé affiché au-dessus du champ.
  static const labelStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: -0.1,
  );

  static final hintStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey[400],
    fontWeight: FontWeight.w400,
  );

  static const contentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 15,
  );

  /// Fond d'un champ désactivé, pour le distinguer d'un champ saisissable.
  static final disabledFillColor = Colors.grey[50];
}
