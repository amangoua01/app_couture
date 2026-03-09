import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/transfert_stock/edition_transfert_stock_vctl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionTransfertStockPage extends StatelessWidget {
  const EditionTransfertStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionTransfertStockVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text('Transfert de stock')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => ctl.addLigne(),
            label: const Text('Ajouter un article'),
            icon: const Icon(Icons.add),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CButton(
                  title: "Confirmer le transfert", onPressed: ctl.submit),
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
                              Icons.sync_disabled_rounded,
                              size: 60,
                              color: Colors.grey[300],
                            ),
                            const Gap(16),
                            Text(
                              'Aucun article disponible en stock dans cette boutique pour un transfert.',
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
                        // ── Sélection Destination ─────────────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withAlpha(20),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.storefront_rounded,
                                        size: 20, color: AppColors.primary),
                                  ),
                                  const Gap(12),
                                  const Text(
                                    "Boutique de destination",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Gap(16),
                              DropdownSearch<Boutique>(
                                enabled: true,
                                items: (filter, _) => ctl.boutiques.where((b) {
                                  return (b.libelle.value)
                                      .toLowerCase()
                                      .contains(filter.toLowerCase());
                                }).toList(),
                                selectedItem: ctl.selectedBoutique,
                                compareFn: (a, b) => a.id == b.id,
                                itemAsString: (v) => v.libelle.value,
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: 'Rechercher une boutique...',
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                ),
                                decoratorProps: const DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    labelText: 'Sélectionner une boutique *',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                  ),
                                ),
                                onChanged: (v) => ctl.setSelectedBoutique(v),
                              ),
                            ],
                          ),
                        ),

                        // ── Info Lignes ──────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.primary.withAlpha(30)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppColors.primary, size: 18),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  'Sélectionnez les articles à transférer et précisez la quantité (le stock actuel est indiqué).',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[800]),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Lignes ───────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────

class _LigneCard extends StatelessWidget {
  final int index;
  final EditionTransfertStockVctl ctl;

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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête ligne
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Gap(8),
                const Expanded(
                  child: Text('Article',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                if (ctl.lignes.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.red, size: 22),
                    onPressed: () => ctl.removeLigne(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const Gap(16),

            // Dropdown article
            DropdownSearch<ModeleBoutique>(
              enabled: true,
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
                final stock = ' (stock : ${v.quantite ?? 0})';
                return '$nom$taille$stock';
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom ou taille…',
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
            const Gap(16),

            // Quantité
            CTextFormField(
              controller: ligne.quantiteCtl,
              externalLabel: 'Quantité à transférer',
              keyboardType: TextInputType.number,
              require: true,
              margin: EdgeInsets.zero,
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
