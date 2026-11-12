import 'dart:math' as math;

import 'package:ateliya/tools/widgets/stats/charts/stat_format.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_card.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BarGroup {
  final String label;
  final List<num> values;
  const BarGroup(this.label, this.values);
}

class BarSeriesStyle {
  final String label;
  final Color color;
  const BarSeriesStyle(this.label, this.color);
}

/// Barres groupées (ex. Entrées / Sorties) : arrondies, animées, avec une
/// info-bulle au toucher et une légende.
class CompareBars extends StatelessWidget {
  final List<BarGroup> groups;
  final List<BarSeriesStyle> styles;
  final double height;

  const CompareBars({
    super.key,
    required this.groups,
    required this.styles,
    this.height = 190,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = groups.fold<num>(
      0,
      (m, g) => g.values.fold<num>(m, (a, v) => math.max(a, v)),
    );
    if (groups.isEmpty || maxValue <= 0) {
      return const StatsEmpty(message: 'Aucun mouvement sur cette période');
    }
    final maxY = (maxValue * 1.25).toDouble();

    return Column(
      children: [
        SizedBox(
          height: height,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(color: StatsStyle.dark, width: 1),
                ),
              ),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (_) =>
                    const FlLine(color: StatsStyle.hairline, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    interval: maxY / 4,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.max) return const SizedBox.shrink();
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          compactAmount(value),
                          style: const TextStyle(
                            fontSize: 10,
                            color: StatsStyle.muted,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= groups.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          groups[i].label,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: StatsStyle.muted,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => StatsStyle.dark,
                  tooltipRoundedRadius: 4,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                    '${styles[ri].label}\n',
                    const TextStyle(color: Colors.white70, fontSize: 11),
                    children: [
                      TextSpan(
                        text: francs(rod.toY),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              barGroups: [
                for (var g = 0; g < groups.length; g++)
                  BarChartGroupData(
                    x: g,
                    barsSpace: 6,
                    barRods: [
                      for (var s = 0; s < groups[g].values.length; s++)
                        BarChartRodData(
                          toY: groups[g].values[s].toDouble(),
                          width: 24,
                          color: styles[s].color,
                          borderRadius: BorderRadius.zero,
                        ),
                    ],
                  ),
              ],
            ),
            swapAnimationDuration: const Duration(milliseconds: 600),
            swapAnimationCurve: Curves.easeOutCubic,
          ),
        ),
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final s in styles) ...[
              Container(width: 10, height: 10, color: s.color),
              const Gap(6),
              Text(
                s.label,
                style: const TextStyle(
                  fontSize: 12,
                  color: StatsStyle.muted,
                ),
              ),
              const Gap(18),
            ],
          ],
        ),
      ],
    );
  }
}
