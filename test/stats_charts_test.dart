import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:ateliya/tools/widgets/stats/charts/breakdown_donut.dart';
import 'package:ateliya/tools/widgets/stats/charts/compare_bars.dart';
import 'package:ateliya/tools/widgets/stats/charts/kpi_tile.dart';
import 'package:ateliya/tools/widgets/stats/charts/rank_bars.dart';
import 'package:ateliya/tools/widgets/stats/charts/series_line_chart.dart';
import 'package:ateliya/tools/widgets/stats/charts/stat_format.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_card.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_hero.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: ListView(children: [child]),
        ),
      ),
    );

void main() {
  testWidgets('StatsHero', (t) async {
    await t.pumpWidget(_host(const StatsHero(
      title: "Chiffre d'affaires",
      periodLabel: 'Ce mois',
      amount: 50000,
      spark: [0, 0, 20000, 30000, 0, 50000],
      trendPercent: 42,
      stats: [
        HeroStat('Recettes nettes', '30 000 F', Icons.savings_outlined),
        HeroStat('Dépenses', '20 000 F', Icons.receipt_long_outlined),
        HeroStat('Panier moyen', '0 F', Icons.shopping_basket_outlined),
      ],
    )));
    await t.pump(const Duration(seconds: 2));
    expect(t.takeException(), isNull);
  });

  testWidgets('SeriesLineChart avec données, 1 point, vide', (t) async {
    for (final values in [
      <num>[0, 10000, 25000, 5000, 42000, 0, 18000],
      <num>[25000],
      <num>[0, 0, 0],
    ]) {
      await t.pumpWidget(_host(StatsCard(
        title: 'Évolution',
        child: SeriesLineChart(
          labels: [for (var i = 0; i < values.length; i++) '${i + 1} Nov'],
          series: [
            ChartSeries(label: 'Revenus', color: StatsStyle.ink, values: values),
            ChartSeries(label: 'Ventes', color: StatsStyle.gold, values: values),
          ],
        ),
      )));
      await t.pump(const Duration(seconds: 1));
      expect(t.takeException(), isNull, reason: 'valeurs $values');
    }
  });

  testWidgets('KpiGrid + ProgressRing', (t) async {
    await t.pumpWidget(_host(Column(children: [
      KpiGrid(tiles: [
        KpiTile(icon: Icons.shopping_bag_outlined, label: 'Ventes', value: 3, format: (v) => '${v.round()}', caption: '15 000 F'),
        KpiTile(icon: Icons.groups_2_outlined, label: 'Clients', value: 1, format: (v) => '${v.round()}'),
        KpiTile(icon: Icons.inventory_2_outlined, label: 'Stock', value: 18, format: (v) => '${v.round()}', caption: 'ok'),
      ]),
      const PercentGauge(percent: 100),
    ])));
    await t.pump(const Duration(seconds: 1));
    expect(t.takeException(), isNull);
  });

  testWidgets('BreakdownDonut', (t) async {
    await t.pumpWidget(_host(const BreakdownDonut(slices: [
      BreakdownSlice('Réservations', 50000, StatsStyle.ink),
      BreakdownSlice('Ventes', 0, StatsStyle.gold),
    ])));
    await t.pump(const Duration(seconds: 1));
    expect(t.takeException(), isNull);
  });

  testWidgets('CompareBars + RankBars', (t) async {
    await t.pumpWidget(_host(Column(children: [
      const CompareBars(
        styles: [BarSeriesStyle('Entrées', StatsStyle.ink), BarSeriesStyle('Sorties', StatsStyle.gold)],
        groups: [BarGroup('Activité', [50000, 20000]), BarGroup('Caisse', [100000, 10000])],
      ),
      RankBars(items: [RankItem(label: 'Robe wax', value: 50000, valueText: francs(50000), caption: '2 vente(s)')]),
    ])));
    await t.pump(const Duration(seconds: 1));
    expect(t.takeException(), isNull);
  });
}
