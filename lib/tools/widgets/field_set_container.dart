import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FieldSetContainer extends StatelessWidget {
  final List<Widget> children;
  const FieldSetContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
