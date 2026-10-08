import 'package:ateliya/data/models/employe.dart';
import 'package:ateliya/data/models/pointage.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/date_time_range.dart';
import 'package:ateliya/views/controllers/ouvriers/pointage_historique_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PointageHistoriquePage extends StatelessWidget {
  final Employe employe;
  const PointageHistoriquePage({super.key, required this.employe});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PointageHistoriquePageVctl(employe),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: AppBar(
            title: Text(employe.nomComplet ?? employe.nom ?? "Historique"),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: () => ctl.pickRange(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range_rounded, color: AppColors.primary, size: 20),
                        const Gap(10),
                        Expanded(
                          child: Text(
                            ctl.range.toFrenchDate,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade500),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ctl.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ctl.pointages.isEmpty
                        ? Center(
                            child: Text(
                              "Aucun pointage sur cette période",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: ctl.charger,
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              itemCount: ctl.pointages.length,
                              itemBuilder: (_, i) => _PointageCard(p: ctl.pointages[i]),
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PointageCard extends StatelessWidget {
  final Pointage p;
  const _PointageCard({required this.p});

  String get _dateLabel {
    final d = DateTime.tryParse(p.dateJour ?? '');
    if (d == null) return p.dateJour ?? '-';
    return DateFormat('EEEE d MMMM', 'fr_FR').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _dateLabel[0].toUpperCase() + _dateLabel.substring(1),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
              ),
              if (p.piecesTerminees > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${p.piecesTerminees} pièce(s)",
                    style: const TextStyle(
                        fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              Icon(Icons.login_rounded, size: 15, color: Colors.grey.shade500),
              const Gap(4),
              Text(p.arrivee ?? '--:--', style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700)),
              const Gap(16),
              Icon(Icons.logout_rounded, size: 15, color: Colors.grey.shade500),
              const Gap(4),
              Text(p.depart ?? '--:--', style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700)),
              if (p.dureeMinutes > 0) ...[
                const Gap(16),
                Icon(Icons.schedule_rounded, size: 15, color: Colors.grey.shade500),
                const Gap(4),
                Text(
                  "${(p.dureeMinutes / 60).toStringAsFixed(1)} h",
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
                ),
              ],
            ],
          ),
          if (p.lignes.isNotEmpty) ...[
            const Gap(10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final l in p.lignes)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${l.typeMesureLibelle ?? 'Autre'} : ${l.quantite}",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.blueGrey),
                    ),
                  ),
              ],
            ),
          ],
          if (p.piecesEnCours > 0) ...[
            const Gap(8),
            Text(
              "${p.piecesEnCours} pièce(s) en cours",
              style: TextStyle(fontSize: 11.5, color: Colors.orange.shade800, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
