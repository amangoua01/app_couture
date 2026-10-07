import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color.fromRGBO(10, 58, 48, 1);
  static const Color secondary = Color.fromRGBO(209, 158, 73, 1);
  static const Color yellow = Color.fromRGBO(212, 175, 55, 1);
  static const Color greenLight = Color.fromRGBO(164, 180, 148, 1);
  static const Color greenLight2 = Color.fromRGBO(208, 243, 246, 1);
  static const Color green = Color.fromRGBO(124, 152, 133, 1);
  static const Color fieldBorder = Color.fromRGBO(226, 226, 226, 1);
  static const Color ligthGrey = Color.fromRGBO(234, 234, 234, 1);

  /// Erreurs de validation et actions destructrices.
  static const Color danger = Color(0xFFDC2626);

  /// Texte principal : un gris très sombre, plus doux qu'un noir pur.
  static const Color textDark = Color(0xFF111827);

  /// Texte secondaire (sous-titres, libellés d'appoint).
  static const Color textMuted = Color(0xFF6B7280);

  /// Fond des écrans, pour détacher les cartes blanches. Volontairement plus
  /// marqué qu'un simple blanc cassé : la différence doit être visible au
  /// premier coup d'œil, pas seulement en comparant deux captures côte à côte.
  static const Color scaffoldBg = Color(0xFFEDF2EF);

  /// Nuance plus sombre de [primary], pour les dégradés de bannières.
  static const Color primaryDark = Color(0xFF062720);
}
