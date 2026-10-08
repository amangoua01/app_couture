import 'package:ateliya/data/models/stats/comparaison_entite.dart';
import 'package:ateliya/data/models/stats/revenus_quotidiens.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/data/models/stats/top_modele_vendu.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/build_card_activity.dart';
import 'package:ateliya/tools/widgets/build_mouvement_card.dart';
import 'package:ateliya/tools/widgets/build_summury_item.dart';
import 'package:ateliya/tools/widgets/section_container.dart';
import 'package:ateliya/tools/widgets/stats/gradient_overview_panel.dart';
import 'package:ateliya/tools/widgets/stats/repartition_donut.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EntrepriseStatsSubPage extends StatelessWidget {
  final StatistiquesBoutique data;
  final Future<void> Function()? onRefresh;
  const EntrepriseStatsSubPage({super.key, required this.data, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final kpis = data.kpis;
    final activities = data.activitesBoutique ?? [];

    final content = ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // ── Vue d'ensemble ───────────────────────────────────────────────
        GradientOverviewPanel(
          title: "Vue d'ensemble",
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.3),
              ),
            ),
            child: const Text(
              "Période sélectionnée",
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          rows: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CHIFFRE D'AFFAIRES",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const Gap(6),
                Text(
                  kpis.chiffreAffaires.toAmount(unit: "Fcfa"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
              ],
            ),
            KpiTileRow(
              tiles: [
                KpiTile(
                  label: "Recettes nettes",
                  value: (kpis.recettesNettes ?? 0).toAmount(unit: "Fcfa"),
                ),
                KpiTile(
                  label: "Ticket moyen",
                  value: (kpis.ticketMoyen ?? 0).toAmount(unit: "Fcfa"),
                  onInfoTap: () => _showTicketMoyenInfo(context),
                ),
              ],
            ),
            KpiTileRow(
              tiles: [
                KpiTile(
                  label: "Dépenses",
                  value: kpis.totalDepenses.toAmount(unit: "Fcfa"),
                ),
                KpiTile(
                  label: "Taux de recouvrement",
                  value: "${kpis.tauxRecouvrement ?? 0}%",
                ),
              ],
            ),
            if (kpis.delaiMoyenLivraisonJours != null)
              KpiTileRow(
                tiles: [
                  KpiTile(
                    label: "Délai moyen de livraison",
                    value: "${kpis.delaiMoyenLivraisonJours} j",
                  ),
                  KpiTile(
                    label: "Pièces en retard",
                    value: "${kpis.piecesEnRetard ?? 0}",
                    accent:
                        (kpis.piecesEnRetard ?? 0) > 0
                            ? const Color(0xFFE57373)
                            : null,
                  ),
                ],
              ),
            if (kpis.stockTotalBoutique != null)
              KpiTileRow(
                tiles: [
                  KpiTile(
                    label: "Stock total boutique",
                    value: "${kpis.stockTotalBoutique ?? 0}",
                  ),
                  KpiTile(
                    label: "Ventes sur la période",
                    value: "${kpis.nbVentesBoutique ?? 0}",
                  ),
                ],
              ),
          ],
        ),
        const Gap(24),

        // ── Répartition des revenus ──────────────────────────────────────
        if (activities.any((a) => (a.revenus ?? 0) > 0)) ...[
          RepartitionDonut(
            title: "Répartition des revenus",
            slices: [
              for (var i = 0; i < activities.length; i++)
                if ((activities[i].revenus ?? 0) > 0)
                  DonutSlice(
                    label: activities[i].activite ?? "Autre",
                    value: activities[i].revenus!,
                    color:
                        RepartitionDonut.palette[i %
                            RepartitionDonut.palette.length],
                  ),
            ],
          ),
          const Gap(24),
        ],

        // ── Comparaison boutiques / ateliers ──────────────────────────────
        // N'a de sens qu'à partir de 2 entités : avec une seule, il n'y a
        // rien à comparer.
        if ((data.comparaisonEntites ?? []).length > 1) ...[
          SectionContainer(
            title: "Classement par chiffre d'affaires",
            child: _ComparaisonEntitesCard(
              entites: data.comparaisonEntites!,
            ),
          ),
          const Gap(24),
        ],

        // ── Revenus par jour ─────────────────────────────────────────────
        // Masqué entièrement sans données plutôt que d'afficher un
        // graphique vide (confus, ressemble à un bug).
        if (data.revenusQuotidiens.isNotEmpty) ...[
          SectionContainer(
            title: "Revenus",
            child: _RevenusBarChart(items: data.revenusQuotidiens),
          ),
          const Gap(24),
        ],

        // ── Activité globale ────────────────────────────────────────────
        SectionContainer(
          title: "Activité globale",
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.3,
            children:
                activities.isNotEmpty
                    ? activities
                        .map(
                          (act) => BuildCardActivity(
                            icon: _iconForActivity(act.activite),
                            value: (act.nombre ?? 0).toString(),
                            label: act.activite ?? "",
                            iconColor: AppColors.primary,
                          ),
                        )
                        .toList()
                    : [
                      const BuildCardActivity(
                        icon: Icons.receipt_long_outlined,
                        value: "0",
                        label: "Factures clients",
                        iconColor: AppColors.primary,
                      ),
                      const BuildCardActivity(
                        icon: Icons.edit_outlined,
                        value: "0",
                        label: "Prises de mesures",
                        iconColor: AppColors.secondary,
                      ),
                      const BuildCardActivity(
                        icon: Icons.payments_outlined,
                        value: "0",
                        label: "Paiements reçus",
                        iconColor: AppColors.green,
                      ),
                      const BuildCardActivity(
                        icon: Icons.people_outline,
                        value: "0",
                        label: "Clients actifs",
                        iconColor: AppColors.primary,
                      ),
                    ],
          ),
        ),
        const Gap(24),

        // ── Caisse & Opérations ─────────────────────────────────────────
        // Taux recouvrement / Dépenses / Délai / Retard sont déjà dans le
        // panneau "Vue d'ensemble" ci-dessus : seuls la caisse et les
        // mouvements (absents de ce panneau) restent ici, pour éviter
        // d'afficher deux fois les mêmes chiffres sur un même écran.
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Caisse & Opérations",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.2,
              ),
            ),
            const Gap(12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.3,
              children: [
                BuildCardActivity(
                  icon: Icons.account_balance_wallet_outlined,
                  value: kpis.caisse.toAmount(),
                  label: "Solde caisse (FCFA)",
                  iconColor: AppColors.primary,
                ),
                BuildMouvementCard(
                  entree: kpis.totalMouvementsEntrants.toAmount(),
                  sortie: kpis.totalMouvementsSortants.toAmount(),
                  label: "Mouvements (FCFA)",
                ),
              ],
            ),
          ],
        ),
        const Gap(24),

        // ── Résumé financier ────────────────────────────────────────────
        SectionContainer(
          title: "Résumé financier",
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ...activities.map(
                  (act) => BuildSummuryItem(
                    label: act.activite ?? "",
                    value: "${(act.revenus ?? 0).toAmount()} FCFA",
                    color: AppColors.primary,
                  ),
                ),
                BuildSummuryItem(
                  label: "Dépenses",
                  value: "-${kpis.totalDepenses.toAmount()} FCFA",
                  color: AppColors.secondary,
                ),
                Divider(
                  height: 28,
                  color: AppColors.fieldBorder.withValues(alpha: 0.6),
                ),
                BuildSummuryItem(
                  label: "Recettes nettes",
                  value: "${(kpis.recettesNettes ?? 0).toAmount()} FCFA",
                  color: AppColors.green,
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
        // ── Top modèles vendus / types de pièce cousus ──────────────────
        if ((data.topModelesVendus ?? []).isNotEmpty) ...[
          const Gap(24),
          SectionContainer(
            title:
                kpis.delaiMoyenLivraisonJours != null
                    ? "Pièces les plus cousues"
                    : "Top modèles vendus",
            child: _TopModelesCard(modeles: data.topModelesVendus!),
          ),
        ],
        const Gap(32),
      ],
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        color: AppColors.secondary,
        onRefresh: onRefresh!,
        child: content,
      );
    }
    return content;
  }

  IconData _iconForActivity(String? activite) {
    final a = activite?.toLowerCase() ?? '';
    if (a.contains('facture')) return Icons.receipt_long_outlined;
    if (a.contains('mesure')) return Icons.edit_outlined;
    if (a.contains('paiement')) return Icons.payments_outlined;
    if (a.contains('client')) return Icons.people_outline;
    if (a.contains('vente')) return Icons.shopping_bag_outlined;
    if (a.contains('réservation') || a.contains('reservation')) {
      return Icons.calendar_today_outlined;
    }
    return Icons.analytics_outlined;
  }

  void _showTicketMoyenInfo(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Ticket moyen"),
            content: const Text(
              "Montant moyen encaissé par vente sur la période sélectionnée "
              "(chiffre d'affaires ÷ nombre de ventes). Plus il est élevé, "
              "plus chaque client dépense en moyenne.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Compris"),
              ),
            ],
          ),
    );
  }
}

class _TopModelesCard extends StatelessWidget {
  final List<TopModeleVendu> modeles;
  const _TopModelesCard({required this.modeles});

  @override
  Widget build(BuildContext context) {
    final maxVentes = modeles
        .map((m) => m.ventes ?? 0)
        .fold(0, (a, b) => a > b ? a : b);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children:
            modeles.asMap().entries.map((e) {
              final isLast = e.key == modeles.length - 1;
              return Column(
                children: [
                  _TopModeleItem(
                    rank: e.key + 1,
                    modele: e.value,
                    maxVentes: maxVentes,
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.fieldBorder.withValues(alpha: 0.6),
                    ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

class _TopModeleItem extends StatelessWidget {
  final int rank;
  final TopModeleVendu modele;
  final int maxVentes;
  const _TopModeleItem({
    required this.rank,
    required this.modele,
    required this.maxVentes,
  });

  Color get _barColor {
    if (rank == 1) return AppColors.secondary;
    if (rank == 2) return AppColors.green;
    return AppColors.primary.withValues(alpha: 0.35);
  }

  @override
  Widget build(BuildContext context) {
    final ventes = modele.ventes ?? 0;
    final ratio = maxVentes > 0 ? ventes / maxVentes : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Text(
              "$rank",
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 11,
                color: AppColors.primary,
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modele.nom ?? "-",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 5,
                    backgroundColor: AppColors.ligthGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(_barColor),
                  ),
                ),
              ],
            ),
          ),
          const Gap(14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 12,
                    color: AppColors.secondary,
                  ),
                  const Gap(3),
                  Text(
                    "$ventes ventes",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const Gap(2),
              Text(
                "${(modele.revenus ?? 0).toAmount()} FCFA",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComparaisonEntitesCard extends StatelessWidget {
  final List<ComparaisonEntite> entites;
  const _ComparaisonEntitesCard({required this.entites});

  @override
  Widget build(BuildContext context) {
    final maxCa = entites
        .map((e) => e.chiffreAffaires)
        .fold(0, (a, b) => a > b ? a : b);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children:
            entites.asMap().entries.map((e) {
              final isLast = e.key == entites.length - 1;
              return Column(
                children: [
                  _ComparaisonEntiteItem(
                    rank: e.key + 1,
                    entite: e.value,
                    maxCa: maxCa,
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.fieldBorder.withValues(alpha: 0.6),
                    ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

class _ComparaisonEntiteItem extends StatelessWidget {
  final int rank;
  final ComparaisonEntite entite;
  final int maxCa;
  const _ComparaisonEntiteItem({
    required this.rank,
    required this.entite,
    required this.maxCa,
  });

  Color get _barColor {
    if (rank == 1) return AppColors.secondary;
    if (rank == 2) return AppColors.green;
    return AppColors.primary.withValues(alpha: 0.35);
  }

  @override
  Widget build(BuildContext context) {
    final ca = entite.chiffreAffaires;
    final ratio = maxCa > 0 ? ca / maxCa : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Text(
              "$rank",
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 11,
                color: AppColors.primary,
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      entite.isBoutique
                          ? Icons.storefront_outlined
                          : Icons.content_cut_outlined,
                      size: 13,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                    const Gap(5),
                    Expanded(
                      child: Text(
                        entite.nom ?? "-",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 5,
                    backgroundColor: AppColors.ligthGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(_barColor),
                  ),
                ),
              ],
            ),
          ),
          const Gap(14),
          Text(
            "${ca.toAmount()} FCFA",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Revenus par jour, en barres — remplace l'absence totale de graphique
/// qu'avait cet écran jusqu'ici (uniquement des chiffres et des grilles).
class _RevenusBarChart extends StatelessWidget {
  final List<RevenusQuotidiens> items;
  const _RevenusBarChart({required this.items});

  @override
  Widget build(BuildContext context) {
    final maxY = items
        .map((e) => e.revenus.toDouble())
        .fold<double>(0, (a, b) => a > b ? a : b);
    // Pas plus d'une dizaine d'étiquettes affichées même avec 30 jours de
    // données, sinon elles se chevauchent et deviennent illisibles.
    final labelStep = (items.length / 8).ceil().clamp(1, items.length);

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(12, 20, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY == 0 ? 1 : maxY * 1.2,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine:
                (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (val, meta) {
                  final i = val.toInt();
                  if (i < 0 || i >= items.length || i % labelStep != 0) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      items[i].jour ?? '',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < items.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: items[i].revenus.toDouble(),
                    color: AppColors.primary,
                    width: items.length > 15 ? 6 : 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

