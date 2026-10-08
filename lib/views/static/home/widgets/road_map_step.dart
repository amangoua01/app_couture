import 'package:flutter/material.dart';

class RoadmapStep {
  final String number;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool enabled;

  /// Étape déjà accomplie (ex: la boutique existe déjà). Distincte de
  /// [enabled] : une étape peut être verrouillée (pas encore accessible),
  /// disponible (à faire maintenant) ou terminée — trois états visuels
  /// différents, alors qu'avant seul "enabled" existait et confondait
  /// "verrouillée" et "déjà faite" dans le même gris.
  final bool done;

  const RoadmapStep({
    required this.number,
    required this.title,
    required this.description,
    required this.onTap,
    this.enabled = true,
    this.done = false,
  });
}
