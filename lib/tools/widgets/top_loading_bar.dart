import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:flutter/material.dart';

/// Filet de chargement tout en haut d'un écran : visible tant que des données
/// sont en cours de chargement, même si d'anciennes données restent affichées,
/// pour qu'on sache qu'elles vont peut-être changer.
class TopLoadingBar extends StatelessWidget {
  final bool visible;
  const TopLoadingBar({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: visible ? 1 : 0,
        child: const SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            minHeight: 3,
            backgroundColor: Colors.transparent,
            color: StatsStyle.gold,
          ),
        ),
      ),
    );
  }
}
