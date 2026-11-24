import 'package:ateliya/data/models/stats/activites_boutique.dart';
import 'package:ateliya/data/models/stats/globale_stats.dart';
import 'package:ateliya/data/models/stats/revenus_quotidiens.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/data/models/stats/top_modele_vendu.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/app_tab_bar.dart';
import 'package:ateliya/tools/widgets/pill_tabs.dart';
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
import 'package:ateliya/views/controllers/home/statistique_entreprise_page_vctl.dart';
import 'package:ateliya/tools/widgets/top_loading_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// Statistiques globales de l'entreprise : trois onglets (jour, mois, année)
/// qu'on change en touchant le titre ou en glissant, et un filtre Ensemble /
/// Boutiques / Ateliers, car une boutique et un atelier ne se mesurent pas
/// avec les mêmes indicateurs.
class StatistiqueEntreprisePage extends StatelessWidget {
  const StatistiqueEntreprisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StatistiqueEntreprisePageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Statistiques Globales"),
            actions: [
              IconButton(
                tooltip: "Télécharger le bilan",
                onPressed: ctl.hasData(ctl.periodIndex) ? ctl.exportBilanPdf : null,
                icon: const Icon(AppIcons.fileText),
              ),
            ],
          ),
          body: Stack(
            children: [
              ctl.periodIndex > 2 ? _PlageLibre(ctl: ctl) : _Onglets(ctl: ctl),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: TopLoadingBar(visible: ctl.isLoadingAny),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Onglets extends StatefulWidget {
  final StatistiqueEntreprisePageVctl ctl;
  const _Onglets({required this.ctl});

  @override
  State<_Onglets> createState() => _OngletsState();
}

class _OngletsState extends State<_Onglets>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(
    length: 3,
    vsync: this,
    initialIndex: widget.ctl.periodIndex.clamp(0, 2),
  )..addListener(() {
      if (!_tabs.indexIsChanging && _tabs.index != widget.ctl.periodIndex) {
        widget.ctl.selectPeriod(_tabs.index);
      }
    });

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctl = widget.ctl;
    return Column(
      children: [
        AppTabBar(
          controller: _tabs,
          tabs: const [AppTabItem('Jour'), AppTabItem('Mois'), AppTabItem('Année')],
          trailing: Material(
            color: Colors.white,
            shape: const CircleBorder(side: BorderSide(color: StatsStyle.hairline)),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => ctl.pickDateRange(context),
              child: const Padding(
                padding: EdgeInsets.all(11),
                child: Icon(AppIcons.calendarBlank, color: StatsStyle.ink, size: 22),
              ),
            ),
          ),
        ),
        _ScopePills(ctl: ctl),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: GlobaleStatsView(ctl, periodIndex: i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScopePills extends StatelessWidget {
  final StatistiqueEntreprisePageVctl ctl;
  const _ScopePills({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return PillTabs(
      index: ctl.scope,
      onChanged: ctl.setScope,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      tabs: const [
        PillTab('Ensemble', icon: AppIcons.chartPie),
        PillTab('Boutiques', icon: AppIcons.shoppingBag),
        PillTab('Ateliers', icon: AppIcons.scissors),
      ],
    );
  }
}

class _PlageLibre extends StatelessWidget {
  final StatistiqueEntreprisePageVctl ctl;
  const _PlageLibre({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: StatsStyle.hairline)),
          ),
          child: Row(
            children: [
              const Icon(AppIcons.calendarBlank, size: 20, color: StatsStyle.ink),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => ctl.pickDateRange(context),
                  child: Text(
                    ctl.dateRange.toFrenchDate,
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => ctl.selectPeriod(1),
                child: const Text('Retour aux onglets'),
              ),
            ],
          ),
        ),
        _ScopePills(ctl: ctl),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GlobaleStatsView(ctl, periodIndex: 3),
          ),
        ),
      ],
    );
  }
}

/// Contenu d'une période, selon le filtre choisi.
class GlobaleStatsView extends StatelessWidget {
  final StatistiqueEntreprisePageVctl ctl;
  final int periodIndex;
  const GlobaleStatsView(this.ctl, {super.key, this.periodIndex = 0});

  static const _sage = Color(0xFF5C8A78);
  static const _alert = Color(0xFFB4401F);

  String get _periodLabel => switch (periodIndex) {
    0 => "Aujourd'hui",
    1 => 'Ce mois',
    2 => 'Cette année',
    _ => ctl.dateRange.toFrenchDate,
  };

  @override
  Widget build(BuildContext context) {
    final g = ctl.dataFor(periodIndex);
    if (g == null) return const _Skeleton();

    final scope = ctl.scope;
    final d = ctl.blockFor(g);
    final k = d.kpis;
    final daily = _elapsed(d);
    final revenus = [for (final r in daily) r.revenus];
    final aEnsemble = scope == 0, aBoutiques = scope == 1, aAteliers = scope == 2;

    final ca = aEnsemble ? g.chiffreAffaires : k.chiffreAffaires;
    final prev = aEnsemble
        ? g.chiffreAffairesPrec
        : (aBoutiques ? g.boutiquesPrec : g.ateliersPrec).chiffreAffaires;
    final variation = prev > 0 ? (ca - prev) / prev * 100 : null;

    final entites = [
      for (final e in g.entites)
        if (aEnsemble || (aBoutiques == e.isBoutique)) e,
    ]..sort((a, b) => b.chiffreAffaires.compareTo(a.chiffreAffaires));

    return RefreshIndicator(
      color: StatsStyle.gold,
      onRefresh: ctl.refreshCurrent,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(2, 8, 2, 40),
        children: [
          StatsHero(
            title: aEnsemble
                ? "Chiffre d'affaires de l'entreprise"
                : aBoutiques
                    ? "Chiffre d'affaires des boutiques"
                    : "Chiffre d'affaires des ateliers",
            periodLabel: _periodLabel,
            amount: ca,
            spark: revenus,
            trendPercent: variation,
            stats: [
              HeroStat('Recettes nettes', francs(k.recettesNettes.value), AppIcons.piggyBank),
              HeroStat('Dépenses', francs(k.totalDepenses), AppIcons.receipt),
              HeroStat('En caisse', francs(k.caisse), AppIcons.wallet),
            ],
          ),
          if (prev > 0 || variation != null) ...[
            const Gap(10),
            Text(
              'Période précédente : ${francs(prev)}',
              style: const TextStyle(fontSize: 12, color: StatsStyle.muted),
            ),
          ],
          const Gap(30),
          if (aEnsemble) ...[
            StatsCard(
              title: 'Boutiques et ateliers',
              icon: AppIcons.chartPie,
              subtitle: "D'où vient le chiffre d'affaires",
              child: BreakdownDonut(
                slices: [
                  BreakdownSlice('Boutiques', g.boutiques.kpis.chiffreAffaires, StatsStyle.ink),
                  BreakdownSlice('Ateliers', g.ateliers.kpis.chiffreAffaires, StatsStyle.gold),
                ],
              ),
            ),
            const Gap(30),
          ],
          StatsCard(
            title: 'Évolution',
            icon: AppIcons.chartLineUp,
            subtitle: 'Touchez la courbe pour lire chaque point',
            child: SeriesLineChart(
              labels: [for (final r in daily) r.jour ?? ''],
              series: aEnsemble ? _seriesEnsemble(g) : _seriesDe(d, aBoutiques),
            ),
          ),
          const Gap(30),
          KpiGrid(tiles: _tiles(g, d, scope)),
          if (entites.isNotEmpty) ...[
            const Gap(30),
            StatsCard(
              title: aEnsemble
                  ? 'Classement des entités'
                  : aBoutiques
                      ? 'Classement des boutiques'
                      : 'Classement des ateliers',
              icon: AppIcons.medal,
              subtitle: "Chiffre d'affaires de la période",
              child: RankBars(
                items: [
                  for (final e in entites)
                    RankItem(
                      label: e.nom ?? 'Entité',
                      value: e.chiffreAffaires,
                      valueText: francs(e.chiffreAffaires),
                      caption:
                          '${e.isBoutique ? 'Boutique' : 'Atelier'} · dépenses ${francs(e.totalDepenses)}',
                    ),
                ],
              ),
            ),
          ],
          const Gap(30),
          StatsCard(
            title: 'Origine des revenus',
            icon: AppIcons.chartPie,
            child: BreakdownDonut(
              slices: [
                for (var i = 0; i < d.revenusParType.length; i++)
                  BreakdownSlice(
                    d.revenusParType[i].type ?? 'Autre',
                    d.revenusParType[i].revenus.value,
                    BreakdownDonut.palette[i % BreakdownDonut.palette.length],
                  ),
              ],
            ),
          ),
          if (aBoutiques) ...[
            const Gap(30),
            StatsCard(
              title: 'Modèles les plus vendus',
              icon: AppIcons.medal,
              child: RankBars(
                emptyMessage: 'Aucune vente de modèle sur cette période',
                items: [
                  for (final m in d.topModelesVendus ?? <TopModeleVendu>[])
                    RankItem(
                      label: m.nom ?? 'Modèle',
                      value: m.revenus.value,
                      valueText: francs(m.revenus.value),
                      caption: '${m.ventes.value} vente(s)',
                    ),
                ],
              ),
            ),
          ],
          if (aAteliers) ...[
            const Gap(30),
            StatsCard(
              title: "Activité des ateliers",
              icon: AppIcons.scissors,
              child: RankBars(
                emptyMessage: 'Aucune activité sur cette période',
                items: [
                  for (final a in (d.activitesBoutique ?? <ActivitesBoutique>[]).where((a) => a.isAtelier))
                    RankItem(
                      label: a.activite ?? 'Activité',
                      value: a.nombre.value,
                      valueText: '${a.nombre.value}',
                      caption: francs(a.revenus.value),
                    ),
                ],
              ),
            ),
          ],
          const Gap(30),
          StatsCard(
            title: 'Trésorerie',
            icon: AppIcons.wallet,
            subtitle: 'Flux de la période',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('EN CAISSE', style: StatsStyle.caps()),
                const Gap(4),
                AnimatedCount(value: k.caisse, format: francs, style: StatsStyle.number(28)),
                const Gap(20),
                CompareBars(
                  styles: const [
                    BarSeriesStyle('Entrées', StatsStyle.ink),
                    BarSeriesStyle('Sorties', StatsStyle.gold),
                  ],
                  groups: [
                    BarGroup('Activité', [k.chiffreAffaires, k.totalDepenses]),
                    BarGroup('Caisse', [k.totalMouvementsEntrants, k.totalMouvementsSortants]),
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
                      child: Text('Montant dû par les clients',
                          style: TextStyle(fontSize: 13, color: StatsStyle.muted)),
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

  List<RevenusQuotidiens> _elapsed(StatistiquesBoutique d) {
    final items = d.revenusQuotidiens;
    final now = DateTime.now();
    final limit = switch (periodIndex) {
      1 => now.day,
      2 => now.month,
      _ => items.length,
    };
    return items.take(limit < items.length ? limit : items.length).toList();
  }

  List<ChartSeries> _seriesEnsemble(GlobaleStats g) {
    List<num> pick(StatistiquesBoutique b) =>
        [for (final r in _elapsed(b)) r.revenus];
    return [
      ChartSeries(label: 'Total', color: StatsStyle.ink, values: pick(g.ensemble)),
      ChartSeries(label: 'Boutiques', color: StatsStyle.gold, values: pick(g.boutiques)),
      ChartSeries(label: 'Ateliers', color: _sage, values: pick(g.ateliers)),
    ];
  }

  List<ChartSeries> _seriesDe(StatistiquesBoutique d, bool boutique) {
    final daily = _elapsed(d);
    return [
      ChartSeries(label: 'Revenus', color: StatsStyle.ink, values: [for (final r in daily) r.revenus]),
      if (boutique) ...[
        ChartSeries(
          label: 'Ventes',
          color: StatsStyle.gold,
          values: [for (final r in daily) r.ventes ?? 0],
          format: (v) => '${v.round()} vente(s)',
        ),
        ChartSeries(
          label: 'Réservations',
          color: _sage,
          values: [for (final r in daily) r.reservations ?? 0],
          format: (v) => '${v.round()} réservation(s)',
        ),
      ] else ...[
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
    ];
  }

  List<KpiTile> _tiles(GlobaleStats g, StatistiquesBoutique d, int scope) {
    final k = d.kpis;
    String n(num v) => '${v.round()}';
    final boutiqueTiles = [
      KpiTile(
        icon: AppIcons.shoppingBag,
        label: 'Ventes directes',
        value: g.boutiques.kpis.nbVentesBoutique.value,
        format: n,
        caption: francs(g.boutiques.kpis.revenusVenteDirecte.value),
      ),
      KpiTile(
        icon: AppIcons.bookmarkSimple,
        label: 'Réservations actives',
        value: g.boutiques.kpis.reservationsActives,
        format: n,
        caption: francs(g.boutiques.kpis.revenusReservations.value),
      ),
      KpiTile(
        icon: AppIcons.package,
        label: 'Articles en stock',
        value: g.boutiques.kpis.stockTotalBoutique.value,
        format: n,
        caption: g.boutiques.kpis.nombreModelesStockBas.value > 0
            ? '${g.boutiques.kpis.nombreModelesStockBas} modèle(s) en stock bas'
            : 'Stock suffisant',
        color: g.boutiques.kpis.nombreModelesStockBas.value > 0 ? _alert : StatsStyle.ink,
      ),
    ];
    final a = g.ateliers.kpis;
    final retard = a.piecesEnRetard.value;
    final delai = a.delaiMoyenLivraisonJours;
    final atelierTiles = [
      KpiTile(
        icon: AppIcons.receipt,
        label: 'Factures actives',
        value: a.facturesActives.value,
        format: n,
        caption: francs(a.revenusFactures.value),
      ),
      KpiTile(
        icon: AppIcons.ruler,
        label: 'Mesures en cours',
        value: a.mesuresEnCours.value,
        format: n,
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
        format: n,
        caption: retard > 0 ? 'À relancer en priorité' : 'Aucun retard',
        color: retard > 0 ? _alert : StatsStyle.ink,
      ),
    ];
    final clients = KpiTile(
      icon: AppIcons.users,
      label: 'Clients actifs',
      value: k.clientsActifs,
      format: n,
    );
    return switch (scope) {
      1 => [...boutiqueTiles, clients],
      2 => [...atelierTiles, clients],
      _ => [
          KpiTile(
            icon: AppIcons.shoppingBag,
            label: 'Ventes et réservations',
            value: g.boutiques.kpis.nbVentesBoutique.value + g.boutiques.kpis.reservationsActives,
            format: n,
            caption: 'Boutiques',
          ),
          KpiTile(
            icon: AppIcons.receipt,
            label: 'Factures actives',
            value: a.facturesActives.value,
            format: n,
            caption: 'Ateliers',
          ),
          clients,
          KpiTile(
            icon: AppIcons.warningCircle,
            label: 'Pièces en retard',
            value: retard,
            format: n,
            caption: retard > 0 ? 'À relancer en priorité' : 'Aucun retard',
            color: retard > 0 ? _alert : StatsStyle.ink,
          ),
        ],
    };
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();
  @override
  Widget build(BuildContext context) => const Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: StatsStyle.ink),
        ),
      );
}
