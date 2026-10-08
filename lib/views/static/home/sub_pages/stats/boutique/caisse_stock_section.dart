import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/build_card_activity.dart';
import 'package:ateliya/tools/widgets/build_mouvement_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Taux recouvrement et Stock total boutique sont déjà dans le panneau
/// "Vue d'ensemble" ci-dessus : seuls la caisse et les mouvements (absents
/// de ce panneau) restent ici, pour éviter d'afficher deux fois les mêmes
/// chiffres sur un même écran.
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
