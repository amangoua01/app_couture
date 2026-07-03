import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/build_card_activity.dart';
import 'package:ateliya/tools/widgets/section_container.dart';
import 'package:flutter/material.dart';

class ActiviteSection extends StatelessWidget {
  final StatistiquesBoutique data;
  const ActiviteSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final activities = data.activitesBoutique ?? [];
    int ventesDirectes = 0;
    int reservationsActives = data.kpis.reservationsActives;

    for (var act in activities) {
      if (act.activite?.toLowerCase().contains("ventes directes") ?? false) {
        ventesDirectes = act.nombre ?? 0;
      }
    }
    return SectionContainer(
      title: "Activité commerciale",
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.3,
        children: [
          BuildCardActivity(
              icon: Icons.shopping_bag_outlined,
              value: ventesDirectes.toString(),
              label: "Ventes directes",
              iconColor: AppColors.primary),
          BuildCardActivity(
              icon: Icons.calendar_today_outlined,
              value: reservationsActives.toString(),
              label: "Réservations actives",
              iconColor: AppColors.secondary),
        ],
      ),
    );
  }
}
