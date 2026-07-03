import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/data/models/stats/top_modele_vendu.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/build_card_activity.dart';
import 'package:ateliya/tools/widgets/build_mouvement_card.dart';
import 'package:ateliya/tools/widgets/build_summury_item.dart';
import 'package:ateliya/tools/widgets/c_card.dart';
import 'package:ateliya/tools/widgets/section_container.dart';
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
        // ── Card CA Global ──────────────────────────────────────────────
        CCard(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CHIFFRE D'AFFAIRES GLOBAL",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const Gap(8),
                Text(
                  kpis.chiffreAffaires.toAmount(unit: "Fcfa"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
                const Gap(8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.3)),
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
                const Gap(4),
                Divider(color: Colors.white.withValues(alpha: 0.9)),
                const Gap(4),
                Wrap(
                  spacing: 18,
                  runSpacing: 4,
                  children: [
                    _InfoRow(
                        label: "Recettes nettes : ",
                        value:
                            (kpis.recettesNettes ?? 0).toAmount(unit: "Fcfa")),
                    _InfoRow(
                        label: "Ticket moyen : ",
                        value: (kpis.ticketMoyen ?? 0).toAmount(unit: "Fcfa")),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Gap(24),

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
            children: activities.isNotEmpty
                ? activities
                    .map((act) => BuildCardActivity(
                          icon: _iconForActivity(act.activite),
                          value: (act.nombre ?? 0).toString(),
                          label: act.activite ?? "",
                          iconColor: AppColors.primary,
                        ))
                    .toList()
                : [
                    const BuildCardActivity(
                        icon: Icons.receipt_long_outlined,
                        value: "0",
                        label: "Factures clients",
                        iconColor: AppColors.primary),
                    const BuildCardActivity(
                        icon: Icons.edit_outlined,
                        value: "0",
                        label: "Prises de mesures",
                        iconColor: AppColors.secondary),
                    const BuildCardActivity(
                        icon: Icons.payments_outlined,
                        value: "0",
                        label: "Paiements reçus",
                        iconColor: AppColors.green),
                    const BuildCardActivity(
                        icon: Icons.people_outline,
                        value: "0",
                        label: "Clients actifs",
                        iconColor: AppColors.primary),
                  ],
          ),
        ),
        const Gap(24),

        // ── Caisse & Opérations ─────────────────────────────────────────
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Caisse & Opérations",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: -0.2)),
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
                    iconColor: AppColors.primary),
                BuildCardActivity(
                    icon: Icons.show_chart,
                    value: "${kpis.tauxRecouvrement ?? 0}%",
                    label: "Taux recouvrement",
                    iconColor: AppColors.secondary),
                BuildCardActivity(
                    icon: Icons.attach_money,
                    value: kpis.totalDepenses.toAmount(),
                    label: "Dépenses totales",
                    iconColor: AppColors.secondary),
                BuildMouvementCard(
                    entree: kpis.totalMouvementsEntrants.toAmount(),
                    sortie: kpis.totalMouvementsSortants.toAmount(),
                    label: "Mouvements (FCFA)"),
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
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
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
                ...activities.map((act) => BuildSummuryItem(
                      label: act.activite ?? "",
                      value: "${(act.revenus ?? 0).toAmount()} FCFA",
                      color: AppColors.primary,
                    )),
                BuildSummuryItem(
                    label: "Dépenses",
                    value: "-${kpis.totalDepenses.toAmount()} FCFA",
                    color: AppColors.secondary),
                Divider(
                    height: 28,
                    color: AppColors.fieldBorder.withValues(alpha: 0.6)),
                BuildSummuryItem(
                    label: "Recettes nettes",
                    value: "${(kpis.recettesNettes ?? 0).toAmount()} FCFA",
                    color: AppColors.green,
                    isBold: true),
              ],
            ),
          ),
        ),
        // ── Top modèles vendus ──────────────────────────────────────────
        if ((data.topModelesVendus ?? []).isNotEmpty) ...[
          const Gap(24),
          SectionContainer(
            title: "Top modèles vendus",
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
    if (a.contains('réservation') || a.contains('reservation'))
      return Icons.calendar_today_outlined;
    return Icons.analytics_outlined;
  }
}

class _TopModelesCard extends StatelessWidget {
  final List<TopModeleVendu> modeles;
  const _TopModelesCard({required this.modeles});

  @override
  Widget build(BuildContext context) {
    final maxVentes =
        modeles.map((m) => m.ventes ?? 0).fold(0, (a, b) => a > b ? a : b);
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
        children: modeles.asMap().entries.map((e) {
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
  const _TopModeleItem(
      {required this.rank, required this.modele, required this.maxVentes});

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
                  const Icon(Icons.shopping_bag_outlined,
                      size: 12, color: AppColors.secondary),
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55), fontSize: 12)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
