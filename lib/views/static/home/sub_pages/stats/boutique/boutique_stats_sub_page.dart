import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/views/controllers/home/statistique_page_vctl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BoutiqueStatsSubPage extends StatelessWidget {
  final StatistiquePageVctl ctl;
  const BoutiqueStatsSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    final data = ctl.data;
    final kpis = data.kpis;

    return RefreshIndicator(
      onRefresh: ctl.fetchStats,
      child: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _buildRevenueCard(kpis),
          const Gap(25),
          _buildEvolutionSection(ctl),
          const Gap(25),
          _buildActivitySection(data),
          const Gap(25),
          _buildCaisseStockSection(kpis),
          const Gap(25),
          _buildRevenueDistributionSection(data),
          const Gap(25),
          _buildFinancialSummarySection(data),
          const Gap(30),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(Kpis kpis) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E8FFA), Color(0xFF7B66FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B66FF).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CHIFFRE D'AFFAIRES",
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
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              "Période sélectionnée",
              style: TextStyle(
                color: Colors.white,
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

  Widget _buildEvolutionSection(StatistiquePageVctl ctl) {
    final revenus = ctl.data.revenusQuotidiens;
    if (revenus.isEmpty) return const SizedBox.shrink();

    // Take last 7 days or all if less
    final displayRevenus =
        revenus.length > 7 ? revenus.sublist(revenus.length - 7) : revenus;

    return _SectionContainer(
      title: "Évolution du CA",
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
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
                  reservedSize: 40,
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
                color: AppColors.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                    show: true, color: AppColors.primary.withOpacity(0.1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySection(StatistiquesBoutique data) {
    final activities = data.activitesBoutique ?? [];
    int ventesDirectes = 0;
    int reservationsActives = data.kpis.reservationsActives;

    for (var act in activities) {
      if (act.activite?.toLowerCase().contains("ventes directes") ?? false) {
        ventesDirectes = act.nombre ?? 0;
      }
    }

    return _SectionContainer(
      title: "Activité commerciale",
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.3,
        children: [
          _buildActivityCard(
              icon: Icons.shopping_bag_outlined,
              value: ventesDirectes.toString(),
              label: "Ventes directes",
              iconColor: Colors.teal),
          _buildActivityCard(
              icon: Icons.calendar_today_outlined,
              value: reservationsActives.toString(),
              label: "Réservations actives",
              iconColor: Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildCaisseStockSection(Kpis kpis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Caisse & Stock",
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
                label: "Solde caisse (FCFA)",
                iconColor: Colors.teal),
            _buildActivityCard(
                icon: Icons.show_chart,
                value: "${kpis.tauxRecouvrement ?? 0}%",
                label: "Taux recouvrement",
                iconColor: Colors.orange),
            _buildActivityCard(
                icon: Icons.inventory_2_outlined,
                value: (kpis.stockTotalBoutique ?? 0).toString(),
                label: "Stock total boutique",
                iconColor: Colors.blue),
            _buildMovementCard(kpis),
          ],
        ),
        if (kpis.nombreModelesStockBas != null &&
            kpis.nombreModelesStockBas! > 0)
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: _buildAlertCard(kpis.nombreModelesStockBas!),
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
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.sync, color: Colors.green, size: 20),
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

  Widget _buildAlertCard(int count) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 24),
          ),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$count alertes de stock critique",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                const Text("Veuillez vérifier vos niveaux de stock",
                    style: TextStyle(fontSize: 12, color: Colors.redAccent)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildRevenueDistributionSection(StatistiquesBoutique data) {
    final distribution = data.revenusParType;
    if (distribution.isEmpty) return const SizedBox.shrink();

    final colors = [
      Colors.teal.shade300,
      Colors.indigo.shade400,
      Colors.orange.shade400,
      Colors.blue.shade400,
      Colors.purple.shade400,
    ];

    return _SectionContainer(
      title: "Répartition des revenus",
      child: SizedBox(
        height: 250,
        child: PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 70,
            sections: List.generate(distribution.length, (i) {
              final item = distribution[i];
              return PieChartSectionData(
                color: colors[i % colors.length],
                value: (item.revenus ?? 0).toDouble(),
                title: '',
                radius: 25,
              );
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
              color: Colors.teal, fontSize: 12, fontWeight: FontWeight.bold)),
      child: Column(
        children: [
          ...activities.map((act) => _buildSummaryItem(
              label: act.activite ?? "",
              value: "${(act.revenus ?? 0).toAmount()} FCFA",
              color: Colors.teal)),
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
