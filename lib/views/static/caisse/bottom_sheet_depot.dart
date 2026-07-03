import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/caisse/approvisionner_caisse_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BottomSheetDepot {
  static void show(ApprovisionnerCaissePageVctl ctl) {
    ctl.resetBottomSheet();

    Get.bottomSheet(
      Container(
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
            const Center(
              child: Text(
                'Ajouter un montant',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Gap(24),
            CDropDownFormField<Caisse>(
              externalLabel: "Sélectionner la caisse",
              require: true,
              selectedItem: ctl.selectedCaisse,
              onChanged: (e) => ctl.onCaisseSelected(e),
              items: (filter, loadProps) => ctl.getCaisses(),
              itemAsString: (item) =>
                  "${item.entite!.libelle.value} (${item.montant!.toAmount(unit: 'F')})",
            ),
            CTextFormField(
              externalLabel: "Montant",
              controller: ctl.montantBottomSheetCtl,
              require: true,
              keyboardType: TextInputType.number,
              margin: const EdgeInsets.only(bottom: 24),
            ),
            CButton(
              title: 'Ajouter au mouvement',
              onPressed: () {
                if (ctl.validateAndAddLine()) {
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
