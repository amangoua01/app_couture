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

/// Barre de navigation flottante : l'onglet actif s'élargit en pastille
/// colorée avec son libellé, les autres restent compacts (icône seule).
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
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < elements.length; i++)
              _Onglet(
                element: elements[i],
                actif: i == indexActif,
                compact: elements.length > 4,
                onTap: () => onChange(i),
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

  /// Cinq onglets ou plus : marges réduites pour tenir sur les petits écrans.
  final bool compact;

  const _Onglet({
    required this.element,
    required this.actif,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: actif ? (compact ? 13 : 16) : (compact ? 9 : 12),
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: actif ? AppColors.primary : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: actif
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            element.icone0nglet ??
                AnimatedScale(
                  scale: actif ? 1.1 : 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    actif ? (element.iconeActive ?? element.icone) : element.icone,
                    size: 22,
                    color: actif ? Colors.white : Colors.grey[400],
                  ),
                ),
            // Le libellé s'ouvre et se referme en douceur
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              child: actif
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        element.libelle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
