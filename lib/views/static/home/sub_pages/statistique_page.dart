import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/views/controllers/home/statistique_page_vctl.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/atelier/atelier_stats_sub_page.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/boutique/boutique_stats_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StatistiquePage extends StatelessWidget {
  const StatistiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: StatistiquePageVctl(),
        builder: (ctl) {
          return Scaffold(
            appBar: MainAppBar(
              enterpriseTitle: ctl.getEntite().value.libelle.value,
              notifCount: ctl.nbUnreadNotifs,
              onSelectionChanged: () {
                ctl.fetchStats(indexPeriod: ctl.periodIndex);
              },
              onNotifRefresh: () => ctl.loadUnreadCount(),
            ),
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(
                    children: [
                      ToggleSwitch(
                        inactiveBgColor: Colors.white.withOpacity(0.2),
                        activeBgColor: const [AppColors.yellow],
                        activeFgColor: Colors.white,
                        inactiveFgColor: Colors.white70,
                        minWidth: 100.0,
                        cornerRadius: 12,
                        initialLabelIndex: ctl.selectedIndex,
                        labels: const ["Jour", "Mois", "Année", "Période"],
                        onToggle: (index) {
                          if (index == 3) {
                            ctl.pickDateRange(context);
                          } else {
                            ctl.selectedIndex = index ?? 0;
                            ctl.fetchStats(indexPeriod: index ?? 0);
                          }
                        },
                      ),
                      if (ctl.selectedIndex == 3) ...[
                        const Gap(10),
                        GestureDetector(
                          onTap: () => ctl.pickDateRange(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: Colors.white70, size: 16),
                                const Gap(8),
                                Text(
                                  ctl.dateRange.toFrenchDate,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Gap(8),
                                const Icon(Icons.edit,
                                    color: Colors.white70, size: 14),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: ctl.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Builder(
                          builder: (context) {
                            final type = ctl.getEntite().value.type;
                            switch (type) {
                              case EntiteEntrepriseType.boutique:
                                return BoutiqueStatsSubPage(ctl);
                              case EntiteEntrepriseType.succursale:
                                return AtelierStatsSubPage(ctl);
                              default:
                                return const Center(
                                    child: Text("Sélectionnez une entité"));
                            }
                          },
                        ),
                ),
              ],
            ),
          );
        });
  }
}
