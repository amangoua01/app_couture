import 'package:ateliya/data/models/modele_boutique_details.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/empty_page.dart';
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
      backgroundColor: const Color(0xFFF8FAF9),
      floatingActionButton: FloatingActionButton(
        onPressed: () => CBottomSheet.show(
          child: GetBuilder(
            init: ctl,
            builder: (_) => _FilterSheet(ctl: ctl),
          ),
        ),
        elevation: 4,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
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
            return const Center(
              child: EmptyPage(
                icon: Icons.swap_vert_rounded,
                title: 'Aucun mouvement enregistré',
                subtitle: 'Les entrées et sorties de stock apparaîtront ici',
              ),
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
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Bandeau de résumé ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: _StatsBanner(
                    totalEntrees: totalEntrees,
                    totalSorties: totalSorties,
                    count: mouvements.length,
                  ),
                ),
              ),

              // ── Liste ───────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
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
// Bandeau de stats minimaliste et moderne
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
        // Entrées (Vert de la charte)
        Expanded(
          child: _StatCard(
            label: 'Entrées',
            value: '+$totalEntrees',
            bgColor: AppColors.green.withValues(alpha: 0.12),
            borderColor: AppColors.green.withValues(alpha: 0.25),
            textColor: AppColors.green,
            icon: Icons.arrow_downward_rounded,
          ),
        ),
        const Gap(10),

        // Sorties (Rouge doux/terracotta harmonisé)
        Expanded(
          child: _StatCard(
            label: 'Sorties',
            value: '-$totalSorties',
            bgColor: const Color(0xFFC76D6D).withValues(alpha: 0.12),
            borderColor: const Color(0xFFC76D6D).withValues(alpha: 0.25),
            textColor: const Color(0xFFC76D6D),
            icon: Icons.arrow_upward_rounded,
          ),
        ),
        const Gap(10),

        // Total Mouvements
        Expanded(
          child: _StatCard(
            label: 'Mouvements',
            value: '$count',
            bgColor: AppColors.primary.withValues(alpha: 0.06),
            borderColor: AppColors.primary.withValues(alpha: 0.15),
            textColor: AppColors.primary,
            icon: Icons.swap_vert_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 12, color: textColor),
              ),
              const Gap(6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const Gap(6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card mouvement minimaliste et élégante
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

    final Color accentColor =
        isEntree ? AppColors.green : const Color(0xFFC76D6D);

    // Date formatée
    final date = es?.date;
    final dateStr = date != null
        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}h${date.minute.toString().padLeft(2, '0')}'
        : '—';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icone type circulaire minimal
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEntree
                    ? Icons.add_circle_outline_rounded
                    : Icons.remove_circle_outline_rounded,
                color: accentColor,
                size: 20,
              ),
            ),
            const Gap(12),

            // Infos textuelles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEntree ? 'Entrée de stock' : 'Sortie de stock',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppColors.primary,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${isEntree ? '+' : '-'}$qty u',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
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
      bg = AppColors.green.withValues(alpha: 0.12);
      fg = AppColors.green;
      label = 'Confirmé';
    } else if (isEnAttente) {
      bg = AppColors.secondary.withValues(alpha: 0.12);
      fg = AppColors.secondary;
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom sheet filtre moderne
// ─────────────────────────────────────────────────────────────────────────────

class _FilterSheet extends StatelessWidget {
  final DetailBoutiqueItemPageVctl ctl;
  const _FilterSheet({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: [
              const Icon(Icons.filter_list_rounded,
                  color: AppColors.primary, size: 22),
              const Gap(8),
              const Text(
                'Filtrer les mouvements',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  ctl.entreStockFilter.dateDebut.clear();
                  ctl.entreStockFilter.dateFin.clear();
                  ctl.update();
                },
                child: const Text(
                  'Réinitialiser',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
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
          const Gap(12),
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
          const Gap(20),
          CButton(
            title: 'Appliquer',
            onPressed: () {
              ctl.update();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
