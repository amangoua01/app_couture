import 'package:flutter/material.dart';

/// Rétrécit légèrement son enfant pendant l'appui : retour tactile sur les
/// cartes et boutons, sans dépendance à un package d'animation externe.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double echelle;

  const Pressable({super.key, required this.child, this.onTap, this.echelle = 0.97});

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _appuye = false;

  void _changer(bool valeur) {
    if (widget.onTap != null && _appuye != valeur) setState(() => _appuye = valeur);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _changer(true),
      onTapUp: (_) => _changer(false),
      onTapCancel: () => _changer(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _appuye ? widget.echelle : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
