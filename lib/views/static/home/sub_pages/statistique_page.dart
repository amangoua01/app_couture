import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/period_stat.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/models/stat_card_item.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/notif_badge_icon.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/tools/widgets/select_dash_period_sub_page.dart';
import 'package:ateliya/views/controllers/home/statistique_page_vctl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StatistiquePage extends StatelessWidget {
  const StatistiquePage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StatistiquePageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text("Statistiques"),
            elevation: 0,
            centerTitle: true,
            actions: [
              NotifBadgeIcon(
                count: ctl.nbUnreadNotifs,
                onRefresh: () => ctl.loadUnreadCount(),
              ),
            ],
          ),
          body: PlaceholderWidget(
            condition: ctl.getEntite().value.isNotEmpty,
            placeholder: const EmptyDataWidget(
              message: "Aucune entité sélectionnée",
            ),
            child: RefreshIndicator(
              onRefresh: ctl.fetchStats,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Période Selector
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: ToggleSwitch(
                        initialLabelIndex: ctl.periodIndex,
                        totalSwitches: 4,
                        minWidth: (Get.width - 60) / 4,
                        cornerRadius: 25,
                        activeBgColor: const [AppColors.primary],
                        inactiveBgColor: Colors.white,
                        activeFgColor: Colors.white,
                        inactiveFgColor: Colors.grey[600],
                        labels:
                            PeriodStat.values.map((e) => e.libelle).toList(),
                        onToggle: (index) {
                          if (index == 3) {
                            ctl.periodIndex = index ?? 0;
                            ctl.update();
                          } else {
                            ctl.fetchStats(indexPeriod: index.value);
                          }
                        },
                      ),
                    ),
                  ),
                  PlaceholderBuilder(
                      condition: ctl.periodIndex == 3,
                      builder: () {
                        return Column(
                          children: [
                            const Gap(20),
                            GestureDetector(
                              onTap: () => CBottomSheet.show(
                                child: SelectDashPeriodSubPage(ctl.dateRange),
                              ).then((e) {
                                if (e is DateTimeRange) {
                                  ctl.dateRange = e;
                                  ctl.params.dateDebut = e.start;
                                  ctl.params.dateFin = e.end;
                                  ctl.update();
                                  ctl.fetchStats(indexPeriod: ctl.periodIndex);
                                }
                              }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            color: AppColors.primary, size: 20),
                                        const Gap(10),
                                        Text(
                                          ctl.dateRange.toFrenchDate,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_drop_down,
                                        color: AppColors.primary),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  const Gap(25),

                  // KPIs Grid
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.3,
                    ),
                    children: [
                      _buildStatCard(
                        title: "Commandes en cours",
                        value: (ctl.data.kpis.commandesEnCours).toAmount(),
                        icon: Icons.hourglass_empty,
                        color: Colors.orange,
                        item: StatCardItem(
                            title: "",
                            value: "",
                            isIncrease: false), // Dummy for now if needed
                      ),
                      _buildStatCard(
                        title: "Revenus (FCFA)",
                        value: (ctl.data.kpis.chiffreAffaires).toAmount(),
                        icon: Icons.attach_money,
                        color: Colors.green,
                        item: StatCardItem(
                            title: "", value: "", isIncrease: true),
                      ),
                      _buildStatCard(
                        title: "Nouveaux clients",
                        value: (ctl.data.kpis.clientsActifs).toAmount(),
                        icon: Icons.group_add,
                        color: Colors.blue,
                        item: StatCardItem(
                            title: "", value: "", isIncrease: true),
                      ),
                      _buildStatCard(
                        title: "Réservations",
                        value: (ctl.data.kpis.reservationsActives).toAmount(),
                        icon: Icons.event,
                        color: Colors.purple,
                        item: StatCardItem(
                            title: "", value: "", isIncrease: true),
                      ),
                      _buildStatCard(
                        title: "Total Dépenses",
                        value: (ctl.data.kpis.totalDepenses).toAmount(),
                        icon: Icons.trending_down,
                        color: Colors.red,
                        item: StatCardItem(
                            title: "", value: "", isIncrease: false),
                      ),
                      _buildStatCard(
                        title: "Total Mouvements",
                        value: (ctl.data.kpis.totalMouvements).toAmount(),
                        icon: Icons.sync_alt,
                        color: Colors.teal,
                        item: StatCardItem(
                            title: "", value: "", isIncrease: true),
                      ),
                    ],
                  ),
                  const Gap(25),

                  // Charts
                  Visibility(
                    visible: ctl.params.filtre != PeriodStat.jour,
                    child: Column(
                      children: [
                        _buildChartCard(
                          title: "Évolution du Chiffre d'Affaires",
                          color: AppColors.primary,
                          spots: List.generate(
                            ctl.data.revenusQuotidiens.length,
                            (i) => FlSpot(
                              i.toDouble(),
                              ctl.data.revenusQuotidiens[i].revenus.value
                                  .toDouble(),
                            ),
                          ),
                        ),
                        const Gap(20),
                        _buildChartCard(
                          title: "Évolution des Ventes",
                          color: AppColors.yellow,
                          spots: List.generate(
                            ctl.data.revenusQuotidiens.length,
                            (i) => FlSpot(
                              i.toDouble(),
                              ctl.data.revenusQuotidiens[i].ventes.value
                                  .toDouble(),
                            ),
                          ),
                        ),
                        const Gap(20),
                        _buildChartCard(
                          title: "Évolution des Factures",
                          color: Colors.red,
                          spots: List.generate(
                            ctl.data.revenusQuotidiens.length,
                            (i) => FlSpot(
                              i.toDouble(),
                              ctl.data.revenusQuotidiens[i].factures.value
                                  .toDouble(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required StatCardItem item, // Keep if we want to add trend later
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              // Trend indicator could go here
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Gap(2),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required Color color,
    required List<FlSpot> spots,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Gap(25),
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200],
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true, reservedSize: 30) // Show date/days?
                      ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
