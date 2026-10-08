import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/tools/widgets/shimmer_listtile.dart';
import 'package:ateliya/tools/widgets/total_summary_card.dart';
import 'package:ateliya/views/controllers/depense/depense_list_page_vctl.dart';
import 'package:ateliya/views/static/depense/depense_detail_page.dart';
import 'package:ateliya/views/static/depense/edition_depense_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DepenseListPage extends StatelessWidget {
  const DepenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DepenseListPageVctl(),
      builder: (ctl) {
        final items = ctl.itemsFiltres;

        // Sous-total du jour, calculé une fois plutôt qu'à chaque ligne.
        final totauxParJour = <String, double>{};
        for (final d in items) {
          final dt = d.createdAt.toDateTime();
          if (dt == null) continue;
          final cle = "${dt.year}-${dt.month}-${dt.day}";
          totauxParJour[cle] = (totauxParJour[cle] ?? 0) + (double.tryParse(d.montant ?? '0') ?? 0);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7FAF8),
          appBar: AppBar(title: const Text("Mes dépenses")),
          body: Column(
            children: [
              TotalSummaryCard(
                label: "Total des dépenses",
                total: ctl.totalFiltre,
                count: items.length,
                countLabel: "dépense${items.length > 1 ? 's' : ''}",
                negative: true,
              ),
              const Gap(12),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _FiltrePill(
                      label: "Toutes",
                      actif: ctl.filtre == DepenseFiltre.toutes,
                      onTap: () => ctl.setFiltre(DepenseFiltre.toutes),
                    ),
                    _FiltrePill(
                      label: "Cette semaine",
                      actif: ctl.filtre == DepenseFiltre.semaine,
                      onTap: () => ctl.setFiltre(DepenseFiltre.semaine),
                    ),
                    _FiltrePill(
                      label: "Ce mois",
                      actif: ctl.filtre == DepenseFiltre.mois,
                      onTap: () => ctl.setFiltre(DepenseFiltre.mois),
                    ),
                    _FiltrePill(
                      label: "Personnel",
                      actif: ctl.filtre == DepenseFiltre.personnel,
                      onTap: () => ctl.setFiltre(DepenseFiltre.personnel),
                    ),
                  ],
                ),
              ),
              const Gap(4),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: ctl.getList,
                  child: PlaceholderWidget(
                    condition: !ctl.isLoading,
                    placeholder: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 6,
                      itemBuilder: (_, __) => const ShimmerListtile(),
                    ),
                    child: PlaceholderWidget(
                      condition: items.isNotEmpty,
                      placeholder: const EmptyDataWidget(
                        message: "Aucune dépense pour le moment.",
                      ),
                      child: ListView.builder(
                        controller: ctl.scrollCtl,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 110),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final depense = items[i];
                          final category = depense.familleDepense?.libelle ?? 'Dépense générale';
                          final group = depense.familleDepense?.groupeDepense?.libelle;
                          final date = depense.createdAt.toDateTime();

                          final previousDate = i > 0 ? items[i - 1].createdAt.toDateTime() : null;
                          final showHeader = date != null && (previousDate == null || !date.isSameDate(previousDate));

                          String dateLabel = '';
                          double totalJour = 0;
                          if (date != null) {
                            final now = DateTime.now();
                            final yesterday = now.subtract(const Duration(days: 1));
                            if (date.isSameDate(now)) {
                              dateLabel = "Aujourd'hui";
                            } else if (date.isSameDate(yesterday)) {
                              dateLabel = "Hier";
                            } else {
                              dateLabel = depense.createdAt.toFrenchDate;
                            }
                            totalJour = totauxParJour["${date.year}-${date.month}-${date.day}"] ?? 0;
                          }

                          final accent = _categoryColor(category);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showHeader)
                                Padding(
                                  padding: EdgeInsets.fromLTRB(16, i == 0 ? 8 : 18, 16, 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        dateLabel,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.grey.shade600,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "-${totalJour.round().toAmount()} FCFA",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(width: 4, color: accent),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => Get.to(() => DepenseDetailPage(depense: depense)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 42,
                                                  height: 42,
                                                  decoration: BoxDecoration(
                                                    color: accent.withValues(alpha: 0.12),
                                                    borderRadius: BorderRadius.circular(13),
                                                  ),
                                                  child: Center(
                                                    child: Icon(Icons.receipt_long_rounded, color: accent, size: 21),
                                                  ),
                                                ),
                                                const Gap(12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        group != null ? "$category ($group)" : category,
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.w700, fontSize: 14),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const Gap(3),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.schedule_rounded, size: 11, color: Colors.grey.shade400),
                                                          const Gap(3),
                                                          Text(
                                                            depense.createdAt.toTime,
                                                            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
                                                          ),
                                                          if ((depense.description ?? '').isNotEmpty) ...[
                                                            const Gap(6),
                                                            Expanded(
                                                              child: Text(
                                                                "· ${depense.description}",
                                                                style: TextStyle(
                                                                    fontSize: 11.5,
                                                                    color: Colors.grey.shade500,
                                                                    fontStyle: FontStyle.italic),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Gap(8),
                                                Text(
                                                  "-${depense.montant.toAmount(unit: "FCFA")}",
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 14,
                                                      color: Color(0xFFB91C1C),
                                                      letterSpacing: -0.2),
                                                ),
                                                const Gap(4),
                                                Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey.shade300),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final res = await Get.to(() => const EditionDepensePage());
                  if (res != null) {
                    ctl.data.items.insert(0, res);
                    ctl.update();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                icon: const Icon(Icons.add_rounded, size: 22),
                label: const Text(
                  "Nouvelle dépense",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Couleur stable par catégorie (même nom → même couleur), pour que la
  /// liste ne soit pas monochrome sans configuration à gérer par ailleurs.
  static const _palette = [
    Color(0xFFDC2626),
    Color(0xFFD97706),
    Color(0xFF7C3AED),
    Color(0xFF0D9488),
    Color(0xFF2563EB),
    Color(0xFFDB2777),
  ];

  Color _categoryColor(String category) {
    final hash = category.codeUnits.fold<int>(0, (a, b) => a + b);
    return _palette[hash % _palette.length];
  }
}

class _FiltrePill extends StatelessWidget {
  final String label;
  final bool actif;
  final VoidCallback onTap;

  const _FiltrePill({required this.label, required this.actif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: actif ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: actif ? AppColors.primary : Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: actif ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
