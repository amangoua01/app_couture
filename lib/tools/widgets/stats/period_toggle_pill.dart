import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

/// Sélecteur de période "pill" blanc avec l'onglet actif en vert primary —
/// se dimensionne sur la largeur disponible plutôt que sur l'écran entier,
/// pour rester correct qu'il soit seul ou à côté d'un bouton calendrier.
class PeriodTogglePill extends StatelessWidget {
  final List<String> labels;
  final int initialIndex;
  final ValueChanged<int?> onToggle;

  const PeriodTogglePill({
    super.key,
    required this.labels,
    required this.initialIndex,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ToggleSwitch(
            initialLabelIndex: initialIndex,
            totalSwitches: labels.length,
            minWidth: (constraints.maxWidth / labels.length) - 2,
            cornerRadius: 25,
            activeBgColor: const [AppColors.primary],
            inactiveBgColor: Colors.white,
            activeFgColor: Colors.white,
            inactiveFgColor: Colors.grey[600],
            labels: labels,
            onToggle: onToggle,
          );
        },
      ),
    );
  }
}
