import 'package:ateliya/data/models/modele_boutique_details.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/views/controllers/home/detail_boutique_item_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EntreesStockListSubPage extends StatelessWidget {
  final DetailBoutiqueItemPageVctl ctl;
  const EntreesStockListSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () => CBottomSheet.show(
          child: GetBuilder(
            init: ctl,
            builder: (_) => _FilterSheet(ctl: ctl),
          ),
        ),
        backgroundColor: AppColors.primary,
        child: SvgPicture.asset(
          'assets/images/svg/filter.svg',
          height: 22,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
      body: GetBuilder<DetailBoutiqueItemPageVctl>(
        init: ctl,
        builder: (_) {
          if (ctl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final mouvements = ctl.filteredMouvements;

          if (mouvements.isEmpty) {
            return EmptyDataWidget(
              message: 'Aucun mouvement enregistré',
              onRefresh: ctl.loadDetails,
            );
          }

          // ── Stats en en-tête ────────────────────────────────────────────
          final totalEntrees = mouvements
              .where((m) => m.entreStock?.type?.toLowerCase() == 'entree')
              .fold<int>(0, (s, m) => s + (m.quantite ?? 0));
          final totalSorties = mouvements
              .where((m) => m.entreStock?.type?.toLowerCase() != 'entree')
              .fold<int>(0, (s, m) => s + (m.quantite ?? 0));

          return CustomScrollView(
            slivers: [
              // ── Bandeau de résumé ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: _StatsBanner(
                    totalEntrees: totalEntrees,
                    totalSorties: totalSorties,
                    count: mouvements.length,
                  ),
                ),
              ),

              // ── Liste ───────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _MouvementCard(
                      mouvement: mouvements[i],
                      index: i,
                    ),
                    childCount: mouvements.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bandeau de stats
// ─────────────────────────────────────────────────────────────────────────────

class _StatsBanner extends StatelessWidget {
  final int totalEntrees;
  final int totalSorties;
  final int count;

  const _StatsBanner({
    required this.totalEntrees,
    required this.totalSorties,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            label: 'Entrées',
            value: '+$totalEntrees',
            color: Colors.green,
            icon: Icons.arrow_downward_rounded,
          ),
        ),
        const Gap(8),
        Expanded(
          child: _StatChip(
            label: 'Sorties',
            value: '-$totalSorties',
            color: Colors.red,
            icon: Icons.arrow_upward_rounded,
          ),
        ),
        const Gap(8),
        Expanded(
          child: _StatChip(
            label: 'Total',
            value: '$count mvt',
            color: AppColors.primary,
            icon: Icons.swap_vert_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const Gap(4),
              Text(label,
                  style:
                      TextStyle(fontSize: 11, color: color.withValues(alpha: 0.8))),
            ],
          ),
          const Gap(4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card mouvement
// ─────────────────────────────────────────────────────────────────────────────

class _MouvementCard extends StatelessWidget {
  final MouvementStock mouvement;
  final int index;

  const _MouvementCard({required this.mouvement, required this.index});

  @override
  Widget build(BuildContext context) {
    final es = mouvement.entreStock;
    final isEntree = es?.type?.toLowerCase() == 'entree';
    final qty = mouvement.quantite ?? 0;
    final statut = es?.statut;
    final isConfirme = statut == 'CONFIRME';
    final isEnAttente = statut == 'EN_ATTENTE';

    final accentColor = isEntree ? Colors.green : Colors.red;

    // Date formatée
    final date = es?.date;
    final dateStr = date != null
        ? '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}  '
            '${date.hour.toString().padLeft(2, '0')}h'
            '${date.minute.toString().padLeft(2, '0')}'
        : '—';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // ── Barre colorée latérale ──────────────────────────────────
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),

            // ── Contenu ─────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Pastille type
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isEntree
                            ? Icons.add_circle_outline_rounded
                            : Icons.remove_circle_outline_rounded,
                        color: accentColor,
                        size: 22,
                      ),
                    ),
                    const Gap(12),

                    // Texte principal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEntree ? 'Entrée de stock' : 'Sortie de stock',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: accentColor,
                            ),
                          ),
                          const Gap(3),
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded,
                                  size: 12, color: Colors.grey[400]),
                              const Gap(4),
                              Text(
                                dateStr,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                          if (statut != null) ...[
                            const Gap(6),
                            _StatutPill(
                              statut: statut,
                              isConfirme: isConfirme,
                              isEnAttente: isEnAttente,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Quantité
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isEntree ? '+' : '-'}$qty',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                        Text(
                          'unité(s)',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatutPill extends StatelessWidget {
  final String statut;
  final bool isConfirme;
  final bool isEnAttente;

  const _StatutPill({
    required this.statut,
    required this.isConfirme,
    required this.isEnAttente,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;

    if (isConfirme) {
      bg = Colors.green.withValues(alpha: 0.12);
      fg = Colors.green[700]!;
      label = 'Confirmé';
    } else if (isEnAttente) {
      bg = Colors.orange.withValues(alpha: 0.12);
      fg = Colors.orange[700]!;
      label = 'En attente';
    } else {
      bg = Colors.grey.withValues(alpha: 0.12);
      fg = Colors.grey[600]!;
      label = statut;
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

// ─────────────────────────────────────────────────────────────────────────────
// Bottom sheet filtre
// ─────────────────────────────────────────────────────────────────────────────

class _FilterSheet extends StatelessWidget {
  final DetailBoutiqueItemPageVctl ctl;
  const _FilterSheet({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      children: [
        Row(
          children: [
            const Icon(Icons.filter_list_rounded,
                color: AppColors.primary, size: 20),
            const Gap(8),
            const Text(
              'Filtrer les mouvements',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                ctl.entreStockFilter.dateDebut.clear();
                ctl.entreStockFilter.dateFin.clear();
                ctl.update();
              },
              child: const Text('Réinitialiser',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ],
        ),
        const Divider(height: 20),
        CDateFormField(
          labelText: 'Date de début',
          controller: ctl.entreStockFilter.dateDebut,
          withTime: false,
          onClear: () {
            ctl.entreStockFilter.dateDebut.clear();
            ctl.update();
          },
          onChange: (e) {
            ctl.entreStockFilter.dateDebut.dateTime = e;
            ctl.update();
          },
        ),
        CDateFormField(
          labelText: 'Date de fin',
          controller: ctl.entreStockFilter.dateFin,
          withTime: false,
          onClear: () {
            ctl.entreStockFilter.dateFin.clear();
            ctl.update();
          },
          onChange: (e) {
            ctl.entreStockFilter.dateFin.dateTime = e;
            ctl.update();
          },
        ),
        const Gap(16),
        CButton(
          title: 'Appliquer',
          onPressed: () {
            ctl.update();
            Get.back();
          },
        ),
      ],
    );
  }
}
