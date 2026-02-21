import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/ligne_entree_stock.dart';
import 'package:ateliya/data/models/ravitaillement_stock.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/empty_data_widget.dart';
import 'package:ateliya/tools/widgets/shimmer_listtile.dart';
import 'package:ateliya/views/controllers/ravitaillement/ravitaillement_list_vctl.dart';
import 'package:ateliya/views/static/ravitaillement/edition_ravitaillement_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RavitaillementListPage extends StatelessWidget {
  const RavitaillementListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RavitaillementListVctl(),
      builder: (ctl) {
        return Scaffold(
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
          ),
          floatingActionButton: Visibility(
            visible: ctl.user.isAdmin,
            child: FloatingActionButton.extended(
              onPressed: () async {
                final res =
                    await Get.to(() => const EditionRavitaillementPage());
                if (res == true) ctl.fetchData();
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nouveau'),
            ),
          ),
          body: ctl.isLoading
              ? ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: 8,
                  itemBuilder: (_, __) => const ShimmerListtile(),
                )
              : ctl.items.isEmpty
                  ? EmptyDataWidget(
                      message: 'Aucun ravitaillement enregistré',
                      onRefresh: () => ctl.fetchData(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ctl.fetchData(),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (n) {
                          if (n is ScrollEndNotification &&
                              n.metrics.extentAfter < 100) {
                            ctl.loadMore();
                          }
                          return false;
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                          itemCount: ctl.items.length + (ctl.hasMore ? 1 : 0),
                          separatorBuilder: (_, __) => const Gap(10),
                          itemBuilder: (_, i) {
                            if (i >= ctl.items.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return _RavitaillementCard(
                              item: ctl.items[i],
                              ctl: ctl,
                            );
                          },
                        ),
                      ),
                    ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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
        border: Border.all(color: Colors.grey.shade100),
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
                    child: OutlinedButton.icon(
                      onPressed: () => ctl.rejeter(item),
                      icon: const Icon(Icons.close_rounded,
                          size: 16, color: Colors.red),
                      label: const Text('Rejeter',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => ctl.confirmer(item),
                      icon: const Icon(Icons.check_rounded,
                          size: 16, color: Colors.white),
                      label: const Text('Confirmer',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
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
