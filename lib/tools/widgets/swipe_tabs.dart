import 'package:flutter/material.dart';

/// Contenu d'onglets qu'on change aussi en balayant l'écran : glisser vers la
/// gauche passe à l'onglet suivant, vers la droite au précédent. Le contenu
/// glisse dans le sens du geste (comme un `TabBarView`), pour les sélecteurs
/// maison qui n'en utilisent pas.
///
/// [values] est la liste ordonnée des onglets, [selection] l'onglet courant.
/// Le geste ne s'active que sur un balayage franc, pour ne pas gêner le
/// défilement vertical ni les listes horizontales internes.
class SwipeTabs<T> extends StatefulWidget {
  final List<T> values;
  final T selection;
  final ValueChanged<T> onChanged;
  final Widget child;

  const SwipeTabs({
    super.key,
    required this.values,
    required this.selection,
    required this.onChanged,
    required this.child,
  });

  @override
  State<SwipeTabs<T>> createState() => _SwipeTabsState<T>();
}

class _SwipeTabsState<T> extends State<SwipeTabs<T>> {
  /// +1 quand on avance vers un onglet de droite, -1 vers la gauche.
  int _direction = 1;

  @override
  void didUpdateWidget(covariant SwipeTabs<T> old) {
    super.didUpdateWidget(old);
    final from = widget.values.indexOf(old.selection);
    final to = widget.values.indexOf(widget.selection);
    if (from != to && from >= 0 && to >= 0) {
      _direction = to > from ? 1 : -1;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    final v = details.primaryVelocity ?? 0;
    final index = widget.values.indexOf(widget.selection);
    if (index < 0) return;
    if (v < -350 && index < widget.values.length - 1) {
      widget.onChanged(widget.values[index + 1]);
    } else if (v > 350 && index > 0) {
      widget.onChanged(widget.values[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentKey = ValueKey<T>(widget.selection);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final entrant = child.key == currentKey;
          final decalage = 0.16 * _direction;
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(entrant ? decalage : -decalage, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(key: currentKey, child: widget.child),
      ),
    );
  }
}
