import 'package:ateliya/data/models/stats/stock_statistiques.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/tools/constants/period_stat.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/app_tab_bar.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/pill_tabs.dart';
import 'package:ateliya/tools/widgets/select_dash_period_sub_page.dart';
import 'package:ateliya/tools/widgets/stats/charts/breakdown_donut.dart';
import 'package:ateliya/tools/widgets/stats/charts/compare_bars.dart';
import 'package:ateliya/tools/widgets/stats/charts/kpi_tile.dart';
import 'package:ateliya/tools/widgets/stats/charts/rank_bars.dart';
import 'package:ateliya/tools/widgets/stats/charts/series_line_chart.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_card.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:ateliya/tools/widgets/top_loading_bar.dart';
import 'package:ateliya/views/controllers/stats/stock_statistiques_vctl.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/stats_helpers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// Suivi du stock d'une boutique : quatre onglets qu'on change en touchant le
/// titre ou en glissant, une période commune, et le même langage visuel que
/// les statistiques (à plat, filets fins, chiffres lisibles).
class StockStatistiquesPage extends StatelessWidget {
  const StockStatistiquesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockStatistiquesVctl>(
      init: StockStatistiquesVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Suivi de stock')),
          body: Stack(
            children: [
              _corps(ctl),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: TopLoadingBar(visible: ctl.isRefreshing),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _corps(StockStatistiquesVctl ctl) {
    if (ctl.isLoading && ctl.data == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: StatsSkeleton(),
      );
    }
    if (ctl.data == null && ctl.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                AppIcons.warningCircle,
                size: 44,
                color: StatsStyle.muted,
              ),
              const SizedBox(height: 14),
              Text(
                ctl.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: StatsStyle.dark),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  ctl.isLoading = true;
                  ctl.update();
                  ctl.fetchData();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }
    return _Onglets(ctl: ctl);
  }
}

class _Onglets extends StatefulWidget {
  final StockStatistiquesVctl ctl;
  const _Onglets({required this.ctl});

  @override
  State<_Onglets> createState() => _OngletsState();
}

class _OngletsState extends State<_Onglets>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _choisirPlage() async {
    final ctl = widget.ctl;
    final e = await CBottomSheet.show(
      child: SelectDashPeriodSubPage(
        DateTimeRange(
          start: ctl.params.dateDebut ?? DateTime.now(),
          end: ctl.params.dateFin ?? DateTime.now(),
        ),
      ),
    );
    if (e is DateTimeRange) {
      ctl.updatePeriod(PeriodStat.periode, debut: e.start, fin: e.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctl = widget.ctl;
    return Column(
      children: [
        AppTabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: const [
            AppTabItem('Général'),
            AppTabItem('Mouvements'),
            AppTabItem('Inventaire'),
            AppTabItem('Par taille'),
          ],
        ),
        PillTabs(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
          index: ctl.periodIndex.clamp(0, 3),
          onChanged: (i) {
            if (i == 3) {
              _choisirPlage();
            } else {
              ctl.updatePeriod(PeriodStat.values[i]);
            }
          },
          tabs: const [
            PillTab('Jour'),
            PillTab('Mois'),
            PillTab('Année'),
            PillTab('Période', icon: AppIcons.calendarBlank),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              _Page(ctl: ctl, child: _General(ctl: ctl)),
              _Page(ctl: ctl, child: _Mouvements(ctl: ctl)),
              _Page(ctl: ctl, child: _Inventaire(ctl: ctl)),
              _Page(ctl: ctl, child: _ParTaille(ctl: ctl)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Défilement + actualisation par glissement, avec les marges communes.
class _Page extends StatelessWidget {
  final StockStatistiquesVctl ctl;
  final Widget child;
  const _Page({required this.ctl, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: StatsStyle.gold,
      onRefresh: ctl.fetchData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [child],
      ),
    );
  }
}

String _nb(num v) => '${v.round()}';
String _articles(num v) => '${v.round()} article(s)';

// ── Général ─────────────────────────────────────────────────────────────

class _General extends StatelessWidget {
  final StockStatistiquesVctl ctl;
  const _General({required this.ctl});

  static const _sage = Color(0xFF5C8A78);
  static const _alert = Color(0xFFB4401F);

  @override
  Widget build(BuildContext context) {
    final d = ctl.data;
    final k = d?.kpis ?? StockKpis.fromJson({});
    final evo = d?.evolution ?? <StockEvolution>[];
    final modeles = d?.stockParModele ?? <StockParModele>[];
    final sansStock = k.nbModelesSansStock ?? 0;
    final attente = k.nbMouvementsEnAttente ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(8),
        KpiGrid(
          tiles: [
            KpiTile(
              icon: AppIcons.package,
              label: 'Stock actuel',
              value: k.stockActuelTotal ?? 0,
              format: _nb,
              caption: 'articles en boutique',
            ),
            KpiTile(
              icon: AppIcons.tShirt,
              label: 'Modèles en boutique',
              value: k.nbModelesBoutique ?? 0,
              format: _nb,
            ),
            KpiTile(
              icon: AppIcons.warningCircle,
              label: 'Sans stock',
              value: sansStock,
              format: _nb,
              caption: sansStock > 0 ? 'À réapprovisionner' : 'Aucune rupture',
              color: sansStock > 0 ? _alert : StatsStyle.ink,
            ),
            KpiTile(
              icon: AppIcons.clock,
              label: 'Mouvements en attente',
              value: attente,
              format: _nb,
              caption: attente > 0 ? 'À confirmer' : 'Rien en attente',
              color: attente > 0 ? _alert : StatsStyle.ink,
            ),
          ],
        ),
        const Gap(30),
        StatsCard(
          title: 'Entrées et sorties',
          icon: AppIcons.arrowsLeftRight,
          subtitle: 'Sur la période choisie',
          child: CompareBars(
            styles: const [
              BarSeriesStyle('Entrées', StatsStyle.ink),
              BarSeriesStyle('Sorties', StatsStyle.gold),
            ],
            groups: [
              BarGroup('Mouvements', [k.nbEntrees ?? 0, k.nbSorties ?? 0]),
              BarGroup('Articles', [
                k.qteEntreeTotale ?? 0,
                k.qteSortieTotale ?? 0,
              ]),
            ],
          ),
        ),
        const Gap(30),
        StatsCard(
          title: 'Répartition par modèle',
          icon: AppIcons.chartPie,
          child: BreakdownDonut(
            centerLabel: 'En stock',
            format: _articles,
            slices: [
              for (var i = 0; i < modeles.length; i++)
                BreakdownSlice(
                  modeles[i].libelle ?? 'Modèle',
                  modeles[i].stockTotal ?? 0,
                  BreakdownDonut.palette[i % BreakdownDonut.palette.length],
                ),
            ],
          ),
        ),
        const Gap(30),
        StatsCard(
          title: 'Évolution du stock',
          icon: AppIcons.chartLineUp,
          subtitle: 'Touchez la courbe pour lire chaque point',
          child: SeriesLineChart(
            labels: [for (final e in evo) _jour(e.date)],
            series: [
              ChartSeries(
                label: 'Stock',
                color: StatsStyle.ink,
                values: [for (final e in evo) e.solde ?? 0],
                format: _articles,
              ),
              ChartSeries(
                label: 'Entrées',
                color: _sage,
                values: [for (final e in evo) e.qteEntree ?? 0],
                format: _articles,
              ),
              ChartSeries(
                label: 'Sorties',
                color: StatsStyle.gold,
                values: [for (final e in evo) e.qteSortie ?? 0],
                format: _articles,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _jour(String? iso) {
    final d = iso?.toDateTime();
    if (d == null) return iso ?? '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }
}

// ── Mouvements ──────────────────────────────────────────────────────────

class _Mouvements extends StatelessWidget {
  final StockStatistiquesVctl ctl;
  const _Mouvements({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final list = ctl.data?.historiqueMouvements ?? <HistoriqueMouvement>[];
    if (list.isEmpty) {
      return const StatsEmpty(message: 'Aucun mouvement sur cette période');
    }
    return Column(children: [for (final m in list) _Mouvement(m: m)]);
  }
}

class _Mouvement extends StatelessWidget {
  final HistoriqueMouvement m;
  const _Mouvement({required this.m});

  @override
  Widget build(BuildContext context) {
    final sortie = m.type?.toLowerCase() == 'sortie';
    final confirme = (m.statut ?? '').toUpperCase().startsWith('CONFIRM');
    final couleur = sortie ? StatsStyle.gold : StatsStyle.ink;
    final lignes = m.lignes ?? <LigneMouvement>[];
    final total = lignes.fold<int>(0, (a, l) => a + (l.quantiteMouvement ?? 0));

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: StatsStyle.hairline)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(vertical: 4),
          childrenPadding: const EdgeInsets.only(bottom: 12),
          shape: const Border(),
          collapsedShape: const Border(),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: couleur.withValues(alpha: 0.5)),
            ),
            child: Icon(
              sortie ? AppIcons.arrowUp : AppIcons.arrowDown,
              size: 18,
              color: couleur,
            ),
          ),
          title: Text(
            sortie ? 'Sortie' : 'Entrée',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          subtitle: Text(
            m.date.toFrenchDateTime,
            style: const TextStyle(fontSize: 12, color: StatsStyle.muted),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${sortie ? '-' : '+'}$total',
                style: StatsStyle.number(16, color: couleur),
              ),
              const SizedBox(height: 2),
              Text(
                confirme ? 'Confirmé' : (m.statut ?? '').toLowerCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: confirme ? StatsStyle.muted : const Color(0xFFB4401F),
                ),
              ),
            ],
          ),
          children: [
            if ((m.commentaire ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    m.commentaire!,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12.5,
                      color: StatsStyle.muted,
                    ),
                  ),
                ),
              ),
            for (final l in lignes)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${l.modeleLibelle ?? 'Modèle'}'
                        '${(l.taille ?? '').isNotEmpty ? ' · ${l.taille}' : ''}',
                        style: const TextStyle(fontSize: 13.5),
                      ),
                    ),
                    Text(
                      '${l.quantiteAvant ?? 0} → ${l.quantiteApres ?? 0}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: StatsStyle.muted,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Inventaire ──────────────────────────────────────────────────────────

class _Inventaire extends StatelessWidget {
  final StockStatistiquesVctl ctl;
  const _Inventaire({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final list = [...?ctl.data?.stockParModele]
      ..sort((a, b) => (b.stockTotal ?? 0).compareTo(a.stockTotal ?? 0));
    if (list.isEmpty) {
      return const StatsEmpty(message: 'Aucun modèle en boutique');
    }
    return Column(
      children: [
        for (final m in list)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: StatsStyle.hairline)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        m.libelle ?? 'Modèle',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text('${m.stockTotal ?? 0}', style: StatsStyle.number(20)),
                  ],
                ),
                Text(
                  '${m.nbVariantes ?? 0} variante(s)',
                  style: const TextStyle(fontSize: 12, color: StatsStyle.muted),
                ),
                for (final v in m.variantes ?? <StockVariante>[])
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            [
                              if ((v.taille ?? '').isNotEmpty)
                                'Taille ${v.taille}',
                              if ((v.couleur ?? '').isNotEmpty) v.couleur!,
                            ].join(' · ').ifEmpty('Sans taille'),
                            style: const TextStyle(fontSize: 13.5),
                          ),
                        ),
                        Text(
                          '${v.stock ?? 0} en stock',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: StatsStyle.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Par taille ──────────────────────────────────────────────────────────

class _ParTaille extends StatelessWidget {
  final StockStatistiquesVctl ctl;
  const _ParTaille({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final list = [...?ctl.data?.stockParTaille]
      ..sort((a, b) => (b.stockTotal ?? 0).compareTo(a.stockTotal ?? 0));
    return StatsCard(
      title: 'Stock par taille',
      icon: AppIcons.ruler,
      subtitle: 'Articles en boutique selon la taille',
      child: RankBars(
        emptyMessage: 'Aucun article en stock',
        items: [
          for (final t in list)
            RankItem(
              label:
                  (t.taille ?? '').isEmpty
                      ? 'Sans taille'
                      : 'Taille ${t.taille}',
              value: t.stockTotal ?? 0,
              valueText: '${t.stockTotal ?? 0} en stock',
              caption: '${t.nbModeleBoutique ?? 0} modèle(s)',
            ),
        ],
      ),
    );
  }
}

extension on String {
  String ifEmpty(String other) => isEmpty ? other : this;
}
