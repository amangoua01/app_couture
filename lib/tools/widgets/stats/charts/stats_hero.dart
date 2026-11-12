import 'dart:math' as math;

import 'package:ateliya/tools/widgets/stats/charts/animated_count.dart';
import 'package:ateliya/tools/widgets/stats/charts/stat_format.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ateliya/tools/constants/app_icons.dart';

class HeroStat {
  final String label;
  final String value;
  final IconData icon;
  const HeroStat(this.label, this.value, this.icon);
}

/// Bandeau principal, en aplat vert : le chiffre clé, sa tendance, une
/// courbe d'ensemble et trois indicateurs séparés par des filets.
class StatsHero extends StatelessWidget {
  final String title;
  final String periodLabel;
  final num amount;
  final List<num> spark;
  final double? trendPercent;
  final List<HeroStat> stats;

  const StatsHero({
    super.key,
    required this.title,
    required this.periodLabel,
    required this.amount,
    required this.spark,
    required this.stats,
    this.trendPercent,
  });

  static const _onInk = Color(0x33FFFFFF);

  @override
  Widget build(BuildContext context) {
    final hasSpark = spark.length >= 2 && spark.any((v) => v != 0);

    return Container(
      decoration: BoxDecoration(
        color: StatsStyle.ink,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: StatsStyle.caps(color: StatsStyle.gold),
                ),
              ),
              Text(
                periodLabel.toUpperCase(),
                style: StatsStyle.caps(color: Colors.white70),
              ),
            ],
          ),
          const Gap(14),
          AnimatedCount(
            value: amount,
            format: francs,
            style: StatsStyle.number(38, color: Colors.white),
          ),
          if (trendPercent != null) ...[
            const Gap(8),
            _Trend(percent: trendPercent!),
          ],
          if (hasSpark) ...[
            const Gap(14),
            SizedBox(height: 56, child: _Sparkline(values: spark)),
          ],
          const Gap(16),
          Container(height: 1, color: _onInk),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < stats.length; i++) ...[
                  if (i > 0) Container(width: 1, color: _onInk),
                  Expanded(child: _StatCell(stat: stats[i], first: i == 0)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Trend extends StatelessWidget {
  final double percent;
  const _Trend({required this.percent});

  @override
  Widget build(BuildContext context) {
    final up = percent >= 0;
    // Or pour la hausse, blanc cassé pour la baisse : pas de rouge/vert criards.
    final color = up ? StatsStyle.gold : Colors.white70;
    return Row(
      children: [
        Icon(
          up ? AppIconsBold.trendUp : AppIconsBold.trendDown,
          size: 16,
          color: color,
        ),
        const Gap(6),
        Text(
          '${up ? '+' : ''}${percent.round()} %',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const Gap(8),
        Expanded(
          child: Text(
            'seconde moitié vs première',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11.5, color: Colors.white60),
          ),
        ),
      ],
    );
  }
}

class _Sparkline extends StatelessWidget {
  final List<num> values;
  const _Sparkline({required this.values});

  @override
  Widget build(BuildContext context) {
    final maxV = values.fold<num>(1, (m, v) => math.max(m, v)).toDouble();
    return IgnorePointer(
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxV * 1.1,
          minX: 0,
          maxX: (values.length - 1).toDouble(),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < values.length; i++)
                  FlSpot(i.toDouble(), values[i].toDouble()),
              ],
              isCurved: true,
              curveSmoothness: 0.2,
              preventCurveOverShooting: true,
              color: StatsStyle.gold,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final HeroStat stat;
  final bool first;
  const _StatCell({required this.stat, required this.first});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(first ? 0 : 12, 14, 8, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(stat.icon, size: 18, color: StatsStyle.gold),
          const Gap(8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              stat.value,
              style: StatsStyle.number(15, color: Colors.white),
            ),
          ),
          const Gap(3),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Colors.white60),
          ),
        ],
      ),
    );
  }
}
