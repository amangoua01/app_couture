import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/ligne_entree_stock.dart';
import 'package:ateliya/data/models/ravitaillement_stock.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/shimmer_listtile.dart';
import 'package:ateliya/views/controllers/ravitaillement/ravitaillement_list_vctl.dart';
import 'package:ateliya/views/static/ravitaillement/edition_ravitaillement_page.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RavitaillementListPage extends StatelessWidget {
  const RavitaillementListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RavitaillementListVctl(),
      builder: (ctl) {
        final enAttenteList = ctl.items.where((i) => i.isEnAttente).toList();
        final historiqueList = ctl.items.where((i) => !i.isEnAttente).toList();

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAF9),
            appBar: AppBar(
              title: const Text('Ravitaillements'),
              actions: [
                if (!ctl.isLoading)
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Actualiser',
                    onPressed: () => ctl.fetchData(),
                  ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey[600],
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      tabs: const [
                        Tab(text: "En attente", height: 38),
                        Tab(text: "Historique", height: 38),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: Visibility(
              visible: ctl.user.isAdmin,
              child: FloatingActionButton(
                onPressed: () async {
                  final res =
                      await Get.to(() => const EditionRavitaillementPage());
                  if (res == true) ctl.fetchData();
                },
                child: const Icon(Icons.add_rounded),
              ),
            ),
            body: Column(
              children: [
                // ── Filtre de date ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                  child: GestureDetector(
                    onTap: () => _showDatePicker(context, ctl),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          const Gap(14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Période de filtrage",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary.withValues(alpha: 0.5),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const Gap(3),
                                Text(
                                  "${DateFormat('dd/MM/yyyy').format(ctl.dateRange.start)}  -  ${DateFormat('dd/MM/yyyy').format(ctl.dateRange.end)}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Modifier",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Contenu ───────────────────────────────────────────────────
                Expanded(
                  child: ctl.isLoading
                      ? ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: 8,
                          itemBuilder: (_, __) => const ShimmerListtile(),
                        )
                      : TabBarView(
                          children: [
                            _buildList(ctl, enAttenteList),
                            _buildList(ctl, historiqueList),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(RavitaillementListVctl ctl, List<RavitaillementStock> items) {
    if (items.isEmpty) {
      return EmptyDataWidget(
        message: 'Aucun ravitaillement trouvé',
        onRefresh: ctl.fetchData,
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!ctl.isLoading &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
          ctl.loadMore();
        }
        return true;
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 80),
        itemCount: items.length + (ctl.hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const Gap(12),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          final item = items[index];
          return _RavitaillementCard(item: item, ctl: ctl);
        },
      ),
    );
  }

  void _showDatePicker(BuildContext context, RavitaillementListVctl ctl) {
    CBottomSheet.show(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Text(
                "Filtrer par date",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            const Gap(8),
            CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
                selectedDayHighlightColor: AppColors.primary,
              ),
              value: [ctl.dateRange.start, ctl.dateRange.end],
              onValueChanged: (dates) {
                if (dates.length >= 2) {
                  ctl.updateDateRange(
                    DateTimeRange(
                      start: dates[0],
                      end: dates[1],
                    ),
                  );
                  Get.back();
                }
              },
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

class _RavitaillementCard extends StatelessWidget {
  final RavitaillementStock item;
  final RavitaillementListVctl ctl;
  const _RavitaillementCard({required this.item, required this.ctl});

  @override
  Widget build(BuildContext context) {
    final isEnAttente = item.isEnAttente;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── En-tête : date + statut ─────────────────────────────────
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    size: 18, color: AppColors.primary),
                const Gap(6),
                Expanded(
                  child: Text(
                    item.dateFormatted,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                _StatutBadge(isEnAttente: isEnAttente, statut: item.statut),
              ],
            ),
            const Gap(4),
            // Boutique
            if (item.boutique != null)
              Row(
                children: [
                  Icon(Icons.storefront_outlined,
                      size: 13, color: Colors.grey[400]),
                  const Gap(4),
                  Text(
                    item.boutique!.libelle.value,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            const Gap(10),
            const Divider(height: 1),
            const Gap(10),

            // ── Lignes ──────────────────────────────────────────────────
            ...item.ligneEntres.map((ligne) => _LigneTile(ligne: ligne)),

            // ── Total ───────────────────────────────────────────────────
            if (item.ligneEntres.length > 1) ...[
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total : ${item.quantite} unité(s)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],

            // ── Actions Confirmer / Rejeter (admin + EN_ATTENTE) ────────
            if (ctl.user.isAdmin && item.isEnAttente) ...[
              const Gap(10),
              const Divider(height: 1),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: CButton(
                      onPressed: () => ctl.rejeter(item),
                      title: "Annuler",
                      icon: const Icon(Icons.close_rounded, color: Colors.red),
                      color: Colors.white,
                      radius: 10,
                      textColor: Colors.red,
                      border: const BorderSide(color: Colors.red),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: CButton(
                      onPressed: () => ctl.confirmer(item),
                      title: "Confirmer",
                      icon:
                          const Icon(Icons.check_rounded, color: Colors.white),
                      color: AppColors.primary,
                      radius: 10,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LigneTile extends StatelessWidget {
  final LigneEntreeStock ligne;
  const _LigneTile({required this.ligne});

  @override
  Widget build(BuildContext context) {
    final modele = ligne.modele;
    final photo = modele?.modele?.photo;
    final String? photoUrl = (photo is FichierServer) ? photo.fullUrl : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Miniature
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 44,
              height: 44,
              color: Colors.grey.shade100,
              child: photoUrl != null
                  ? Image.network(photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                            size: 22,
                          ))
                  : const Icon(Icons.shopping_bag_outlined,
                      color: Colors.grey, size: 22),
            ),
          ),
          const Gap(10),
          // Nom + taille
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modele?.modele?.libelle?.value ?? '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                if (modele?.taille != null)
                  Text(
                    'Taille : ${modele!.taille}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
          // Quantité
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+${ligne.quantite}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatutBadge extends StatelessWidget {
  final bool isEnAttente;
  final String? statut;
  const _StatutBadge({required this.isEnAttente, this.statut});

  @override
  Widget build(BuildContext context) {
    final isRejete = statut == 'REJETE';
    final Color bg;
    final Color fg;
    final String label;

    if (isRejete) {
      bg = Colors.red.withValues(alpha: 0.12);
      fg = Colors.red[700]!;
      label = 'Rejeté';
    } else if (isEnAttente) {
      bg = Colors.orange.withValues(alpha: 0.12);
      fg = Colors.orange[700]!;
      label = 'En attente';
    } else {
      bg = Colors.green.withValues(alpha: 0.12);
      fg = Colors.green[700]!;
      label = 'Validé';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
