import 'dart:math' as math;

import 'package:ateliya/data/models/stats/revenus_quotidiens.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:ateliya/views/controllers/home/statistique_page_vctl.dart';
import 'package:flutter/material.dart';

/// Libellé de la période [index] affiché dans le bandeau.
String periodLabel(StatistiquePageVctl ctl, int index) {
  switch (index) {
    case 0:
      return "Aujourd'hui";
    case 1:
      return 'Ce mois';
    case 2:
      return 'Cette année';
    default:
      return ctl.dateRange.toFrenchDate;
  }
}

/// Variation entre la première et la seconde moitié de la période, en %.
/// Null s'il y a trop peu de points pour que ce soit parlant.
double? halfTrend(List<num> values) {
  if (values.length < 4) return null;
  final half = values.length ~/ 2;
  num first = 0, second = 0;
  for (var i = 0; i < half; i++) {
    first += values[i];
  }
  for (var i = values.length - half; i < values.length; i++) {
    second += values[i];
  }
  if (first <= 0) return second > 0 ? 100 : null;
  return (second - first) / first * 100;
}

List<String> dayLabels(List<RevenusQuotidiens> items) =>
    [for (final r in items) r.jour ?? ''];

/// Points déjà écoulés de la période : le mois en cours ne compte que les
/// jours jusqu'à aujourd'hui, l'année en cours que les mois jusqu'à ce mois.
/// Sans ça, la courbe retombe à zéro pour des jours qui n'ont pas encore eu
/// lieu et la tendance annonce une chute fantôme.
List<RevenusQuotidiens> elapsedPoints(
  int periodIndex,
  List<RevenusQuotidiens> items,
) {
  final now = DateTime.now();
  final limit = switch (periodIndex) {
    1 => now.day,
    2 => now.month,
    _ => items.length,
  };
  return items.take(math.min(items.length, limit)).toList();
}

/// Silhouette affichée tant que les chiffres d'une période n'ont pas été
/// reçus : des aplats gris qui respirent doucement.
class StatsSkeleton extends StatefulWidget {
  const StatsSkeleton({super.key});

  @override
  State<StatsSkeleton> createState() => _StatsSkeletonState();
}

class _StatsSkeletonState extends State<StatsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _block(double h, {double? w}) =>
      Container(height: h, width: w, color: StatsStyle.hairline);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(_c),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(2, 12, 2, 0),
        children: [
          _block(250),
          const SizedBox(height: 28),
          _block(14, w: 120),
          const SizedBox(height: 14),
          _block(190),
          const SizedBox(height: 28),
          _block(110),
        ],
      ),
    );
  }
}
