import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/widgets/app_tab_bar.dart';
import 'package:ateliya/tools/widgets/empty_page.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/tools/widgets/stats/charts/stats_style.dart';
import 'package:ateliya/views/controllers/home/statistique_page_vctl.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/atelier/atelier_stats_sub_page.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/boutique/boutique_stats_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ateliya/tools/constants/app_icons.dart';

/// Écran des statistiques : trois onglets (jour, mois, année) qu'on change en
/// touchant le titre ou en glissant le doigt ; le contenu suit le doigt.
class StatistiquePage extends StatelessWidget {
  const StatistiquePage({super.key});

  static const _titres = ['Jour', 'Mois', 'Année'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: StatistiquePageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: MainAppBar(
            notifCount: ctl.nbUnreadNotifs,
            onSelectionChanged: () {},
            onNotifRefresh: () => ctl.loadUnreadCount(),
          ),
          body: ctl.periodIndex > 2
              ? _PlageLibre(ctl: ctl)
              : _Onglets(ctl: ctl),
        );
      },
    );
  }
}

class _Onglets extends StatefulWidget {
  final StatistiquePageVctl ctl;
  const _Onglets({required this.ctl});

  @override
  State<_Onglets> createState() => _OngletsState();
}

class _OngletsState extends State<_Onglets> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(
    length: 3,
    vsync: this,
    initialIndex: widget.ctl.periodIndex.clamp(0, 2),
  )..addListener(_onTab);

  void _onTab() {
    // Pris en compte dès que l'onglet est atteint, par toucher ou par glissement.
    if (!_tabs.indexIsChanging && _tabs.index != widget.ctl.periodIndex) {
      widget.ctl.selectPeriod(_tabs.index);
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctl = widget.ctl;
    final type = ctl.getEntite().value.type;
    if (type != EntiteEntrepriseType.boutique &&
        type != EntiteEntrepriseType.succursale) {
      return const EmptyPage(
        icon: Icons.query_stats,
        title: 'Aucune entité sélectionnée',
        subtitle: 'Sélectionnez une entité pour voir les statistiques',
      );
    }

    return Column(
      children: [
        AppTabBar(
          controller: _tabs,
          tabs: [for (final t in StatistiquePage._titres) AppTabItem(t)],
          trailing: IconButton(
            tooltip: 'Choisir une période',
            onPressed: () => ctl.pickDateRange(context),
            icon: const Icon(
              AppIcons.calendarBlank,
              color: StatsStyle.ink,
              size: 24,
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: type == EntiteEntrepriseType.boutique
                      ? BoutiqueStatsSubPage(ctl, periodIndex: i)
                      : AtelierStatsSubPage(ctl, periodIndex: i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Plage de dates choisie au calendrier : une seule vue, avec un retour aux
/// trois onglets.
class _PlageLibre extends StatelessWidget {
  final StatistiquePageVctl ctl;
  const _PlageLibre({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final type = ctl.getEntite().value.type;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: StatsStyle.hairline)),
          ),
          child: Row(
            children: [
              const Icon(
                AppIcons.calendarBlank,
                size: 20,
                color: StatsStyle.ink,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => ctl.pickDateRange(context),
                  child: Text(
                    ctl.dateRange.toFrenchDate,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: type == EntiteEntrepriseType.boutique
                ? BoutiqueStatsSubPage(ctl, periodIndex: 3)
                : AtelierStatsSubPage(ctl, periodIndex: 3),
          ),
        ),
      ],
    );
  }
}
