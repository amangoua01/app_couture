import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/section_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MesureLivraisonSection extends StatelessWidget {
  final StatistiquesBoutique data;
  const MesureLivraisonSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final revenus = data.revenusQuotidiens;
    if (revenus.isEmpty) return const SizedBox.shrink();

    final displayRevenus =
        revenus.length > 7 ? revenus.sublist(revenus.length - 7) : revenus;

    return SectionContainer(
      title: "Mesures vs Factures",
      child: Container(
        height: 210,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < displayRevenus.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(displayRevenus[index].jour ?? "",
                            style: TextStyle(
                                color: AppColors.primary.withValues(alpha: 0.5),
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  interval: 1,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text(
                      value.toInt().toAmount(),
                      style: TextStyle(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                  reservedSize: 28,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(displayRevenus.length, (i) {
              return _makeGroupData(i, displayRevenus[i].mesures.toDouble(),
                  (displayRevenus[i].factures ?? 0).toDouble());
            }),
          ),
        ),
      ),
    );
  }
}

BarChartGroupData _makeGroupData(int x, double y1, double y2) {
  return BarChartGroupData(
    barsSpace: 4,
    x: x,
    barRods: [
      BarChartRodData(
          toY: y1,
          color: AppColors.primary,
          width: 12,
          borderRadius: BorderRadius.circular(4)),
      BarChartRodData(
          toY: y2,
          color: AppColors.secondary,
          width: 12,
          borderRadius: BorderRadius.circular(4)),
    ],
  );
}
