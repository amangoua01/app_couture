import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/stock_modele_item.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/tools/widgets/photo_produit.dart';
import 'package:ateliya/views/controllers/home/boutique_page_vctl.dart';
import 'package:ateliya/views/static/home/detail_boutique_item_page.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/page_boutique/boutique_skeleton.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/page_boutique/search_bar_part.dart';
import 'package:ateliya/views/static/ravitaillement/edition_ravitaillement_page.dart';
import 'package:ateliya/views/static/stocks/edition_sortie_stock_page.dart';
import 'package:ateliya/views/static/ventes/edition_vente_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BoutiquePage extends StatelessWidget {
  const BoutiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BoutiquePageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAF9),
          appBar: MainAppBar(
            notifCount: ctl.nbUnreadNotifs,
            onSelectionChanged: () => ctl.fetchData(),
            onNotifRefresh: () => ctl.loadUnreadCount(),
          ),
          body: Column(
            children: [
              SearchBarPart(ctl: ctl),
              Expanded(
                // Tant qu'aucune lecture n'a abouti, on montre la silhouette du
                // contenu : annoncer une boutique vide avant d'avoir interrogé
                // le serveur obligeait l'utilisateur à actualiser à la main.
                child: (ctl.isLoading || !ctl.hasLoadedOnce)
                    ? const BoutiqueSkeleton()
                    : ctl.data.isEmpty
                        ? RefreshIndicator(
                            onRefresh: ctl.fetchData,
                            color: AppColors.secondary,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: 460,
                                  child: ctl.hasQuery
                                      ? BoutiqueAucunResultat(
                                          onEffacer: ctl.clearSearch,
                                        )
                                      : BoutiqueVide(
                                          onRavitailler: ctl.user.isAdmin
                                              ? () async {
                                                  final res = await Get.to(
                                                    () => const EditionRavitaillementPage(),
                                                  );
                                                  if (res != null) {
                                                    ctl.fetchData();
                                                  }
                                                }
                                              : null,
                                        ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: ctl.fetchData,
                            color: AppColors.secondary,
                            child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                for (final item in ctl.data) ...[
                                  SliverToBoxAdapter(
                                    child: _SectionHeader(item: item),
                                  ),
                                  SliverPadding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                                    sliver: SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.72,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) => _VarianteCard(
                                          variante: item.variantes[index],
                                          ctl: ctl,
                                        ),
                                        childCount: item.variantes.length,
                                      ),
                                    ),
                                  ),
                                  const SliverToBoxAdapter(child: Gap(2)),
                                ],
                                const SliverToBoxAdapter(child: Gap(32)),
                              ],
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

// ─── En-tête de section ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final StockModeleItem item;
  const _SectionHeader({required this.item});

  @override
  Widget build(BuildContext context) {
    final photo = item.modele?.photo;
    final hasPhoto = photo is FichierServer && (photo).fullUrl != null;

    final tailleEntries = item.bilan.parTaille.entries.toList();
    final prixEntries = item.bilan.parPrix.entries.toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 9),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PhotoProduit(
                      url: hasPhoto ? (photo).fullUrl : null,
                      largeurAffichee: 46,
                      placeholder: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/images/model1.png'),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const Gap(4),
                      Row(
                        children: [
                          _Pill(
                            label: '${item.quantiteBoutique} en stock',
                            bgColor: item.quantiteBoutique > 0
                                ? AppColors.green
                                : AppColors.secondary,
                            textColor: Colors.white,
                          ),
                          if (item.variantes.length > 1) ...[
                            const Gap(6),
                            _Pill(
                              label: '${item.variantes.length} variantes',
                              bgColor: AppColors.primary.withValues(alpha: 0.08),
                              textColor: AppColors.primary,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (tailleEntries.isNotEmpty || prixEntries.isNotEmpty) ...[
            Divider(
                height: 1,
                indent: 14,
                endIndent: 14,
                color: Colors.grey.shade100),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 9, 14, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tailleEntries.isNotEmpty)
                    _BilanRow(
                      label: 'Taille',
                      chips: tailleEntries
                          .map((e) => _BilanChip(
                                label: (e.key.isEmpty || e.key == 'N/A')
                                    ? 'N/A'
                                    : e.key,
                                qty: e.value,
                              ))
                          .toList(),
                    ),
                  if (tailleEntries.isNotEmpty && prixEntries.isNotEmpty)
                    const Gap(7),
                  if (prixEntries.isNotEmpty)
                    _BilanRow(
                      label: 'Prix',
                      chips: prixEntries
                          .map((e) => _BilanChip(
                                label: e.key.toAmount(unit: 'F'),
                                qty: e.value,
                                isPrice: true,
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
          ] else
            const Gap(10),
        ],
      ),
    );
  }
}

// ─── Carte variante ────────────────────────────────────────────────────────────

class _VarianteCard extends StatelessWidget {
  final ModeleBoutique variante;
  final BoutiquePageVctl ctl;
  const _VarianteCard({required this.variante, required this.ctl});

  @override
  Widget build(BuildContext context) {
    final photo = variante.modele?.photo;
    final hasPhoto = photo is FichierServer && (photo).fullUrl != null;

    final taille = (variante.taille == null || variante.taille!.isEmpty)
        ? null
        : variante.taille!;
    final prix = variante.prix?.toAmount(unit: 'F') ?? '-';
    final qty = variante.quantite ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final res = await Get.to(() => EditionVentePage(variante));
            if (res != null) ctl.fetchData();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ────────────────────────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: SizedBox.expand(
                          child: PhotoProduit(
                            url: hasPhoto ? (photo).fullUrl : null,
                            // Deux colonnes : la vignette occupe à peu près la
                            // moitié de la largeur de l'écran.
                            largeurAffichee:
                                MediaQuery.sizeOf(context).width / 2,
                            placeholder: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Image.asset('assets/images/model1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (taille != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(taille,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: qty > 0
                              ? AppColors.green.withValues(alpha: 0.85)
                              : Colors.red.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('$qty',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Material(
                        color: Colors.transparent,
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            child: const Icon(Icons.more_horiz_rounded,
                                size: 16, color: Colors.black54),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          itemBuilder: (_) => [
                            PopupMenuItem<String>(
                              height: 40,
                              value: 'detail',
                              onTap: () => Get.to(
                                  () => DetailBoutiqueItemPage(variante)),
                              child: const Text('Voir les détails'),
                            ),
                            PopupMenuItem<String>(
                              height: 40,
                              value: 'vente',
                              onTap: () async {
                                final res = await Get.to(
                                    () => EditionVentePage(variante));
                                if (res != null) ctl.fetchData();
                              },
                              child: const Text('Faire une vente'),
                            ),
                            if (ctl.user.isAdmin) ...[
                              PopupMenuItem<String>(
                                height: 40,
                                value: 'ravitaillement',
                                onTap: () async {
                                  final res = await Get.to(() =>
                                      EditionRavitaillementPage.one(variante));
                                  if (res != null) ctl.fetchData();
                                },
                                child: const Text('Ravitailler'),
                              ),
                              PopupMenuItem<String>(
                                height: 40,
                                value: 'sortie',
                                onTap: () async {
                                  final res = await Get.to(() =>
                                      EditionSortieStockPage.one(variante));
                                  if (res != null) ctl.fetchData();
                                },
                                child: const Text('Sortie de stock'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ── Infos ─────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(prix,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: AppColors.secondary,
                        )),
                    // La taille n'est plus répétée ici : elle figure déjà sur
                    // la vignette. La place ainsi libérée sert aux boutons de
                    // stock, enfin assez grands pour être visés au doigt.
                    const Gap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                              const Gap(4),
                              Flexible(
                                child: Text(
                                  qty > 0 ? '$qty en stock' : 'Rupture',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: qty > 0
                                        ? AppColors.green
                                        : AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (ctl.user.isAdmin)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _StockBtn(
                                icon: Icons.remove_rounded,
                                color: Colors.red,
                                tooltip: "Sortie de stock",
                                onTap: () async {
                                  final res = await Get.to(() =>
                                      EditionSortieStockPage.one(variante));
                                  if (res != null) ctl.fetchData();
                                },
                              ),
                              const Gap(8),
                              _StockBtn(
                                icon: Icons.add_rounded,
                                color: AppColors.green,
                                tooltip: "Ravitailler",
                                onTap: () async {
                                  final res = await Get.to(() =>
                                      EditionRavitaillementPage.one(variante));
                                  if (res != null) ctl.fetchData();
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widgets utilitaires ───────────────────────────────────────────────────────

/// Retrait et ajout de stock depuis la carte.
///
/// Ces deux boutons étaient des pastilles d'une vingtaine de pixels, en deçà
/// de la taille minimale confortable au doigt, et séparées de quelques pixels
/// seulement : on visait le moins et on touchait le plus.
class _StockBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _StockBtn({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(icon, size: 19, color: color),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  const _Pill(
      {required this.label, required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              color: textColor, fontSize: 10.5, fontWeight: FontWeight.bold)),
    );
  }
}

/// Répartition du stock sur une seule ligne : intitulé à gauche, pastilles à
/// droite.
///
/// L'intitulé occupait auparavant sa propre ligne au-dessus des pastilles, soit
/// deux lignes perdues par fiche pour deux mots. Le mettre en regard rend la
/// carte nettement plus courte sans rien retirer de l'information.
class _BilanRow extends StatelessWidget {
  final String label;
  final List<Widget> chips;
  const _BilanRow({required this.label, required this.chips});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 44,
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: Colors.grey[400],
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
        Expanded(
          child: Wrap(spacing: 5, runSpacing: 5, children: chips),
        ),
      ],
    );
  }
}

class _BilanChip extends StatelessWidget {
  final String label;
  final int qty;
  final bool isPrice;
  const _BilanChip(
      {required this.label, required this.qty, this.isPrice = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: isPrice
            ? AppColors.primary.withValues(alpha: 0.07)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: isPrice
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.grey.shade200,
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 11),
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isPrice ? AppColors.primary : Colors.black87,
              ),
            ),
            TextSpan(
              text: ' ×$qty',
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
