import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Un onglet de la barre de navigation flottante.
class ElementNavigation {
  final IconData icone;
  final IconData? iconeActive;
  final Widget? icone0nglet;
  final String libelle;

  const ElementNavigation({
    required this.icone,
    this.iconeActive,
    this.icone0nglet,
    required this.libelle,
  });
}

/// Barre de navigation du bas : pleine largeur, un filet en haut, des icônes
/// au-dessus de leur libellé. L'onglet actif passe en icône pleine, en vert
/// foncé, avec un trait doré qui se déploie au-dessus. Pas d'ombre.
class FloatingNavBar extends StatelessWidget {
  final List<ElementNavigation> elements;
  final int indexActif;
  final ValueChanged<int> onChange;

  const FloatingNavBar({
    super.key,
    required this.elements,
    required this.indexActif,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFDDE3DF))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < elements.length; i++)
              Expanded(
                child: _Onglet(
                  element: elements[i],
                  actif: i == indexActif,
                  onTap: () => onChange(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Onglet extends StatelessWidget {
  final ElementNavigation element;
  final bool actif;
  final VoidCallback onTap;

  const _Onglet({
    required this.element,
    required this.actif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final couleur = actif ? AppColors.primary : const Color(0xFF8A948F);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            height: 3,
            width: actif ? 28 : 0,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 9),
          element.icone0nglet ??
              Icon(
                actif ? (element.iconeActive ?? element.icone) : element.icone,
                size: 25,
                color: couleur,
              ),
          const SizedBox(height: 4),
          Text(
            element.libelle,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: actif ? FontWeight.w700 : FontWeight.w500,
              color: couleur,
            ),
          ),
          const SizedBox(height: 9),
        ],
      ),
    );
  }
}
