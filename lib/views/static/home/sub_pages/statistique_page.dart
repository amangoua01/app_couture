import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/empty_page.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/tools/widgets/stats/period_toggle_pill.dart';
import 'package:ateliya/views/controllers/home/statistique_page_vctl.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/atelier/atelier_stats_sub_page.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/boutique/boutique_stats_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class StatistiquePage extends StatelessWidget {
  const StatistiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: StatistiquePageVctl(),
        builder: (ctl) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: MainAppBar(
              enterpriseTitle: ctl.getEntite().value.libelle.value,
              notifCount: ctl.nbUnreadNotifs,
              onSelectionChanged: () {
                ctl.fetchStats(indexPeriod: ctl.periodIndex);
              },
              onNotifRefresh: () => ctl.loadUnreadCount(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: PeriodTogglePill(
                              labels: const ["Jour", "Mois", "Année"],
                              initialIndex: ctl.selectedIndex.clamp(0, 2),
                              onToggle: (index) {
                                ctl.selectedIndex = index ?? 0;
                                ctl.fetchStats(indexPeriod: index ?? 0);
                              },
                            ),
                          ),
                          const Gap(10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: IconButton(
                                onPressed: () => ctl.pickDateRange(context),
                                icon: const Icon(
                                  Icons.calendar_month,
                                  color: AppColors.primary,
                                )),
                          ),
                        ],
                      ),
                      if (ctl.selectedIndex == 3) ...[
                        const Gap(12),
                        GestureDetector(
                          onTap: () => ctl.pickDateRange(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular((50)),
                                border: Border.all(
                                  color: AppColors.primary,
                                )),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: AppColors.primary, size: 16),
                                const Gap(8),
                                Text(
                                  ctl.dateRange.toFrenchDate,
                                  style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                                const Gap(8),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.edit,
                                      color: AppColors.primary
                                          .withValues(alpha: 0.6),
                                      size: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Expanded(
                    child: ctl.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Builder(
                            builder: (context) {
                              final type = ctl.getEntite().value.type;
                              switch (type) {
                                case EntiteEntrepriseType.boutique:
                                  return BoutiqueStatsSubPage(ctl);
                                case EntiteEntrepriseType.succursale:
                                  return AtelierStatsSubPage(ctl);
                                default:
                                  return const EmptyPage(
                                    icon: Icons.query_stats,
                                    title: "Aucune entité sélectionnée",
                                    subtitle:
                                        "Sélectionnez une entité pour voir les statistiques",
                                  );
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
