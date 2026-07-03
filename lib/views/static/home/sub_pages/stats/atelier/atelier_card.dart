import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/c_card.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AtelierCard extends StatelessWidget {
  final Kpis kpis;
  const AtelierCard({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    return CCard(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CHIFFRE D'AFFAIRES ATELIER",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const Gap(8),
            Text(
              kpis.chiffreAffaires.toAmount(unit: "Fcfa"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                ),
              ),
              child: const Text(
                "Période sélectionnée",
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Gap(4),
            Divider(color: Colors.white.withValues(alpha: 0.9)),
            const Gap(4),
            Wrap(
              spacing: 18,
              runSpacing: 4,
              children: [
                _InfoRow(
                    label: "Recettes nettes : ",
                    value: (kpis.recettesNettes.value).toAmount(unit: "Fcfa")),
                _InfoRow(
                    label: "Caisse : ",
                    value: (kpis.caisse.value).toAmount(unit: "Fcfa")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55), fontSize: 12)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
