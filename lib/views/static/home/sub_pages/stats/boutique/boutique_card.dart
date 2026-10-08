import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/stats/gradient_overview_panel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BoutiqueCard extends StatelessWidget {
  final Kpis kpis;
  const BoutiqueCard({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    return GradientOverviewPanel(
      title: "Vue d'ensemble",
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
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
      rows: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CHIFFRE D'AFFAIRES",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const Gap(6),
            Text(
              kpis.chiffreAffaires.toAmount(unit: "Fcfa"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
        KpiTileRow(
          tiles: [
            KpiTile(
              label: "Recettes nettes",
              value: kpis.recettesNettes.value.toAmount(unit: "Fcfa"),
            ),
            KpiTile(
              label: "Ticket moyen",
              value: kpis.ticketMoyen.value.toAmount(unit: "Fcfa"),
              onInfoTap: () => _showTicketMoyenInfo(context),
            ),
          ],
        ),
        KpiTileRow(
          tiles: [
            KpiTile(
              label: "Taux de recouvrement",
              value: "${kpis.tauxRecouvrement ?? 0}%",
            ),
            KpiTile(
              label: "Stock total boutique",
              value: "${kpis.stockTotalBoutique ?? 0}",
            ),
          ],
        ),
      ],
    );
  }

  void _showTicketMoyenInfo(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Ticket moyen"),
            content: const Text(
              "Montant moyen encaissé par vente sur la période sélectionnée "
              "(chiffre d'affaires ÷ nombre de ventes).",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Compris"),
              ),
            ],
          ),
    );
  }
}
