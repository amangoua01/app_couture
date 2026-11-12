import 'package:flutter/material.dart';

/// Nombre qui « compte » jusqu'à sa valeur (et rejoue l'animation quand la
/// valeur change, par exemple en passant de Jour à Mois).
class AnimatedCount extends StatelessWidget {
  final num value;
  final String Function(num) format;
  final TextStyle? style;
  final Duration duration;

  const AnimatedCount({
    super.key,
    required this.value,
    required this.format,
    this.style,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => Text(format(v), style: style),
    );
  }
}
