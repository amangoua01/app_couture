import 'package:ateliya/tools/widgets/app_tab_bar.dart';
import 'package:flutter/material.dart';

class CTabBar extends StatelessWidget {
  final List<String> tabs;
  final EdgeInsetsGeometry margin;
  final void Function(int)? onTabChanged;

  /// Pour une liste d'onglets aux libellés longs (ex: "Soldées, non
  /// terminées") : largeur fixe = texte tronqué. En scrollable, chaque
  /// onglet prend la largeur de son contenu et reste lisible en entier.
  final bool isScrollable;

  const CTabBar({
    super.key,
    required this.tabs,
    this.margin = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.onTabChanged,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppTabBar(
      margin: margin,
      isScrollable: isScrollable,
      onTap: onTabChanged,
      tabs: [for (final t in tabs) AppTabItem(t)],
    );
  }
}
