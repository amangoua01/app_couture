import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/period_stat.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/models/stat_card_item.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
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
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StatistiquePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text("Statistiques")),
          body: PlaceholderWidget(
            condition: ctl.entite.isNotEmpty,
            placeholder: const EmptyDataWidget(
              message: "Aucune entité sélectionnée",
            ),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: ToggleSwitch(
                    initialLabelIndex: ctl.periodIndex,
                    totalSwitches: 4,
                    minWidth: Get.width,
                    activeBgColor: const [AppColors.yellow],
                    inactiveBgColor: AppColors.ligthGrey,
                    activeFgColor: Colors.white,
                    labels: PeriodStat.values.map((e) => e.libelle).toList(),
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
                PlaceholderBuilder(
                    condition: ctl.periodIndex == 3,
                    builder: () {
                      return Column(
                        children: [
                          const Gap(10),
                          ListTile(
                            leading: const Icon(
                              Icons.calendar_today,
                              color: AppColors.green,
                            ),
                            title: Text(ctl.dateRange.toFrenchDate),
                            trailing: const Icon(Icons.arrow_drop_down),
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
                          ),
                        ],
                      );
                    }),
                const Gap(20),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  children: [
                    StatCardItem(
                      title: "Commandes en cours",
                      value: (ctl.data.kpis?.commandesEnCours ?? 0).toAmount(),
                      taux: -1.2,
                      isIncrease: false,
                    ),
                    StatCardItem(
                      title: "Revenus en (FCFA)",
                      value: (ctl.data.kpis?.chiffreAffaires ?? 0).toAmount(),
                      taux: 2.3,
                      isIncrease: true,
                    ),
                    StatCardItem(
                      title: "Nouveaux clients",
                      value: (ctl.data.kpis?.clientsActifs ?? 0).toAmount(),
                      taux: 18,
                      isIncrease: true,
                    ),
                    StatCardItem(
                      title: "Réservation",
                      value:
                          (ctl.data.kpis?.reservationsActives ?? 0).toAmount(),
                      taux: 8,
                      isIncrease: true,
                    ),
                  ]
                      .map(
                        (e) => Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              margin: const EdgeInsets.only(top: 3),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    e.value,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    e.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 18, height: 1),
                                  ),
                                  const Gap(10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        ternaryFn(
                                          condition: e.isIncrease,
                                          ifTrue: "assets/images/up.png",
                                          ifFalse:
                                              "assets/images/svg/entrant.png",
                                        ),
                                        width: 10,
                                        color: ternaryFn(
                                          condition: e.isIncrease,
                                          ifTrue: AppColors.primary,
                                          ifFalse: Colors.red,
                                        ),
                                      ),
                                      const Gap(2),
                                      Text(
                                        "${e.taux}%",
                                        style: TextStyle(
                                          color: ternaryFn(
                                            condition: e.isIncrease,
                                            ifTrue: AppColors.primary,
                                            ifFalse: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                Visibility(
                  visible: ctl.params.filtre != PeriodStat.jour,
                  child: Column(
                    children: [
                      const Gap(20),
                      const Text(
                        "Évolution du chiffres d’affaires",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(20),
                      AspectRatio(
                        aspectRatio: 1.32,
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            titlesData: const FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  ctl.data.revenusQuotidiens.length,
                                  (i) => FlSpot(
                                    i.toDouble(),
                                    ctl.data.revenusQuotidiens[i].revenus.value
                                        .toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                color: AppColors.primary,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  applyCutOffY: true,
                                  color: AppColors.yellow.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 40),
                      const Text(
                        "Évolution des ventes",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(20),
                      AspectRatio(
                        aspectRatio: 1.32,
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            titlesData: const FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  ctl.data.revenusQuotidiens.length,
                                  (i) => FlSpot(
                                    i.toDouble(),
                                    ctl.data.revenusQuotidiens[i].ventes.value
                                        .toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                color: AppColors.yellow,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  applyCutOffY: true,
                                  color: AppColors.yellow.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 40),
                      const Text(
                        "Évolution des factures",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(20),
                      AspectRatio(
                        aspectRatio: 1.32,
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            titlesData: const FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  ctl.data.revenusQuotidiens.length,
                                  (i) => FlSpot(
                                    i.toDouble(),
                                    ctl.data.revenusQuotidiens[i].factures.value
                                        .toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                color: Colors.red,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  applyCutOffY: true,
                                  color: Colors.red.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 40),
                      const Text(
                        "Évolution des reservations",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(20),
                      AspectRatio(
                        aspectRatio: 1.32,
                        child: LineChart(
                          LineChartData(
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            titlesData: const FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  ctl.data.revenusQuotidiens.length,
                                  (i) => FlSpot(
                                    i.toDouble(),
                                    ctl.data.revenusQuotidiens[i].reservations
                                        .value
                                        .toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                color: Colors.green,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  applyCutOffY: true,
                                  color: Colors.green.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // LineChart(
                //   LineChartData(
                //     gridData: FlGridData(
                //       show: true,
                //       drawVerticalLine: true,
                //       horizontalInterval: 1,
                //       verticalInterval: 1,
                //       getDrawingHorizontalLine: (value) {
                //         return const FlLine(
                //           color: AppColors.primary,
                //           strokeWidth: 1,
                //         );
                //       },
                //       getDrawingVerticalLine: (value) {
                //         return const FlLine(
                //           color: AppColors.primary,
                //           strokeWidth: 1,
                //         );
                //       },
                //     ),
                //     titlesData: FlTitlesData(
                //       show: true,
                //       rightTitles: const AxisTitles(
                //         sideTitles: SideTitles(showTitles: false),
                //       ),
                //       topTitles: const AxisTitles(
                //         sideTitles: SideTitles(showTitles: false),
                //       ),
                //       bottomTitles: AxisTitles(
                //         sideTitles: SideTitles(
                //           showTitles: true,
                //           reservedSize: 30,
                //           interval: 1,
                //           getTitlesWidget: (a, v) => const Text("data"),
                //         ),
                //       ),
                //       leftTitles: AxisTitles(
                //         sideTitles: SideTitles(
                //           showTitles: true,
                //           interval: 1,
                //           getTitlesWidget: (a, v) => const Text("data"),
                //           reservedSize: 42,
                //         ),
                //       ),
                //     ),
                //     borderData: FlBorderData(
                //       show: true,
                //       border: Border.all(color: const Color(0xff37434d)),
                //     ),
                //     minX: 0,
                //     maxX: 11,
                //     minY: 0,
                //     maxY: 6,
                //     lineBarsData: [
                //       LineChartBarData(
                //         spots: const [
                //           FlSpot(0, 3),
                //           FlSpot(2.6, 2),
                //           FlSpot(4.9, 5),
                //           FlSpot(6.8, 3.1),
                //           FlSpot(8, 4),
                //           FlSpot(9.5, 3),
                //           FlSpot(11, 4),
                //         ],
                //         isCurved: true,
                //         gradient: const LinearGradient(
                //           colors: [
                //             AppColors.primary,
                //             AppColors.yellow,
                //           ],
                //         ),
                //         barWidth: 5,
                //         isStrokeCapRound: true,
                //         dotData: const FlDotData(
                //           show: false,
                //         ),
                //         belowBarData: BarAreaData(
                //           show: true,
                //           gradient: LinearGradient(
                //             colors: [
                //               AppColors.primary,
                //               AppColors.yellow,
                //             ].map((color) => color.withValues(alpha: 0.3)).toList(),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
