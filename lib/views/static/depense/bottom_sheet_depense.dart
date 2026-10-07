import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/components/field_popup.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/caisse_option_tile.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/depense/edition_depense_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BottomSheetDepense {
  static void show(BuildContext context, EditionDepensePageVctl ctl) {
    if (ctl.totalMontant <= 0) {
      CMessageDialog.show(message: "Veuillez d'abord saisir le montant total");
      return;
    }

    Caisse? selectedCaisse;
    final TextEditingController montantCtl = TextEditingController();

    double restant = ctl.totalMontant - ctl.totalLignes;
    if (restant > 0) montantCtl.text = restant.toInt().toString();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (sheetContext, setState) {
          final keyboardHeight = MediaQuery.of(sheetContext).viewInsets.bottom;

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.85,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: keyboardHeight),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
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
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Get.back(),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                              padding: const EdgeInsets.all(8),
                            ),
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      CDropDownFormField<Caisse>(
                        selectedItem: selectedCaisse,
                        onChanged: (e) => setState(() => selectedCaisse = e),
                        items: (p0, p1) => ctl.getCaissesHelper(),
                        itemAsString: (p0) =>
                            "${p0.entite?.libelle} (${caisseTypeLabel(p0.type)})",
                        externalLabel: "Caisse*",
                        require: true,
                        popupProps: FieldPopup.menu<Caisse>(
                          itemBuilder: (context, item, isDisabled, isSelected) =>
                              CaisseOptionTile(
                            caisse: item,
                            isSelected: isSelected,
                          ),
                        ),
                      ),
                      CTextFormField(
                        controller: montantCtl,
                        keyboardType: TextInputType.number,
                        externalLabel: 'Montant à prélever*',
                        require: true,
                        margin: const EdgeInsets.only(bottom: 24),
                        suffix: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "FCFA",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      CButton(
                        title: 'Ajouter le règlement',
                        radius: 16,
                        height: 50,
                        fontWeight: FontWeight.w800,
                        onPressed: () {
                          if (selectedCaisse == null) {
                            Get.snackbar(
                              'Erreur',
                              'Veuillez sélectionner une caisse',
                              backgroundColor: Colors.red.shade700,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 14,
                            );
                            return;
                          }
                          if (montantCtl.text.isEmpty) {
                            Get.snackbar(
                              'Erreur',
                              'Veuillez saisir un montant',
                              backgroundColor: Colors.red.shade700,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 14,
                            );
                            return;
                          }

                          ctl.ligneRows.add(
                            EditionDepensePageVctl.createLine(
                              selectedCaisse!,
                              montantCtl.text,
                            ),
                          );
                          ctl.update();
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
