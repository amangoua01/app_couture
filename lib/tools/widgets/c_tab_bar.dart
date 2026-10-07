import 'package:ateliya/tools/constants/app_colors.dart';
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
    this.margin = const EdgeInsets.fromLTRB(16, 12, 16, 8),
    this.onTabChanged,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF062A22).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        isScrollable: isScrollable,
        tabAlignment: isScrollable ? TabAlignment.start : null,
        labelPadding:
            isScrollable
                ? const EdgeInsets.symmetric(horizontal: 14)
                : null,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.primary,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: onTabChanged,
        tabs: tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }
}
