import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/build_card_activity.dart';
import 'package:ateliya/tools/widgets/section_container.dart';
import 'package:flutter/material.dart';

class AtelierActiviteSection extends StatelessWidget {
  final StatistiquesBoutique data;
  const AtelierActiviteSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final activities = data.activitesBoutique ?? [];
    int factures = 0;
    int mesures = 0;

    for (var act in activities) {
      if (act.activite?.toLowerCase().contains("factures") ?? false) {
        factures = act.nombre ?? 0;
      }
      if (act.activite?.toLowerCase().contains("mesures") ?? false) {
        mesures = act.nombre ?? 0;
      }
    }

    return SectionContainer(
      title: "Activité atelier",
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.3,
        children: [
          BuildCardActivity(
              icon: Icons.receipt_long_outlined,
              value: factures.toString(),
              label: "Factures clients",
              iconColor: AppColors.secondary),
          BuildCardActivity(
              icon: Icons.edit_outlined,
              value: mesures.toString(),
              label: "Prises de mesures",
              iconColor: AppColors.primary),
        ],
      ),
    );
  }
}
