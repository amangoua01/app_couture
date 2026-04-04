import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/ravitaillement/edition_ravitaillement_vctl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionRavitaillementPage extends StatelessWidget {
  final ModeleBoutique? item;

  const EditionRavitaillementPage({super.key}) : item = null;

  const EditionRavitaillementPage.one(ModeleBoutique this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionRavitaillementVctl(item),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(title: const Text('Nouveau ravitaillement')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddBottomSheet(context, ctl),
            label: const Text('Ajouter un article'),
            icon: const Icon(Icons.add),
          ),
          // ── Soumettre ────────────────────────────────────
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CButton(onPressed: ctl.submit),
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
                              'Aucun article disponible dans cette boutique.',
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
                        // ── Info ─────────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color:
                                    AppColors.primary.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppColors.primary, size: 18),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  'Ajoutez les articles et leur quantité '
                                  'à ravitailler.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
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
                            // isArticleEditable: item == null,
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  void _showAddBottomSheet(
      BuildContext context, EditionRavitaillementVctl ctl) {
    ModeleBoutique? selectedModele;
    final TextEditingController qtyCtl = TextEditingController(text: '1');

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
                          (v.modele?.libelle ?? '')
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
                      labelText: 'Sélectionner un article *',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  onChanged: (v) => setState(() => selectedModele = v),
                ),
                const Gap(16),
                CTextFormField(
                  controller: qtyCtl,
                  externalLabel: 'Quantité à ajouter',
                  keyboardType: TextInputType.number,
                  require: true,
                  margin: EdgeInsets.zero,
                ),
                const Gap(24),
                CButton(
                  title: 'Ajouter au ravitaillement',
                  onPressed: () {
                    if (selectedModele == null) {
                      Get.snackbar('Erreur', 'Veuillez sélectionner un article',
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }
                    final qty = int.tryParse(qtyCtl.text) ?? 0;
                    if (qty <= 0) {
                      Get.snackbar(
                          'Erreur', 'Veuillez saisir une quantité valide',
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }

                    ctl.lignes.add(EditionRavitaillementVctl.createLigne(
                        selectedModele!, qtyCtl.text));
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

// ─────────────────────────────────────────────────────────────────────────────

class _LigneCard extends StatelessWidget {
  final int index;
  final EditionRavitaillementVctl ctl;

  const _LigneCard({
    required this.index,
    required this.ctl,
  });

  @override
  Widget build(BuildContext context) {
    final ligne = ctl.lignes[index];
    final selected = ligne.modele;
    final photo = selected?.modele?.photo;
    final String? photoUrl = (photo is FichierServer) ? photo.fullUrl : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image / Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 50,
                height: 50,
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

            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selected?.modele?.libelle?.value ?? '—',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  if (selected?.taille != null)
                    Text('Taille : ${selected!.taille}',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),

            // Quantité
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Qté: ${ligne.quantiteCtl.text}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),

            // Supprimer
            IconButton(
              icon:
                  const Icon(Icons.delete_outline, color: Colors.red, size: 22),
              onPressed: () => ctl.removeLigne(index),
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
      selectedTileColor: AppColors.primary.withValues(alpha: 0.06),
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
              )),
        ],
      ),
    );
  }
}
