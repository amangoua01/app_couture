import 'dart:math' as math;

import 'package:ateliya/tools/widgets/stats/charts/stat_format.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_card.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Une courbe : un libellé, une couleur et une valeur par point de l'axe.
class ChartSeries {
  final String label;
  final Color color;
  final List<num> values;

  /// Formate la valeur dans l'info-bulle (par défaut : montant en francs).
  final String Function(num)? format;

  const ChartSeries({
    required this.label,
    required this.color,
    required this.values,
    this.format,
  });

  bool get hasData => values.any((v) => v != 0);
}

/// Courbe d'évolution : trait fin, aplat léger sous la courbe, info-bulle au
/// toucher. Plusieurs séries se choisissent par de simples onglets soulignés.
class SeriesLineChart extends StatefulWidget {
  final List<String> labels;
  final List<ChartSeries> series;
  final double height;

  const SeriesLineChart({
    super.key,
    required this.labels,
    required this.series,
    this.height = 210,
  });

  @override
  State<SeriesLineChart> createState() => _SeriesLineChartState();
}

class _SeriesLineChartState extends State<SeriesLineChart> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final series = widget.series;
    if (series.isEmpty || widget.labels.isEmpty) return const StatsEmpty();

    final current = series[_selected.clamp(0, series.length - 1)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (series.length > 1) ...[
          Wrap(
            spacing: 22,
            runSpacing: 8,
            children: [
              for (var i = 0; i < series.length; i++)
                _SeriesTab(
                  series: series[i],
                  selected: i == _selected,
                  onTap: () => setState(() => _selected = i),
                ),
            ],
          ),
          const Gap(18),
        ],
        SizedBox(
          height: widget.height,
          child: current.hasData
              ? _buildChart(current)
              : const StatsEmpty(
                  message:
                      "Rien à tracer pour l'instant : la courbe apparaît dès les premières opérations.",
                  height: 150,
                ),
        ),
      ],
    );
  }

  Widget _buildChart(ChartSeries s) {
    final n = s.values.length;
    final maxValue = s.values.fold<num>(0, (m, v) => math.max(m, v));
    final maxY = math.max(1, maxValue * 1.2).toDouble();
    final spots = [
      for (var i = 0; i < n; i++) FlSpot(i.toDouble(), s.values[i].toDouble()),
    ];
    final labelStep = math.max(1, (n / 5).ceil());
    final fmt = s.format ?? francs;

    return LineChart(
      LineChartData(
        minX: n == 1 ? -0.5 : 0,
        maxX: n == 1 ? 0.5 : (n - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: StatsStyle.hairline, strokeWidth: 1),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: StatsStyle.dark, width: 1),
          ),
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
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if (value != i.toDouble() || i < 0 || i >= n) {
                  return const SizedBox.shrink();
                }
                if (i % labelStep != 0) return const SizedBox.shrink();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    widget.labels[i],
                    style: const TextStyle(
                      fontSize: 10,
                      color: StatsStyle.muted,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => StatsStyle.dark,
            tooltipRoundedRadius: 4,
            tooltipPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touched) => [
              for (final t in touched)
                LineTooltipItem(
                  '${widget.labels[t.x.round().clamp(0, n - 1)]}\n',
                  const TextStyle(color: Colors.white70, fontSize: 11),
                  children: [
                    TextSpan(
                      text: fmt(t.y),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          getTouchedSpotIndicator: (bar, indexes) => [
            for (final _ in indexes)
              TouchedSpotIndicatorData(
                FlLine(color: s.color, strokeWidth: 1),
                FlDotData(
                  getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                    radius: 4.5,
                    color: s.color,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: n > 2,
            curveSmoothness: 0.22,
            preventCurveOverShooting: true,
            color: s.color,
            barWidth: 2.2,
            isStrokeCapRound: false,
            dotData: FlDotData(show: n <= 2),
            // Aplat uni, pas de dégradé.
            belowBarData: BarAreaData(
              show: true,
              color: s.color.withValues(alpha: 0.09),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
}

class _SeriesTab extends StatelessWidget {
  final ChartSeries series;
  final bool selected;
  final VoidCallback onTap;

  const _SeriesTab({
    required this.series,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? series.color : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          series.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? StatsStyle.dark : StatsStyle.muted,
          ),
        ),
      ),
    );
  }
}
