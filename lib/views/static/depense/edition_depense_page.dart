import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/depense/edition_depense_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionDepensePage extends StatelessWidget {
  const EditionDepensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionDepensePageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Nouvelle dépense"),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddBottomSheet(context, ctl),
            icon: const Icon(Icons.add),
            label: const Text("Mode de règlement"),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CButton(
                onPressed: ctl.submit,
                title: "Enregistrer la dépense",
              ),
            ),
          ),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CDropDownFormField<FamilleDepense>(
                  selectedItem: ctl.selectedFamille,
                  onChanged: (e) {
                    ctl.selectedFamille = e;
                    ctl.update();
                  },
                  items: (p0, p1) => ctl.getFamilles(),
                  itemAsString: (p0) => p0.libelle.value,
                  externalLabel: "Famille de dépense",
                  require: true,
                ),
                CTextFormField(
                  controller: ctl.montantCtl,
                  keyboardType: TextInputType.number,
                  externalLabel: 'Montant Total',
                  require: true,
                  suffix: const Text("FCFA"),
                ),
                const Gap(10),
                if (ctl.totalMontant > 0) ...[
                  LinearProgressIndicator(
                    value: ctl.progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ctl.progress == 1.0 ? Colors.green : Colors.orange,
                    ),
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Couverture paiement",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                      ),
                      Text(
                        "${ctl.totalLignes.toInt()} / ${ctl.totalMontant.toInt()} FCFA (${(ctl.progress * 100).toStringAsFixed(1)}%)",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ctl.progress == 1.0
                                ? Colors.green
                                : Colors.orange),
                      ),
                    ],
                  ),
                ],
                const Gap(24),
                Row(
                  children: [
                    const Icon(Icons.payments_outlined,
                        size: 20, color: AppColors.primary),
                    const Gap(8),
                    const Text("Modes de règlement",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const Gap(12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ctl.ligneRows.length,
                  separatorBuilder: (context, index) => const Gap(12),
                  itemBuilder: (context, index) {
                    return _LigneDepenseCard(index: index, ctl: ctl);
                  },
                ),
                if (ctl.ligneRows.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.payment,
                            size: 40, color: Colors.grey.shade400),
                        const Gap(8),
                        Text(
                          "Aucun mode de règlement ajouté",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                const Gap(24),
                CTextFormField(
                  controller: ctl.descriptionCtl,
                  externalLabel: "Notes / Description",
                  maxLines: 3,
                ),
                const Gap(100), // Space for FAB
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddBottomSheet(BuildContext context, EditionDepensePageVctl ctl) {
    if (ctl.totalMontant <= 0) {
      Get.snackbar('Erreur', 'Veuillez d\'abord saisir le montant total',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Caisse? selectedCaisse;
    final TextEditingController montantCtl = TextEditingController();

    // Suggérer le montant restant
    double restant = ctl.totalMontant - ctl.totalLignes;
    if (restant > 0) montantCtl.text = restant.toInt().toString();

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
                      'Mode de règlement',
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
                CDropDownFormField<Caisse>(
                  selectedItem: selectedCaisse,
                  onChanged: (e) => setState(() => selectedCaisse = e),
                  items: (p0, p1) => ctl.getCaissesHelper(),
                  itemAsString: (p0) =>
                      "${p0.entite?.libelle} (${p0.type ?? 'Caisse'}) : ${p0.montant} FCFA",
                  externalLabel: "Caisse",
                  require: true,
                ),
                const Gap(12),
                CTextFormField(
                  controller: montantCtl,
                  keyboardType: TextInputType.number,
                  externalLabel: 'Montant à prélever',
                  require: true,
                  margin: EdgeInsets.zero,
                ),
                const Gap(24),
                CButton(
                  title: 'Ajouter le règlement',
                  onPressed: () {
                    if (selectedCaisse == null) {
                      Get.snackbar('Erreur', 'Veuillez sélectionner une caisse',
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }
                    if (montantCtl.text.isEmpty) {
                      Get.snackbar('Erreur', 'Veuillez saisir un montant',
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }

                    ctl.ligneRows.add(EditionDepensePageVctl.createLine(
                        selectedCaisse!, montantCtl.text));
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

class _LigneDepenseCard extends StatelessWidget {
  final int index;
  final EditionDepensePageVctl ctl;

  const _LigneDepenseCard({required this.index, required this.ctl});

  @override
  Widget build(BuildContext context) {
    final row = ctl.ligneRows[index];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wallet, color: Colors.blue, size: 20),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.caisse?.entite?.libelle ?? "Caisse inconnue",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "Prélèvement: ${row.montantCtl.text.toAmount(unit: 'F')}",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500),
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
