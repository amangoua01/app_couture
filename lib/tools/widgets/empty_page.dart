import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EmptyPage extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final double sizeIcon;
  const EmptyPage(
      {super.key, this.title, this.subtitle, this.icon, this.sizeIcon = 80});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: sizeIcon,
          color: AppColors.primary,
        ),
        const Gap(20),
        Text(
          title!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            // color: Colors.grey[700],
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(10),
        Text(
          subtitle!,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}
