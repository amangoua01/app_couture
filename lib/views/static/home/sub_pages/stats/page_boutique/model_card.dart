import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/stock_modele_item.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/home/boutique_page_vctl.dart';
import 'package:ateliya/views/static/home/detail_boutique_item_page.dart';
import 'package:ateliya/views/static/ravitaillement/edition_ravitaillement_page.dart';
import 'package:ateliya/views/static/stocks/edition_sortie_stock_page.dart';
import 'package:ateliya/views/static/ventes/edition_vente_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ModelCard extends StatelessWidget {
  final StockModeleItem item;
  final BoutiquePageVctl ctl;
  const ModelCard({super.key, required this.item, required this.ctl});

  @override
  Widget build(BuildContext context) {
    final photo = item.modele?.photo;
    final hasPhoto = photo is FichierServer && (photo).fullUrl != null;

    final tailles = item.tailles;
    final firstVariante =
        item.variantes.isNotEmpty ? item.variantes.first : null;
    final qty = item.quantiteBoutique;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: firstVariante != null
              ? () => Get.to(() => DetailBoutiqueItemPage(firstVariante))
              : null,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ══════════════════════════════════════════════════════════════
                // ── IMAGE (côté gauche) ─────────────────────────────────────
                // ══════════════════════════════════════════════════════════════
                SizedBox(
                  width: 110,
                  child: Stack(
                    children: [
                      // Image principale
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(18)),
                          child: Container(
                            color: AppColors.primary.withValues(alpha: 0.04),
                            child: hasPhoto
                                ? Image.network(
                                    (photo).fullUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Image.asset(
                                            'assets/images/model1.png'),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Image.asset(
                                          'assets/images/model1.png'),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      // Badge stock en overlay
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: qty > 0
                                ? AppColors.green.withValues(alpha: 0.9)
                                : AppColors.secondary.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$qty',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ══════════════════════════════════════════════════════════════
                // ── DÉTAILS (centre) ────────────────────────────────────────
                // ══════════════════════════════════════════════════════════════
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Nom du modèle
                        Text(
                          item.modele?.libelle ?? 'Sans nom',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const Gap(8),

                        // Tailles
                        if (tailles.isNotEmpty) ...[
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: tailles.take(4).map((t) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const Gap(8),
                        ],

                        // Prix range
                        Row(
                          children: [
                            Icon(
                              Icons.sell_outlined,
                              size: 13,
                              color: AppColors.secondary.withValues(alpha: 0.8),
                            ),
                            const Gap(4),
                            Flexible(
                              child: Text(
                                item.prixMin == item.prixMax
                                    ? item.prixMin
                                    : '${item.prixMin} – ${item.prixMax}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(6),

                        // Stock info
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: qty > 0
                                    ? AppColors.green
                                    : AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap(5),
                            Text(
                              qty > 0 ? '$qty en stock' : 'Rupture',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: qty > 0
                                    ? AppColors.green
                                    : AppColors.secondary,
                              ),
                            ),
                            if (item.variantes.length > 1) ...[
                              const Gap(8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item.variantes.length} var.',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ══════════════════════════════════════════════════════════════
                // ── ACTIONS (côté droit) ────────────────────────────────────
                // ══════════════════════════════════════════════════════════════
                if (firstVariante != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Menu d'options
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.more_vert_rounded,
                                size: 16, color: AppColors.primary),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          itemBuilder: (_) => [
                            PopupMenuItem<String>(
                              height: 40,
                              value: 'detail',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility_outlined,
                                      size: 18,
                                      color: AppColors.primary
                                          .withValues(alpha: 0.6)),
                                  const Gap(10),
                                  const Text('Voir les détails',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              onTap: () => Get.to(
                                  () => DetailBoutiqueItemPage(firstVariante)),
                            ),
                            PopupMenuItem<String>(
                              height: 40,
                              value: 'vente',
                              child: Row(
                                children: [
                                  Icon(Icons.shopping_bag_outlined,
                                      size: 18,
                                      color: AppColors.primary
                                          .withValues(alpha: 0.6)),
                                  const Gap(10),
                                  const Text('Faire une vente',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              onTap: () async {
                                final res = await Get.to(
                                    () => EditionVentePage(firstVariante));
                                if (res != null) ctl.fetchData();
                              },
                            ),
                            if (ctl.user.isAdmin) ...[
                              PopupMenuItem<String>(
                                height: 40,
                                value: 'ravitaillement',
                                child: Row(
                                  children: [
                                    Icon(Icons.add_circle_outline,
                                        size: 18,
                                        color: AppColors.green
                                            .withValues(alpha: 0.8)),
                                    const Gap(10),
                                    const Text('Ravitailler',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                onTap: () async {
                                  final res = await Get.to(() =>
                                      EditionRavitaillementPage.one(
                                          firstVariante));
                                  if (res != null) ctl.fetchData();
                                },
                              ),
                              PopupMenuItem<String>(
                                height: 40,
                                value: 'sortie',
                                child: Row(
                                  children: [
                                    Icon(Icons.remove_circle_outline,
                                        size: 18,
                                        color: AppColors.secondary
                                            .withValues(alpha: 0.8)),
                                    const Gap(10),
                                    const Text('Sortie de stock',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                onTap: () async {
                                  final res = await Get.to(() =>
                                      EditionSortieStockPage.one(
                                          firstVariante));
                                  if (res != null) ctl.fetchData();
                                },
                              ),
                            ],
                          ],
                        ),

                        // Bouton vente rapide
                        GestureDetector(
                          onTap: () async {
                            final res = await Get.to(
                                () => EditionVentePage(firstVariante));
                            if (res != null) ctl.fetchData();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.secondary,
                                  AppColors.secondary.withValues(alpha: 0.85),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.shopping_bag_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
