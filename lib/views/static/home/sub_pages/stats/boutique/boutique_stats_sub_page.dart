import 'package:ateliya/data/models/stats/top_modele_vendu.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/stats/charts/animated_count.dart';
import 'package:ateliya/tools/widgets/stats/charts/breakdown_donut.dart';
import 'package:ateliya/tools/widgets/stats/charts/compare_bars.dart';
import 'package:ateliya/tools/widgets/stats/charts/kpi_tile.dart';
import 'package:ateliya/tools/widgets/stats/charts/rank_bars.dart';
import 'package:ateliya/tools/widgets/stats/charts/series_line_chart.dart';
import 'package:ateliya/tools/widgets/stats/charts/stat_format.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_card.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_hero.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:ateliya/views/controllers/home/statistique_page_vctl.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/stats_helpers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ateliya/tools/constants/app_icons.dart';

/// Statistiques d'une boutique pour une période : le chiffre clé, la courbe
/// d'évolution, puis des blocs thématiques séparés par des filets.
class BoutiqueStatsSubPage extends StatelessWidget {
  final StatistiquePageVctl ctl;
  final int periodIndex;
  const BoutiqueStatsSubPage(this.ctl, {super.key, this.periodIndex = 0});

  @override
  Widget build(BuildContext context) {
    final data = ctl.dataFor(periodIndex);
    if (data == null) return const StatsSkeleton();

    final k = data.kpis;
    final daily = elapsedPoints(periodIndex, data.revenusQuotidiens);
    final revenus = [for (final r in daily) r.revenus];

    return RefreshIndicator(
      color: StatsStyle.gold,
      onRefresh: ctl.refreshCurrent,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(2, 12, 2, 40),
        children: [
          StatsHero(
            title: "Chiffre d'affaires",
            periodLabel: periodLabel(ctl, periodIndex),
            amount: k.chiffreAffaires,
            spark: revenus,
            trendPercent: halfTrend(revenus),
            stats: [
              HeroStat(
                'Recettes nettes',
                francs(k.recettesNettes.value),
                AppIcons.piggyBank,
              ),
              HeroStat(
                'Dépenses',
                francs(k.totalDepenses),
                AppIcons.receipt,
              ),
              HeroStat(
                'Panier moyen',
                francs(k.ticketMoyen.value),
                AppIcons.shoppingCartSimple,
              ),
            ],
          ),
          const Gap(30),
          StatsCard(
            title: 'Évolution',
            icon: AppIcons.chartLineUp,
            subtitle: 'Touchez la courbe pour lire chaque point',
            child: SeriesLineChart(
              labels: dayLabels(daily),
              series: [
                ChartSeries(
                  label: 'Revenus',
                  color: StatsStyle.ink,
                  values: revenus,
                ),
                ChartSeries(
                  label: 'Ventes',
                  color: StatsStyle.gold,
                  values: [for (final r in daily) r.ventes ?? 0],
                  format: (v) => '${v.round()} vente(s)',
                ),
                ChartSeries(
                  label: 'Réservations',
                  color: const Color(0xFF5C8A78),
                  values: [for (final r in daily) r.reservations ?? 0],
                  format: (v) => '${v.round()} réservation(s)',
                ),
              ],
            ),
          ),
          const Gap(30),
          KpiGrid(
            tiles: [
              KpiTile(
                icon: AppIcons.shoppingBag,
                label: 'Ventes directes',
                value: k.nbVentesBoutique.value,
                format: (v) => '${v.round()}',
                caption: francs(k.revenusVenteDirecte.value),
              ),
              KpiTile(
                icon: AppIcons.bookmarkSimple,
                label: 'Réservations actives',
                value: k.reservationsActives,
                format: (v) => '${v.round()}',
                caption: francs(k.revenusReservations.value),
              ),
              KpiTile(
                icon: AppIcons.users,
                label: 'Clients actifs',
                value: k.clientsActifs,
                format: (v) => '${v.round()}',
              ),
              KpiTile(
                icon: AppIcons.package,
                label: 'Articles en stock',
                value: k.stockTotalBoutique.value,
                format: (v) => '${v.round()}',
                caption: k.nombreModelesStockBas.value > 0
                    ? '${k.nombreModelesStockBas} modèle(s) en stock bas'
                    : 'Stock suffisant',
                color: k.nombreModelesStockBas.value > 0
                    ? const Color(0xFFB4401F)
                    : StatsStyle.ink,
              ),
            ],
          ),
          const Gap(30),
          StatsCard(
            title: 'Origine des revenus',
            icon: AppIcons.chartPie,
            child: BreakdownDonut(slices: _incomeSlices(ctl, periodIndex)),
          ),
          const Gap(30),
          StatsCard(
            title: 'Modèles les plus vendus',
            icon: AppIcons.medal,
            child: RankBars(
              emptyMessage: 'Aucune vente de modèle sur cette période',
              items: [
                for (final m in data.topModelesVendus ?? <TopModeleVendu>[])
                  RankItem(
                    label: m.nom ?? 'Modèle',
                    value: m.revenus.value,
                    valueText: francs(m.revenus.value),
                    caption: '${m.ventes.value} vente(s)',
                  ),
              ],
            ),
          ),
          const Gap(30),
          StatsCard(
            title: 'Trésorerie',
            icon: AppIcons.wallet,
            subtitle: 'Solde de la caisse et flux de la période',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('EN CAISSE', style: StatsStyle.caps()),
                const Gap(4),
                AnimatedCount(
                  value: k.caisse,
                  format: francs,
                  style: StatsStyle.number(28),
                ),
                const Gap(20),
                CompareBars(
                  styles: const [
                    BarSeriesStyle('Entrées', StatsStyle.ink),
                    BarSeriesStyle('Sorties', StatsStyle.gold),
                  ],
                  groups: [
                    BarGroup('Activité', [k.chiffreAffaires, k.totalDepenses]),
                    BarGroup('Caisse', [
                      k.totalMouvementsEntrants,
                      k.totalMouvementsSortants,
                    ]),
                  ],
                ),
              ],
            ),
          ),
          const Gap(30),
          StatsCard(
            title: 'Recouvrement',
            icon: AppIcons.handCoins,
            subtitle: 'Part du dû effectivement encaissée',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PercentGauge(percent: (k.tauxRecouvrement ?? 0).toDouble()),
                const Gap(18),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Montant dû par les clients',
                        style: TextStyle(fontSize: 13, color: StatsStyle.muted),
                      ),
                    ),
                    AnimatedCount(
                      value: k.montantDuClients.value,
                      format: francs,
                      style: StatsStyle.number(15),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(30),
          StatsCard(
            title: 'Stock par modèle',
            icon: AppIcons.stack,
            child: RankBars(
              color: const Color(0xFF5C8A78),
              emptyMessage: 'Aucun article en stock',
              items: [
                for (final m
                    in [...?data.modelesStock]..sort(
                        (a, b) => b.stockGlobal.value.compareTo(a.stockGlobal.value),
                      ))
                  if (m.stockGlobal.value > 0)
                    RankItem(
                      label: m.libelle ?? 'Modèle',
                      value: m.stockGlobal.value,
                      valueText: '${m.stockGlobal.value} en stock',
                    ),
              ].take(6).toList(),
            ),
          ),
        ],
      ),
    );
  }

  static List<BreakdownSlice> _incomeSlices(StatistiquePageVctl ctl, int index) {
    final data = ctl.dataFor(index)!;
    final fromApi = [
      for (var i = 0; i < data.revenusParType.length; i++)
        BreakdownSlice(
          data.revenusParType[i].type ?? 'Autre',
          data.revenusParType[i].revenus.value,
          BreakdownDonut.palette[i % BreakdownDonut.palette.length],
        ),
    ];
    if (fromApi.any((s) => s.value > 0)) return fromApi;
    final k = data.kpis;
    return [
      BreakdownSlice(
        'Ventes boutique',
        k.revenusVenteDirecte.value,
        BreakdownDonut.palette[0],
      ),
      BreakdownSlice(
        'Réservations',
        k.revenusReservations.value,
        BreakdownDonut.palette[1],
      ),
    ];
  }
}
