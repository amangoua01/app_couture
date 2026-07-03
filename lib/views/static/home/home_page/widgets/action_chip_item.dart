import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class ActionChipItem extends StatelessWidget {
  final String label;
  final String? svgPath;
  final IconData? icon;
  final Color color;
  final VoidCallback onTap;

  const ActionChipItem({
    super.key,
    required this.label,
    this.svgPath,
    this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: svgPath != null
                    ? SvgPicture.asset(
                        svgPath!,
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          color,
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(
                        icon,
                        color: color,
                        size: 22,
                      ),
              ),
            ),
            const Gap(8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
