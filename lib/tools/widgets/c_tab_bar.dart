import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CTabBar extends StatelessWidget {
  final List<String> tabs;
  final EdgeInsetsGeometry margin;
  final void Function(int)? onTabChanged;

  const CTabBar({
    super.key,
    required this.tabs,
    this.margin = const EdgeInsets.fromLTRB(16, 12, 16, 8),
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.primary.withValues(alpha: 0.6),
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
