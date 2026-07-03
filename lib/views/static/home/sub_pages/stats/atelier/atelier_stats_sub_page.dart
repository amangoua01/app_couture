import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/statistique_page_vctl.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/atelier/atelier_activite_section.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/atelier/atelier_card.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/atelier/atelier_financial_summury_section.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/atelier/mesure_livraison_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AtelierStatsSubPage extends StatelessWidget {
  final StatistiquePageVctl ctl;
  const AtelierStatsSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.secondary,
      onRefresh: ctl.fetchStats,
      child: ListView(
        children: [
          const Gap(10),
          AtelierCard(kpis: ctl.data.kpis),
          const Gap(24),
          MesureLivraisonSection(data: ctl.data),
          const Gap(24),
          AtelierActiviteSection(data: ctl.data),
          const Gap(24),
          AtelierActiviteSection(data: ctl.data),
          const Gap(16),
          if (ctl.data.kpis.mesuresEnCours != null &&
              ctl.data.kpis.mesuresEnCours! > 0)
            _buildDeliveryAlertCard(ctl.data.kpis.mesuresEnCours!),
          const Gap(24),
          AtelierFinancialSummurySection(data: ctl.data),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _buildDeliveryAlertCard(int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenLight2.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.greenLight2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.access_time_rounded,
                color: Colors.white, size: 22),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$count mesures en cours",
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppColors.primary)),
                Text("Vérifiez le planning de production",
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary.withValues(alpha: 0.65))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
