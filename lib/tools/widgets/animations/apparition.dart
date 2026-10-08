import 'package:flutter/material.dart';

/// Fait apparaître son enfant en fondu avec un léger glissement vers le haut.
/// [delai] permet d'enchaîner plusieurs éléments (apparition en cascade,
/// voir [cascade]).
class Apparition extends StatefulWidget {
  final Widget child;
  final Duration delai;
  final Duration duree;
  final double decalage;

  const Apparition({
    super.key,
    required this.child,
    this.delai = Duration.zero,
    this.duree = const Duration(milliseconds: 550),
    this.decalage = 24,
  });

  /// Délai pour le n-ième élément d'une liste.
  static Duration cascade(int index, {int pasMs = 70, int debutMs = 0}) =>
      Duration(milliseconds: debutMs + index * pasMs);

  @override
  State<Apparition> createState() => _ApparitionState();
}

class _ApparitionState extends State<Apparition> with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(vsync: this, duration: widget.duree);
  late final Animation<double> _courbe = CurvedAnimation(parent: _ctl, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delai, () {
      if (mounted) _ctl.forward();
    });
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _courbe,
      child: widget.child,
      builder: (_, child) => Opacity(
        opacity: _courbe.value,
        child: Transform.translate(offset: Offset(0, widget.decalage * (1 - _courbe.value)), child: child),
      ),
    );
  }
}
