import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SoldeCard extends StatelessWidget {
  final String icon;
  final String value;
  const SoldeCard({required this.icon, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            icon,
            width: 14,
            height: 14,
            color: Colors.white,
          ),
        ),
        const Gap(10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
