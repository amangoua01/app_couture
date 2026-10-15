import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
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

/// Sélecteur segmenté sur toute la largeur : le nombre en grand, le libellé
/// dessous, un indicateur qui glisse d'un onglet à l'autre.
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
    final index = onglets.indexWhere((e) => e.valeur == selection);

    return Container(
      margin: margin,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final largeur = box.maxWidth / onglets.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                left: largeur * (index < 0 ? 0 : index),
                top: 0,
                bottom: 0,
                width: largeur,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              Row(
                children: [
                  for (final o in onglets)
                    Expanded(
                      child: _Onglet(
                        libelle: o.libelle,
                        nombre: o.nombre,
                        actif: o.valeur == selection,
                        accent: o.accent,
                        onTap: () => onChanged(o.valeur),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
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
    final alerte = !actif && accent != null && nombre > 0;
    final couleurNombre = actif
        ? Colors.white
        : alerte
            ? accent!
            : AppColors.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 18,
                height: 1.1,
                fontWeight: FontWeight.w800,
                color: couleurNombre,
              ),
              child: Text('$nombre'),
            ),
            const Gap(2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: actif
                    ? Colors.white.withValues(alpha: 0.85)
                    : Colors.grey.shade600,
              ),
              child: Text(libelle, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
