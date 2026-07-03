import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/build_card_activity.dart';
import 'package:ateliya/tools/widgets/build_mouvement_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CaisseStockSection extends StatelessWidget {
  final Kpis kpis;
  const CaisseStockSection({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Caisse & Stock",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.2)),
        const Gap(12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.3,
          children: [
            BuildCardActivity(
                icon: Icons.account_balance_wallet_outlined,
                value: kpis.caisse.toAmount(),
                label: "Solde caisse (FCFA)",
                iconColor: AppColors.primary),
            BuildCardActivity(
                icon: Icons.show_chart,
                value: "${kpis.tauxRecouvrement ?? 0}%",
                label: "Taux recouvrement",
                iconColor: AppColors.secondary),
            BuildCardActivity(
                icon: Icons.inventory_2_outlined,
                value: (kpis.stockTotalBoutique ?? 0).toString(),
                label: "Stock total boutique",
                iconColor: AppColors.green),
            BuildMouvementCard(
                entree: kpis.totalMouvementsEntrants.toAmount(),
                sortie: kpis.totalMouvementsSortants.toAmount(),
                label: "Mouvements (FCFA)"),
          ],
        ),
      ],
    );
  }
}
