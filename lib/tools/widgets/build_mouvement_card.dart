import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuildMouvementCard extends StatelessWidget {
  final String entree;
  final String sortie;
  final String label;
  const BuildMouvementCard(
      {super.key,
      required this.entree,
      required this.sortie,
      required this.label});

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
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.sync, color: AppColors.primary, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Entrées: ",
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary.withValues(alpha: 0.5))),
                  Text("+ $entree",
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.green)),
                ],
              ),
              Row(
                children: [
                  Text("Sorties: ",
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary.withValues(alpha: 0.5))),
                  Text("- $sortie",
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary)),
                ],
              ),
              const Gap(2),
              Text("Mouvements (Fcfa)",
                  style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primary.withValues(alpha: 0.45))),
            ],
          ),
        ],
      ),
    );
  }
}
