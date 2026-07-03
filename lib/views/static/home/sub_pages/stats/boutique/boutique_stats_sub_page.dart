import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/statistique_page_vctl.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/boutique/activite_section.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/boutique/boutique_card.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/boutique/caisse_stock_section.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/boutique/financial_summary_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BoutiqueStatsSubPage extends StatelessWidget {
  final StatistiquePageVctl ctl;
  const BoutiqueStatsSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    final data = ctl.data;
    final kpis = data.kpis;

    return RefreshIndicator(
      color: AppColors.secondary,
      onRefresh: ctl.fetchStats,
      child: ListView(
        children: [
          const Gap(10),
          BoutiqueCard(kpis: kpis),
          const Gap(24),
          ActiviteSection(data: data),
          const Gap(24),
          CaisseStockSection(kpis: kpis),
          const Gap(24),
          FinancialSummarySection(data: data),
          const Gap(32),
        ],
      ),
    );
  }
}