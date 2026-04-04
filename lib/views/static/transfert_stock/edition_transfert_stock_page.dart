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
            onPressed: () => _showAddBottomSheet(context, ctl),
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
                      padding: const EdgeInsets.all(16),
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
                                color: Colors.black.withValues(alpha: 0.03),
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
                                      color: AppColors.primary.withValues(alpha: 0.1),
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
                            color: AppColors.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppColors.primary, size: 18),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  'Ajoutez les articles que vous souhaitez transférer vers la boutique de destination.',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[800]),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Lignes ───────────────────────────────────────
                        if (ctl.lignes.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.playlist_add_rounded,
                                    size: 48, color: Colors.grey[300]),
                                const Gap(12),
                                Text(
                                  "Aucun article ajouté au transfert",
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500),
                                ),
                                const Gap(16),
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      _showAddBottomSheet(context, ctl),
                                  icon: const Icon(Icons.add),
                                  label: const Text("Ajouter un article"),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ctl.lignes.length,
                            separatorBuilder: (context, index) => const Gap(12),
                            itemBuilder: (context, index) {
                              return _LigneTransfertSummaryCard(
                                  index: index, ctl: ctl);
                            },
                          ),
                        const Gap(120), // Space for FAB
                      ],
                    ),
        );
      },
    );
  }

  void _showAddBottomSheet(
      BuildContext context, EditionTransfertStockVctl ctl) {
    ModeleBoutique? selectedModele;
    final TextEditingController quantiteCtl = TextEditingController(text: '1');

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ajouter un article',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Gap(16),
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
                  selectedItem: selectedModele,
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
                        _ArticleDropdownItem(
                            item: item, isSelected: isSelected),
                  ),
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'Sélectionner l\'article *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  onChanged: (v) => setState(() => selectedModele = v),
                ),
                const Gap(16),
                CTextFormField(
                  controller: quantiteCtl,
                  externalLabel: 'Quantité à transférer',
                  keyboardType: TextInputType.number,
                  require: true,
                  margin: EdgeInsets.zero,
                ),
                const Gap(24),
                CButton(
                  title: 'Ajouter au transfert',
                  onPressed: () {
                    if (selectedModele == null) {
                      Get.snackbar('Erreur', 'Veuillez sélectionner un article',
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }

                    int qty = int.tryParse(quantiteCtl.text) ?? 0;
                    if (qty <= 0) {
                      Get.snackbar('Erreur', 'Quantité invalide',
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }

                    if (qty > (selectedModele!.quantite ?? 0)) {
                      Get.snackbar('Erreur',
                          'Stock insuffisant (Max: ${selectedModele!.quantite})',
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }

                    ctl.lignes.add(EditionTransfertStockVctl.createLine(
                        selectedModele!, quantiteCtl.text));
                    ctl.update();
                    Get.back();
                  },
                ),
                const Gap(16),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}

class _LigneTransfertSummaryCard extends StatelessWidget {
  final int index;
  final EditionTransfertStockVctl ctl;

  const _LigneTransfertSummaryCard({required this.index, required this.ctl});

  @override
  Widget build(BuildContext context) {
    final ligne = ctl.lignes[index];
    final selected = ligne.modele;
    final photo = selected?.modele?.photo;
    final String? photoUrl = (photo is FichierServer) ? photo.fullUrl : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 48,
              height: 48,
              color: Colors.grey.shade100,
              child: photoUrl != null
                  ? Image.network(photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            size: 24,
                            color: Colors.grey,
                          ))
                  : const Icon(Icons.shopping_bag_outlined,
                      size: 24, color: Colors.grey),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected?.modele?.libelle?.value ?? "Article inconnu",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "Taille: ${selected?.taille ?? 'N/A'} • Qté: ${ligne.quantiteCtl.text}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ctl.removeLigne(index),
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
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
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
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
