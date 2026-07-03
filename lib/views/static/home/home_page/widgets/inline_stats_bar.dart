import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class InlineStatsBar extends StatelessWidget {
  final List<StatItem> items;

  const InlineStatsBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.fieldBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: List.generate(items.length * 2 - 1, (index) {
            if (index.isOdd) {
              return Container(
                width: 1,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: AppColors.fieldBorder.withValues(alpha: 0.6),
              );
            }
            final item = items[index ~/ 2];
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: item.color, size: 16),
                  ),
                  const Gap(8),
                  Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
