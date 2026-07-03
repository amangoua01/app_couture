import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/widgets/empty_page.dart';
import 'package:ateliya/views/controllers/home/statistique_entreprise_page_vctl.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/entreprise/entreprise_stats_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StatistiqueEntreprisePage extends StatelessWidget {
  const StatistiqueEntreprisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: StatistiqueEntreprisePageVctl(),
        builder: (ctl) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Statistiques Globales"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ToggleSwitch(
                            inactiveBgColor: AppColors.secondary,
                            activeBgColor: const [AppColors.primary],
                            activeFgColor: Colors.white,
                            inactiveFgColor:
                                Colors.white.withValues(alpha: 0.7),
                            minWidth: 96.0,
                            cornerRadius: 14,
                            initialLabelIndex: ctl.selectedIndex,
                            labels: const ["Jour", "Mois", "Année"],
                            onToggle: (index) {
                              ctl.selectedIndex = index ?? 0;
                              ctl.fetchStats(indexPeriod: index ?? 0);
                            },
                          ),
                          const Gap(10),
                          IconButton(
                            onPressed: () => ctl.pickDateRange(context),
                            icon: const Icon(
                              Icons.calendar_month,
                              color: AppColors.primary,
                            ),
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
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: AppColors.primary),
                            ),
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
                                    color:
                                        AppColors.primary.withValues(alpha: 0.1),
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
                        : EntrepriseStatsSubPage(
                                data: ctl.data,
                                onRefresh: ctl.fetchStats,
                              ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
