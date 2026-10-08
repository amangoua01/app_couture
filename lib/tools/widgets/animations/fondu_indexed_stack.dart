import 'package:flutter/material.dart';

/// Comme IndexedStack (chaque onglet garde son état), avec un fondu et un
/// léger zoom au changement d'onglet.
class FonduIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const FonduIndexedStack({super.key, required this.index, required this.children});

  @override
  State<FonduIndexedStack> createState() => _FonduIndexedStackState();
}

class _FonduIndexedStackState extends State<FonduIndexedStack> with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(vsync: this, duration: const Duration(milliseconds: 320))
    ..value = 1;

  @override
  void didUpdateWidget(FonduIndexedStack ancien) {
    super.didUpdateWidget(ancien);
    if (ancien.index != widget.index) _ctl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courbe = CurvedAnimation(parent: _ctl, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: courbe,
      child: ScaleTransition(
        scale: Tween(begin: 0.985, end: 1.0).animate(courbe),
        child: IndexedStack(index: widget.index, children: widget.children),
      ),
    );
  }
}
