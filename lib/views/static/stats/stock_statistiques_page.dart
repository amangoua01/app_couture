import 'package:ateliya/data/models/stats/stock_kpis.dart';
import 'package:ateliya/data/models/stats/stock_statistiques.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/period_stat.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/select_dash_period_sub_page.dart';
import 'package:ateliya/views/controllers/stats/stock_statistiques_vctl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StockStatistiquesPage extends StatelessWidget {
  const StockStatistiquesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockStatistiquesVctl>(
      init: StockStatistiquesVctl(),
      builder: (ctl) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: const Text("Suivi de Stock",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              elevation: 0,
              centerTitle: true,
              bottom: const TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: "Général"),
                  Tab(text: "Top Modèles"),
                  Tab(text: "Inventaire"),
                  Tab(text: "Par Taille"),
                ],
              ),
            ),
            body: ctl.isLoading && ctl.data == null
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : TabBarView(
                    children: [
                      _GeneralView(ctl: ctl),
                      _TopModelesView(ctl: ctl),
                      _InventaireView(ctl: ctl),
                      _StockParTailleView(ctl: ctl),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _GeneralView extends StatelessWidget {
  final StockStatistiquesVctl ctl;
  const _GeneralView({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final kpis = ctl.data?.kpis ?? StockKpis.fromJson({});
    final evolution = ctl.data?.evolution ?? [];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector Header
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: ToggleSwitch(
                initialLabelIndex: ctl.periodIndex,
                totalSwitches: 4,
                minWidth: (Get.width - 60) / 4,
                cornerRadius: 25,
                activeBgColor: const [AppColors.primary],
                inactiveBgColor: Colors.white,
                activeFgColor: Colors.white,
                inactiveFgColor: Colors.grey[600],
                labels: PeriodStat.values.map((e) => e.libelle).toList(),
                onToggle: (index) {
                  if (index == 3) {
                    ctl.periodIndex = index ?? 0;
                    ctl.update();
                  } else {
                    if (index != null) {
                      ctl.updatePeriod(PeriodStat.values[index]);
                    }
                  }
                },
              ),
            ),
          ),
          PlaceholderBuilder(
              condition: ctl.periodIndex == 3,
              builder: () {
                return Column(
                  children: [
                    const Gap(20),
                    GestureDetector(
                      onTap: () => CBottomSheet.show(
                        child: SelectDashPeriodSubPage(DateTimeRange(
                            start: ctl.params.dateDebut ?? DateTime.now(),
                            end: ctl.params.dateFin ?? DateTime.now())),
                      ).then((e) {
                        if (e is DateTimeRange) {
                          ctl.updatePeriod(PeriodStat.periode,
                              debut: e.start, fin: e.end);
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: AppColors.primary, size: 20),
                                const Gap(10),
                                Text(
                                  DateTimeRange(
                                          start: ctl.params.dateDebut ??
                                              DateTime.now(),
                                          end: ctl.params.dateFin ??
                                              DateTime.now())
                                      .toFrenchDate,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary),
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_drop_down,
                                color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
          const Gap(25),

          _DesignStatCard(
            label: "Stock Actuel Total",
            value: "${kpis.stockActuelTotal ?? 0}",
            icon: Icons.inventory_2_outlined,
            color: AppColors.primary,
            isMainCard: true,
          ),
          const Gap(15),
          Row(
            children: [
              Expanded(
                child: _DesignStatCard(
                  label: "Entrées",
                  value: "+${kpis.qteEntreeTotale ?? 0}",
                  icon: Icons.arrow_downward_rounded,
                  color: Colors.green,
                ),
              ),
              const Gap(15),
              Expanded(
                child: _DesignStatCard(
                  label: "Sorties",
                  value: "-${kpis.qteSortieTotale ?? 0}",
                  icon: Icons.arrow_upward_rounded,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const Gap(30),
          const Text("Évolution du Stock",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Gap(15),
          Container(
            height: 250,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Colors.grey[200], strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 30)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (val, meta) {
                        if (val.toInt() >= 0 &&
                            val.toInt() < evolution.length) {
                          String dateText = evolution[val.toInt()].date ?? "";
                          if (dateText.length >= 8) {
                            dateText = dateText.substring(8);
                          } else if (dateText.contains('-')) {
                            dateText = dateText.split('-').last;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(dateText,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: evolution
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(),
                            e.value.qteEntree?.toDouble() ?? 0))
                        .toList(),
                    color: Colors.green,
                    isCurved: true,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: evolution
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(),
                            e.value.qteSortie?.toDouble() ?? 0))
                        .toList(),
                    color: Colors.red,
                    isCurved: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const Gap(15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ChartLegend(label: "Entrées", color: Colors.green),
              Gap(20),
              _ChartLegend(label: "Sorties", color: Colors.red),
            ],
          ),
          const Gap(30),
          _SummaryTable(kpis: kpis),
          if (ctl.data?.repartition != null) ...[
            const Gap(30),
            _RepartitionDetails(repartition: ctl.data!.repartition!),
          ],
        ],
      ),
    );
  }
}

class _RepartitionDetails extends StatelessWidget {
  final StockRepartition repartition;
  const _RepartitionDetails({required this.repartition});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Détails des Mouvements",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Gap(15),
        Row(
          children: [
            Expanded(
              child: _MoveDetailsCard(
                  title: "Entrées",
                  summary: repartition.entrees,
                  color: Colors.green),
            ),
            const Gap(15),
            Expanded(
              child: _MoveDetailsCard(
                  title: "Sorties",
                  summary: repartition.sorties,
                  color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}

class _MoveDetailsCard extends StatelessWidget {
  final String title;
  final StockMovementSummary? summary;
  final Color color;

  const _MoveDetailsCard(
      {required this.title, this.summary, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 14)),
          const Divider(),
          _TableRow(
              label: "Mouvements", value: "${summary?.nbMouvements ?? 0}"),
          _TableRow(label: "Confirmés", value: "${summary?.confirmes ?? 0}"),
          _TableRow(label: "En attente", value: "${summary?.enAttente ?? 0}"),
          if ((summary?.rejetes ?? 0) > 0)
            _TableRow(
                label: "Rejetés",
                value: "${summary?.rejetes ?? 0}",
                color: Colors.red),
        ],
      ),
    );
  }
}

class _TopModelesView extends StatelessWidget {
  final StockStatistiquesVctl ctl;
  const _TopModelesView({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final list = ctl.data?.topModeles ?? [];
    if (ctl.isLoading && list.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (list.isEmpty) return const EmptyDataWidget();
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Gap(15),
      itemBuilder: (context, index) {
        final item = list[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text("${index + 1}",
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              const Gap(15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.libelle.value,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Gap(4),
                    Text("Taille: ${item.taille.value}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                    const Gap(8),
                    Row(
                      children: [
                        _SmallLabel(
                            text: "Entrées: ${item.qteEntree ?? 0}",
                            color: Colors.green),
                        const Gap(8),
                        _SmallLabel(
                            text: "Sorties: ${item.qteSortie ?? 0}",
                            color: Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${item.stockActuel ?? 0}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: AppColors.primary)),
                  const Text("EN STOCK",
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InventaireView extends StatelessWidget {
  final StockStatistiquesVctl ctl;
  const _InventaireView({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final list = ctl.data?.stockParModele ?? [];
    if (ctl.isLoading && list.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (list.isEmpty) return const EmptyDataWidget();

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Gap(15),
      itemBuilder: (context, index) {
        final group = list[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(group.libelle.value,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${group.nbVariantes ?? 0} variantes",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text("Total: ${group.stockTotal ?? 0}",
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold))),
              children: (group.variantes ?? []).map((v) {
                return Container(
                  decoration: BoxDecoration(
                      border:
                          Border(top: BorderSide(color: Colors.grey.shade100))),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: const Icon(Icons.checkroom,
                        color: Colors.grey, size: 20),
                    title: Text("Taille : ${v.taille.value}",
                        style: const TextStyle(fontSize: 14)),
                    subtitle: Text(
                        "${v.couleur != null ? "${v.couleur.value} • " : ""}${v.prix != null ? v.prix.value.toAmount() : ""}",
                        style: const TextStyle(fontSize: 12)),
                    trailing: Text("${v.stock ?? 0} EN STOCK",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black87)),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _DesignStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isMainCard;

  const _DesignStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isMainCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const Gap(15),
          Text(value,
              style: TextStyle(
                  fontSize: isMainCard ? 28 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const Gap(4),
          Text(label,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _SummaryTable extends StatelessWidget {
  final StockKpis kpis;
  const _SummaryTable({required this.kpis});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Résumé",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Gap(15),
          _TableRow(
              label: "Modèles en boutique",
              value: "${kpis.nbModelesBoutique ?? 0}"),
          const Divider(height: 20),
          _TableRow(
              label: "Modèles sans stock",
              value: "${kpis.nbModelesSansStock ?? 0}",
              color: Colors.orange),
          const Divider(height: 20),
          _TableRow(
              label: "Mouvements Total",
              value: "${kpis.nbMouvementsTotal ?? 0}"),
          _TableRow(
              label: " • Dont Entrées",
              value: "${kpis.nbEntrees ?? 0}",
              color: Colors.green),
          _TableRow(
              label: " • Dont Sorties",
              value: "${kpis.nbSorties ?? 0}",
              color: Colors.red),
          const Divider(height: 20),
          _TableRow(
              label: "Mouvements en attente",
              value: "${kpis.nbMouvementsEnAttente ?? 0}",
              color: Colors.blue),
          const Divider(height: 20),
          _TableRow(
              label: "Solde Net (Entrées-Sorties)",
              value: "${kpis.soldeNet ?? 0}",
              isBold: true),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isBold;

  const _TableRow(
      {required this.label,
      required this.value,
      this.color,
      this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: color ?? Colors.black87)),
      ],
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final String label;
  final Color color;
  const _ChartLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const Gap(6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
class _StockParTailleView extends StatelessWidget {
  final StockStatistiquesVctl ctl;
  const _StockParTailleView({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final list = ctl.data?.stockParTaille ?? [];
    if (ctl.isLoading && list.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (list.isEmpty) return const EmptyDataWidget();
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Gap(15),
      itemBuilder: (context, index) {
        final item = list[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Taille: ${item.taille.value}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const Gap(4),
                  Text("${item.nbModeleBoutique ?? 0} modèles concernés",
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text("${item.stockTotal ?? 0}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primary)),
                    const Text("Total",
                        style: TextStyle(fontSize: 10, color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SmallLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SmallLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4)),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
