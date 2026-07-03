import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuildSummuryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;
  const BuildSummuryItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const Gap(12),
        Expanded(
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary.withValues(alpha: 0.65),
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        ),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isBold ? color : AppColors.primary)),
      ],
    ),
  );
  }
}