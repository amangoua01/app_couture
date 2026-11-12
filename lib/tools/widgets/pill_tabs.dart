import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Un segment : libellé, icône facultative, compteur facultatif.
class PillTab {
  final String label;
  final IconData? icon;
  final int? count;
  const PillTab(this.label, {this.icon, this.count});
}

/// Sélecteur en pilule : une capsule teintée contenant une pastille vert
/// foncé qui glisse d'un segment à l'autre. Même langage que les boutons
/// ronds de l'application, à plat (sans ombre ni dégradé).
///
/// [stacked] met le compteur en grand au-dessus du libellé (listes filtrées) ;
/// sinon le compteur est une petite bulle à côté du libellé.
class PillTabs extends StatelessWidget {
  final List<PillTab> tabs;
  final int index;
  final ValueChanged<int> onChanged;
  final bool stacked;
  final EdgeInsetsGeometry margin;

  const PillTabs({
    super.key,
    required this.tabs,
    required this.index,
    required this.onChanged,
    this.stacked = false,
    this.margin = const EdgeInsets.fromLTRB(16, 4, 16, 10),
  });

  static Color get _fond => AppColors.primary.withValues(alpha: 0.07);

  @override
  Widget build(BuildContext context) {
    final hauteur = stacked ? 60.0 : 46.0;
    return Container(
      margin: margin,
      height: hauteur,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _fond,
        borderRadius: BorderRadius.circular(hauteur),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final largeur = box.maxWidth / tabs.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                left: largeur * index.clamp(0, tabs.length - 1),
                top: 0,
                bottom: 0,
                width: largeur,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(hauteur),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < tabs.length; i++)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (i != index) HapticFeedback.selectionClick();
                          onChanged(i);
                        },
                        child: Center(
                          child: _Contenu(
                            tab: tabs[i],
                            actif: i == index,
                            stacked: stacked,
                          ),
                        ),
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

class _Contenu extends StatelessWidget {
  final PillTab tab;
  final bool actif;
  final bool stacked;
  const _Contenu({
    required this.tab,
    required this.actif,
    required this.stacked,
  });

  @override
  Widget build(BuildContext context) {
    final couleur = actif ? Colors.white : AppColors.primary;

    if (stacked && tab.count != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 18,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: couleur,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            child: Text('${tab.count}'),
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: actif ? Colors.white70 : AppColors.textMuted,
            ),
            child: Text(tab.label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (tab.icon != null) ...[
          Icon(tab.icon, size: 18, color: couleur),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 14,
              fontWeight: actif ? FontWeight.w700 : FontWeight.w600,
              color: couleur,
            ),
            child: Text(tab.label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
        if (tab.count != null) ...[
          const SizedBox(width: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
            decoration: BoxDecoration(
              color: actif
                  ? Colors.white.withValues(alpha: 0.2)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${tab.count}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: couleur,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
