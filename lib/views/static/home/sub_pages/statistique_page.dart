import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/extensions/ternary_fn.dart';
import 'package:app_couture/tools/models/stat_card_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StatistiquePage extends StatelessWidget {
  const StatistiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiques"),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ToggleSwitch(
              initialLabelIndex: 0,
              totalSwitches: 4,
              minWidth: Get.width,
              activeBgColor: const [AppColors.yellow],
              inactiveBgColor: AppColors.ligthGrey,
              activeFgColor: Colors.white,
              labels: const ['07 jours', '30 jours', '3 mois', "Période"],
              onToggle: (index) {
                print('switched to: $index');
              },
            ),
          ),
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
                title: "Commandes totales",
                value: "47",
                taux: -1.2,
                isIncrease: false,
              ),
              StatCardItem(
                title: "Revenus en (FCFA)",
                value: "484K",
                taux: 2.3,
                isIncrease: true,
              ),
              StatCardItem(
                title: "Nouveaux clients",
                value: "28",
                taux: 18,
                isIncrease: true,
              ),
              StatCardItem(
                title: "Réservation",
                value: "96%",
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
                              style: const TextStyle(fontSize: 18, height: 1),
                            ),
                            const Gap(10),
                            Row(
                              children: [
                                Image.asset(
                                  ternaryFn(
                                    condition: e.isIncrease,
                                    ifTrue: "assets/images/up.png",
                                    ifFalse: "assets/images/svg/entrant.png",
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
          const Gap(20),
          const Text(
            "Évolution du chiffres d’affaires",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
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
    );
  }
}
