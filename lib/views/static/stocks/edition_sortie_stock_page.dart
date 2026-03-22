import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/stocks/edition_sortie_stock_vctl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionSortieStockPage extends StatelessWidget {
  final ModeleBoutique? item;

  const EditionSortieStockPage({super.key}) : item = null;

  const EditionSortieStockPage.one(ModeleBoutique this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionSortieStockVctl(item),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text('Retrait de stock')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => ctl.addLigne(),
            label: const Text('Ajouter un retrait'),
            icon: const Icon(Icons.add),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CButton(
                title: "Confirmer le retrait",
                onPressed: ctl.submit,
              ),
            ),
          ),
          body: ctl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ctl.allVariantes.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 60,
                              color: Colors.grey[300],
                            ),
                            const Gap(16),
                            Text(
                              'Aucun article disponible pour un retrait.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      children: [
                        // ── Info ────────────────────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color:
                                    Colors.redAccent.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: Colors.redAccent, size: 18),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  'Sélectionnez les articles à retirer du stock et précisez le motif.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Commentaire global
                        CTextFormField(
                          controller: ctl.commentaireCtl,
                          externalLabel: "Commentaire global",
                          hintText: "Optionnel…",
                          maxLines: 2,
                        ),
                        const Gap(25),

                        // Lignes
                        ...List.generate(
                          ctl.lignes.length,
                          (i) => _LigneCard(
                            index: i,
                            ctl: ctl,
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}

class _LigneCard extends StatelessWidget {
  final int index;
  final EditionSortieStockVctl ctl;

  const _LigneCard({
    required this.index,
    required this.ctl,
  });

  @override
  Widget build(BuildContext context) {
    final ligne = ctl.lignes[index];
    final selected = ligne.modele;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(8),
                const Expanded(
                  child: Text('Article à retirer',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                if (ctl.lignes.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.red, size: 20),
                    onPressed: () => ctl.removeLigne(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const Gap(10),

            DropdownSearch<ModeleBoutique>(
              items: (filter, _) => ctl.allVariantes
                  .where((v) =>
                      (v.modele?.libelle?.value ?? '')
                          .toLowerCase()
                          .contains(filter.toLowerCase()) ||
                      (v.taille ?? '')
                          .toLowerCase()
                          .contains(filter.toLowerCase()))
                  .toList(),
              selectedItem: selected,
              compareFn: (a, b) => a.id == b.id,
              itemAsString: (v) {
                final nom = v.modele?.libelle?.value ?? '—';
                final taille = v.taille != null ? ' — ${v.taille}' : '';
                final stock = ' (stock actuel : ${v.quantite ?? 0})';
                return '$nom$taille$stock';
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Rechercher un article…',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                itemBuilder: (_, item, isSelected, __) =>
                    _ArticleDropdownItem(item: item, isSelected: isSelected),
              ),
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: 'Sélectionner un article *',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              onChanged: (v) => ctl.setModele(index, v),
            ),
            const Gap(12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: CTextFormField(
                    controller: ligne.quantiteCtl,
                    externalLabel: 'Quantité',
                    keyboardType: TextInputType.number,
                    require: true,
                    margin: EdgeInsets.zero,
                  ),
                ),
                const Gap(12),
                Expanded(
                  flex: 5,
                  child: CTextFormField(
                    controller: ligne.motifCtl,
                    externalLabel: 'Motif',
                    hintText: 'Mise en réserve, perte, etc.',
                    require: true,
                    margin: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleDropdownItem extends StatelessWidget {
  final ModeleBoutique item;
  final bool isSelected;
  const _ArticleDropdownItem({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final photo = item.modele?.photo;
    final String? photoUrl = (photo is FichierServer) ? photo.fullUrl : null;

    return ListTile(
      selected: isSelected,
      selectedColor: AppColors.primary,
      selectedTileColor: AppColors.primary.withAlpha(15),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          color: Colors.grey.shade100,
          child: photoUrl != null
              ? Image.network(photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                        size: 20,
                        color: Colors.grey,
                      ))
              : const Icon(Icons.shopping_bag_outlined,
                  size: 20, color: Colors.grey),
        ),
      ),
      title: Text(
        item.modele?.libelle?.value ?? '—',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        children: [
          if (item.taille != null)
            Text('Taille : ${item.taille}  ',
                style: const TextStyle(fontSize: 12)),
          Text('Stock : ${item.quantite ?? 0}',
              style: TextStyle(
                fontSize: 12,
                color: (item.quantite ?? 0) > 0
                    ? Colors.green[600]
                    : Colors.red[400],
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
