import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/stock_modele_item.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/home/boutique_page_vctl.dart';
import 'package:ateliya/views/static/home/detail_boutique_item_page.dart';
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
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text(
              'Boutique',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // ── Barre de recherche ─────────────────────────────────────────
              _SearchBar(ctl: ctl),
              // ── Contenu ────────────────────────────────────────────────────
              Expanded(
                child: ctl.isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
                      )
                    : ctl.data.isEmpty
                        ? _buildEmpty(ctl)
                        : RefreshIndicator(
                            onRefresh: ctl.fetchData,
                            color: AppColors.primary,
                            child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                for (final item in ctl.data) ...[
                                  SliverToBoxAdapter(
                                    child: _SectionHeader(item: item),
                                  ),
                                  SliverPadding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                    sliver: SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.72,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
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
                                  const SliverToBoxAdapter(child: Gap(4)),
                                ],
                                const SliverToBoxAdapter(child: Gap(24)),
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

  Widget _buildEmpty(BoutiquePageVctl ctl) {
    final isSearch = ctl.hasQuery;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearch ? Icons.search_off_rounded : Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const Gap(16),
            Text(
              isSearch
                  ? 'Aucun résultat pour « ${ctl.searchCtl.text} »'
                  : 'Aucun article en boutique',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isSearch) ...[
              const Gap(12),
              TextButton(
                onPressed: ctl.clearSearch,
                child: const Text('Effacer la recherche'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Barre de recherche ────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final BoutiquePageVctl ctl;
  const _SearchBar({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: ctl.searchCtl,
                onChanged: ctl.onSearch,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Rechercher un modèle, taille, prix...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[450],
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.grey[500],
                      size: 22,
                    ),
                  ),
                  suffixIcon: ctl.hasQuery
                      ? GestureDetector(
                          onTap: ctl.clearSearch,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
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
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Titre ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                // Miniature
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: hasPhoto
                        ? Image.network(
                            (photo).fullUrl!,
                            fit: BoxFit.cover,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset('assets/images/model1.png'),
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
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Gap(5),
                      Row(
                        children: [
                          _Pill(
                            label: '${item.quantiteBoutique} en stock',
                            bgColor: item.quantiteBoutique > 0
                                ? Colors.green
                                : Colors.red,
                            textColor: Colors.white,
                          ),
                          if (item.variantes.length > 1) ...[
                            const Gap(6),
                            _Pill(
                              label: '${item.variantes.length} variantes',
                              bgColor: AppColors.primary.withValues(alpha: 0.12),
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

          if (tailleEntries.isNotEmpty || prixEntries.isNotEmpty)
            Divider(
                height: 1,
                indent: 14,
                endIndent: 14,
                color: Colors.grey.shade100),

          // ── Bilan par taille ───────────────────────────────────────────────
          if (tailleEntries.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BilanLabel('Par taille'),
                  const Gap(6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: tailleEntries
                        .map((e) => _BilanChip(
                              label: (e.key.isEmpty || e.key == 'N/A')
                                  ? 'N/A'
                                  : e.key,
                              qty: e.value,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

          // ── Bilan par prix ─────────────────────────────────────────────────
          if (prixEntries.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BilanLabel('Par prix'),
                  const Gap(6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: prixEntries
                        .map((e) => _BilanChip(
                              label: e.key.toAmount(unit: 'F'),
                              qty: e.value,
                              isPrice: true,
                            ))
                        .toList(),
                  ),
                ],
              ),
            )
          else
            const Gap(12),
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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(() => DetailBoutiqueItemPage(variante)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──────────────────────────────────────────────────────
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
                        child: hasPhoto
                            ? Image.network(
                                (photo).fullUrl!,
                                fit: BoxFit.cover,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(24),
                                child: Image.asset('assets/images/model1.png'),
                              ),
                      ),
                    ),
                    // Badge taille
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
                          child: Text(
                            taille,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Badge stock
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: qty > 0
                              ? Colors.green.withValues(alpha: 0.85)
                              : Colors.red.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$qty',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Menu
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
                              value: 'vente',
                              child: const Text('Faire une vente'),
                              onTap: () async {
                                final res = await Get.to(
                                    () => EditionVentePage(variante));
                                if (res != null) ctl.fetchData();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ── Infos ──────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prix,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                    if (taille != null) ...[
                      const Gap(2),
                      Text(
                        'Taille : $taille',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                    const Gap(2),
                    Text(
                      'Stock : $qty',
                      style: TextStyle(
                        fontSize: 11,
                        color: qty > 0 ? Colors.green[700] : Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
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

class _Pill extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  const _Pill(
      {required this.label, required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BilanLabel extends StatelessWidget {
  final String text;
  const _BilanLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.grey[400],
        letterSpacing: 0.8,
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isPrice
            ? AppColors.primary.withValues(alpha: 0.07)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPrice
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.grey.shade200,
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12),
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isPrice ? AppColors.primary : Colors.black87,
              ),
            ),
            TextSpan(
              text: '  ×$qty',
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
