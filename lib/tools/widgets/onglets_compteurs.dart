import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

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

/// Sélecteur à compteurs sur toute la largeur : le nombre en grand, le libellé
/// dessous, un trait doré sous l'onglet actif, un filet fin en bas. À plat,
/// sans pastille ni ombre.
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
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 10),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDDE3DF))),
      ),
      child: Row(
        children: [
          for (final o in onglets)
            Expanded(
              child: _Onglet(
                libelle: o.libelle,
                nombre: o.nombre,
                actif: o.valeur == selection,
                accent: o.accent,
                onTap: () {
                  if (o.valeur != selection) HapticFeedback.selectionClick();
                  onChanged(o.valeur);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Onglet extends StatelessWidget {
  final String libelle;
  final int nombre;
  final bool actif;
  final Color? accent;
  final VoidCallback onTap;

  const _Onglet({
    required this.libelle,
    required this.nombre,
    required this.actif,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final alerte = accent != null && nombre > 0;
    final couleurNombre = alerte ? accent! : AppColors.textDark;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.only(top: 8, bottom: 9),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: actif ? AppColors.secondary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$nombre',
              style: TextStyle(
                fontSize: 19,
                height: 1.1,
                fontWeight: actif ? FontWeight.w800 : FontWeight.w600,
                color: couleurNombre,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const Gap(2),
            Text(
              libelle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: actif ? FontWeight.w700 : FontWeight.w500,
                color: actif ? AppColors.textDark : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
