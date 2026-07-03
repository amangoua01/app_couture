import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BuildCardActivity extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  const BuildCardActivity({super.key, required this.icon, required this.value, required this.label, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: AppColors.primary.withValues(alpha: 0.05),
      ),
      boxShadow: [
        BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4))
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: -0.4)),
            ),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary.withValues(alpha: 0.5))),
          ],
        ),
      ],
    ),
  );
  }
}
