import 'package:ateliya/tools/widgets/pill_tabs.dart';
import 'package:flutter/material.dart';

/// Un onglet du sélecteur : valeur, libellé, nombre d'éléments et couleur
/// d'alerte quand ce nombre mérite l'attention.
class OngletCompteur<T> {
  final T valeur;
  final String libelle;
  final int nombre;
  final Color? accent;

  const OngletCompteur({
    required this.valeur,
    required this.libelle,
    required this.nombre,
    this.accent,
  });
}

/// Sélecteur à compteurs sur toute la largeur : une capsule dont la pastille
/// vert foncé glisse vers l'onglet choisi ; le nombre en grand, le libellé
/// dessous. À plat, comme les boutons ronds du reste de l'application.
class OngletsCompteurs<T> extends StatelessWidget {
  final List<OngletCompteur<T>> onglets;
  final T selection;
  final ValueChanged<T> onChanged;
  final EdgeInsets margin;

  const OngletsCompteurs({
    super.key,
    required this.onglets,
    required this.selection,
    required this.onChanged,
    this.margin = const EdgeInsets.fromLTRB(16, 4, 16, 10),
  });

  @override
  Widget build(BuildContext context) {
    final index = onglets.indexWhere((e) => e.valeur == selection);
    return PillTabs(
      stacked: true,
      margin: margin,
      index: index < 0 ? 0 : index,
      onChanged: (i) => onChanged(onglets[i].valeur),
      tabs: [for (final o in onglets) PillTab(o.libelle, count: o.nombre)],
    );
  }
}
