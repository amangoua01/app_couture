import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/build_summury_item.dart';
import 'package:ateliya/tools/widgets/section_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FinancialSummarySection extends StatelessWidget {
  final StatistiquesBoutique data;
  const FinancialSummarySection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: "Résumé financier",
      child: Container(
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ...?(data.activitesBoutique?.map((act) => BuildSummuryItem(
                label: act.activite ?? "",
                value: "${(act.revenus ?? 0).toAmount()} FCFA",
                color: AppColors.primary))),
            BuildSummuryItem(
                label: "Dépenses",
                value: "-${data.kpis.totalDepenses.toAmount()} FCFA",
                color: AppColors.secondary),
            Divider(
                height: 28,
                color: AppColors.fieldBorder.withValues(alpha: 0.6)),
            BuildSummuryItem(
                label: "Recettes nettes",
                value: "${(data.kpis.recettesNettes ?? 0).toAmount()} FCFA",
                color: AppColors.green,
                isBold: true),
          ],
        ),
      ),
    );
  }
}
