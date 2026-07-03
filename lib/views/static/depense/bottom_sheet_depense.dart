import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/depense/edition_depense_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BottomSheetDepense {
  static void show(BuildContext context, EditionDepensePageVctl ctl) {
    if (ctl.totalMontant <= 0) {
      CSnackbar.error(
        'Veuillez d\'abord saisir le montant total',
      );
      return;
    }

    Caisse? selectedCaisse;
    final TextEditingController montantCtl = TextEditingController();

    double restant = ctl.totalMontant - ctl.totalLignes;
    if (restant > 0) montantCtl.text = restant.toInt().toString();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mode de règlement',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: const EdgeInsets.all(8),
                      ),
                      icon: const Icon(Icons.close_rounded,
                          size: 20, color: Colors.grey),
                    ),
                  ],
                ),
                const Gap(24),
                CDropDownFormField<Caisse>(
                  selectedItem: selectedCaisse,
                  onChanged: (e) => setState(() => selectedCaisse = e),
                  items: (p0, p1) => ctl.getCaissesHelper(),
                  itemAsString: (p0) =>
                      "${p0.entite?.libelle} (${p0.type ?? 'Caisse'}) : ${p0.montant} FCFA",
                  externalLabel: "Caisse",
                  require: true,
                ),
                CTextFormField(
                  controller: montantCtl,
                  keyboardType: TextInputType.number,
                  externalLabel: 'Montant à prélever',
                  require: true,
                  margin: const EdgeInsets.only(bottom: 24),
                ),
                CButton(
                  title: 'Ajouter le règlement',
                  onPressed: () {
                    if (selectedCaisse == null) {
                      Get.snackbar(
                        'Erreur',
                        'Veuillez sélectionner une caisse',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                      );
                      return;
                    }
                    if (montantCtl.text.isEmpty) {
                      Get.snackbar(
                        'Erreur',
                        'Veuillez saisir un montant',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                      );
                      return;
                    }

                    ctl.ligneRows.add(EditionDepensePageVctl.createLine(
                        selectedCaisse!, montantCtl.text));
                    ctl.update();
                    Get.back();
                  },
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
