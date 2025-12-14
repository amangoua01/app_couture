import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TextDivider extends StatelessWidget {
  final String title;
  const TextDivider(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Text(title),
          const Gap(20),
          const Expanded(child: Divider(color: AppColors.green)),
        ],
      ),
    );
  }
}
