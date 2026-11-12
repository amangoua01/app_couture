import 'package:ateliya/data/models/stats/activites_boutique.dart';
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

/// Statistiques d'un atelier pour une période : chiffre d'affaires, courbe
/// (revenus, mesures, livraisons), délais, retards, activité et trésorerie.
class AtelierStatsSubPage extends StatelessWidget {
  final StatistiquePageVctl ctl;
  final int periodIndex;
  const AtelierStatsSubPage(this.ctl, {super.key, this.periodIndex = 0});

  static const _sage = Color(0xFF5C8A78);
  static const _alert = Color(0xFFB4401F);

  @override
  Widget build(BuildContext context) {
    final data = ctl.dataFor(periodIndex);
    if (data == null) return const StatsSkeleton();

    final k = data.kpis;
    final daily = elapsedPoints(periodIndex, data.revenusQuotidiens);
    final revenus = [for (final r in daily) r.revenus];
    final retard = k.piecesEnRetard.value;
    final delai = k.delaiMoyenLivraisonJours;

    return RefreshIndicator(
      color: StatsStyle.gold,
      onRefresh: ctl.refreshCurrent,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(2, 12, 2, 40),
        children: [
          StatsHero(
            title: "Chiffre d'affaires atelier",
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
                  label: 'Mesures',
                  color: StatsStyle.gold,
                  values: [for (final r in daily) r.mesures],
                  format: (v) => '${v.round()} mesure(s)',
                ),
                ChartSeries(
                  label: 'Livraisons',
                  color: _sage,
                  values: [for (final r in daily) r.livraisons],
                  format: (v) => '${v.round()} livraison(s)',
                ),
              ],
            ),
          ),
          const Gap(30),
          KpiGrid(
            tiles: [
              KpiTile(
                icon: AppIcons.receipt,
                label: 'Factures actives',
                value: k.facturesActives.value,
                format: (v) => '${v.round()}',
                caption: francs(k.revenusFactures.value),
              ),
              KpiTile(
                icon: AppIcons.ruler,
                label: 'Mesures en cours',
                value: k.mesuresEnCours.value,
                format: (v) => '${v.round()}',
              ),
              KpiTile(
                icon: AppIcons.truck,
                label: 'Délai moyen de livraison',
                value: delai ?? 0,
                format: (v) => '${v.toStringAsFixed(1).replaceAll('.', ',')} j',
                caption: delai == null ? 'Pas encore de livraison' : null,
              ),
              KpiTile(
                icon: AppIcons.warningCircle,
                label: 'Pièces en retard',
                value: retard,
                format: (v) => '${v.round()}',
                caption: retard > 0 ? 'À relancer en priorité' : 'Aucun retard',
                color: retard > 0 ? _alert : StatsStyle.ink,
              ),
            ],
          ),
          const Gap(30),
          StatsCard(
            title: 'Origine des revenus',
            icon: AppIcons.chartPie,
            child: BreakdownDonut(
              slices: [
                for (var i = 0; i < data.revenusParType.length; i++)
                  BreakdownSlice(
                    data.revenusParType[i].type ?? 'Autre',
                    data.revenusParType[i].revenus.value,
                    BreakdownDonut.palette[i % BreakdownDonut.palette.length],
                  ),
              ],
            ),
          ),
          const Gap(30),
          StatsCard(
            title: "Activité de l'atelier",
            icon: AppIcons.scissors,
            child: RankBars(
              emptyMessage: 'Aucune activité sur cette période',
              items: [
                for (final a in (data.activitesBoutique ?? <ActivitesBoutique>[])
                    .where((a) => a.isAtelier))
                  RankItem(
                    label: a.activite ?? 'Activité',
                    value: a.nombre.value,
                    valueText: '${a.nombre.value}',
                    caption: francs(a.revenus.value),
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
        ],
      ),
    );
  }
}
