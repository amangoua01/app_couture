import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/home_windows_vctl.dart';
import 'package:flutter/material.dart';

class BuildTabItem extends StatelessWidget {
  final HomeWindowsVctl ctl;
  final int index;
  final IconData icon;
  final String label;

  const BuildTabItem({
    super.key,
    required this.ctl,
    required this.index,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = ctl.page == index;
    final color = isActive ? AppColors.primary : Colors.grey[400]!;

    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            ctl.page = index;
            ctl.update();
          },
          splashColor: AppColors.primary.withOpacity(0.05),
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isActive ? 1.12 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  size: 22,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: color,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                width: isActive ? 12 : 0,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
