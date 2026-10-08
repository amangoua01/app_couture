import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Intitulé discret introduisant un groupe de réglages.
class SettingSectionLabel extends StatelessWidget {
  final String label;
  const SettingSectionLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.primary.withValues(alpha: 0.45),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
