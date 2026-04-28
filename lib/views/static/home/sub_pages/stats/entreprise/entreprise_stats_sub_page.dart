import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
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

    Widget content = ListView(
      padding: const EdgeInsets.all(15),
      children: [
        _buildRevenueCard(kpis),
        const Gap(25),
        _buildEvolutionSection(data),
        const Gap(25),
        _buildKeyIndicatorsSection(kpis),
        const Gap(25),
        _buildGlobalActivitySection(data),
        const Gap(25),
        _buildTresorerieSection(kpis),
        const Gap(25),
        _buildEntityDistributionSection(data),
        const Gap(25),
        _buildFinancialSummarySection(data),
        const Gap(25),
        _buildTopModelesSection(data),
        const Gap(30),
      ],
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: content,
      );
    }
    return content;
  }

  Widget _buildRevenueCard(Kpis kpis) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CHIFFRE D'AFFAIRES GLOBAL",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Gap(8),
          Text(
            "${kpis.chiffreAffaires.toAmount()} FCFA",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              "Période sélectionnée",
              style: TextStyle(
                color: Color(0xFFF59E0B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Gap(15),
          const Divider(color: Colors.white24),
          const Gap(10),
          Wrap(
            spacing: 15,
            children: [
              _InfoRow(
                  label: "Recettes nettes : ",
                  value: "${(kpis.recettesNettes ?? 0).toAmount()} FCFA"),
              _InfoRow(
                  label: "Ticket moyen : ",
                  value: "${(kpis.ticketMoyen ?? 0).toAmount()} FCFA"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEvolutionSection(StatistiquesBoutique data) {
    final revenus = data.revenusQuotidiens;
    if (revenus.isEmpty) return const SizedBox.shrink();

    // Take last 7 days or all if less
    final displayRevenus =
        revenus.length > 7 ? revenus.sublist(revenus.length - 7) : revenus;

    return _SectionContainer(
      title: "Tendance CA Global",
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(right: 20, top: 10),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true, drawVerticalLine: false),
            titlesData: FlTitlesData(
              show: true,
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < displayRevenus.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(displayRevenus[index].jour ?? "",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  interval: 1,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text(
                      value.toInt().toAmount(),
                      style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  reservedSize: 35,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(displayRevenus.length, (i) {
                  return FlSpot(
                      i.toDouble(), displayRevenus[i].revenus.toDouble());
                }),
                isCurved: true,
                color: const Color(0xFF1E293B),
                barWidth: 3,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFF1E293B).withOpacity(0.05)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyIndicatorsSection(Kpis kpis) {
    return _SectionContainer(
      title: "Indicateurs clés",
      child: Row(
        children: [
          Expanded(
              child: _buildKeyIndicatorCard(
                  icon: Icons.store_outlined,
                  value: (kpis.clientsActifs).toString(),
                  label: "Clients actifs")),
          const Gap(10),
          Expanded(
              child: _buildKeyIndicatorCard(
                  icon: Icons.content_cut_outlined,
                  value: (kpis.commandesEnCours).toString(),
                  label: "Cmds en cours")),
          const Gap(10),
          Expanded(
              child: _buildKeyIndicatorCard(
                  icon: Icons.people_outline,
                  value: (kpis.reservationsActives).toString(),
                  label: "Réservations")),
        ],
      ),
    );
  }

  Widget _buildGlobalActivitySection(StatistiquesBoutique data) {
    final activities = data.activitesBoutique ?? [];
    return _SectionContainer(
      title: "Activité globale",
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.3,
        children: activities.map<Widget>((act) {
          return _buildActivityCard(
              icon: Icons.analytics_outlined,
              value: (act.nombre ?? 0).toString(),
              label: act.activite ?? "",
              iconColor: Colors.teal);
        }).toList(),
      ),
    );
  }

  Widget _buildTresorerieSection(Kpis kpis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Trésorerie",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const Gap(15),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.3,
          children: [
            _buildActivityCard(
                icon: Icons.account_balance_wallet_outlined,
                value: kpis.caisse.toAmount(),
                label: "Caisse totale (FCFA)",
                iconColor: Colors.teal),
            _buildActivityCard(
                icon: Icons.show_chart,
                value: "${kpis.tauxRecouvrement ?? 0}%",
                label: "Taux recouvrement",
                iconColor: Colors.orange),
            _buildActivityCard(
                icon: Icons.attach_money,
                value: kpis.totalDepenses.toAmount(),
                label: "Dépenses totales",
                iconColor: Colors.red),
            _buildMovementCard(kpis),
          ],
        ),
      ],
    );
  }

  Widget _buildMovementCard(Kpis kpis) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.sync, color: Colors.blue, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Entrées: ",
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text("+ ${kpis.totalMouvementsEntrants.toAmount()}",
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                ],
              ),
              Row(
                children: [
                  const Text("Sorties: ",
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text("- ${kpis.totalMouvementsSortants.toAmount()}",
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ],
              ),
              const Gap(2),
              const Text("Mouvements (FCFA)",
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntityDistributionSection(StatistiquesBoutique data) {
    final distribution = data.revenusParType;
    if (distribution.isEmpty) return const SizedBox.shrink();

    final colors = [
      Colors.teal.shade400,
      Colors.orange.shade400,
      Colors.indigo.shade400,
      Colors.blue.shade400,
    ];

    return _SectionContainer(
      title: "Répartition globale des revenus",
      child: SizedBox(
        height: 250,
        child: PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 70,
            sections: List.generate(distribution.length, (i) {
              return PieChartSectionData(
                  color: colors[i % colors.length],
                  value: (distribution[i].revenus ?? 0).toDouble(),
                  title: '',
                  radius: 25);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialSummarySection(StatistiquesBoutique data) {
    final activities = data.activitesBoutique ?? [];
    final kpis = data.kpis;

    return _SectionContainer(
      title: "Résumé financier",
      trailing: const Text("Détails →",
          style: TextStyle(
              color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
      child: Column(
        children: [
          ...activities.map((act) => _buildSummaryItem(
              label: act.activite ?? "",
              value: "${(act.revenus ?? 0).toAmount()} FCFA",
              color: Colors.teal)),
          _buildSummaryItem(
              label: "Ventes directes",
              value: "${(kpis.revenusVenteDirecte ?? 0).toAmount()} FCFA",
              color: Colors.blue),
          _buildSummaryItem(
              label: "Factures réglées",
              value: "${(kpis.revenusFactures ?? 0).toAmount()} FCFA",
              color: Colors.orange),
          _buildSummaryItem(
              label: "Réservations",
              value: "${(kpis.revenusReservations ?? 0).toAmount()} FCFA",
              color: Colors.purple),
          _buildSummaryItem(
              label: "Dépenses",
              value: "-${kpis.totalDepenses.toAmount()} FCFA",
              color: Colors.red),
          const Divider(height: 30),
          _buildSummaryItem(
              label: "Recettes nettes",
              value: "${(kpis.recettesNettes ?? 0).toAmount()} FCFA",
              color: Colors.green,
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildTopModelesSection(StatistiquesBoutique data) {
    final topModeles = data.topModelesVendus ?? [];
    if (topModeles.isEmpty) return const SizedBox.shrink();

    return _SectionContainer(
      title: "Top modèles vendus",
      child: Column(
        children: topModeles.map<Widget>((modele) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.dry_cleaning,
                      color: AppColors.primary, size: 20),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(modele.nom ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("${modele.ventes} ventes",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Text(
                  "${(modele.revenus ?? 0).toAmount()} FCFA",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primary),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKeyIndicatorCard(
      {required IconData icon, required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1E293B), size: 24),
          const Gap(10),
          FittedBox(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
      {required IconData icon,
      required String value,
      required String label,
      required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(value,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
              ),
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      {required String label,
      required String value,
      required Color color,
      bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const Gap(10),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isBold ? color : Colors.black87)),
        ],
      ),
    );
  }
}

class _SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  const _SectionContainer(
      {required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            if (trailing != null) trailing!,
          ],
        ),
        const Gap(15),
        child,
      ],
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
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
