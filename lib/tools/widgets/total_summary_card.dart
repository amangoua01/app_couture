import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Carte de synthèse en tête d'une liste financière : montant total à
/// gauche, nombre d'éléments à droite. Utilisée pour "Mes dépenses" et
/// "Charges récurrentes" afin que les deux écrans partagent la même
/// lecture d'ensemble.
class TotalSummaryCard extends StatelessWidget {
  final String label;
  final double total;
  final int count;
  final String countLabel;

  /// Dépenses réelles (sorties d'argent) : affichées en rouge avec un
  /// signe "-". Charges récurrentes : simple montant de référence, en
  /// couleur neutre.
  final bool negative;

  const TotalSummaryCard({
    super.key,
    required this.label,
    required this.total,
    required this.count,
    required this.countLabel,
    this.negative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                ),
                const Gap(4),
                Text(
                  "${negative ? '- ' : ''}${total.round().toAmount()}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: negative ? const Color(0xFFB91C1C) : AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$count",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
              Text(
                countLabel,
                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
