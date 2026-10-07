import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/tools/extensions/types/text_editing_controller.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Édition rapide du montant/remise d'une pièce, utilisée à la fois sur
/// l'écran de liste des pièces et sur le récapitulatif final : dans les
/// deux cas on veut pouvoir corriger un prix sans rouvrir toute la fiche de
/// la pièce.
Future<void> editMontantPiece(
  EditionMesurePageVctl ctl,
  LigneMesureDto piece,
) async {
  final montantCtl = TextEditingController()..setDouble = piece.montant;
  final remiseCtl = TextEditingController()..setDouble = piece.remise;

  await Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Modifier le montant"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CTextFormField(
            controller: montantCtl,
            externalLabel: "Montant",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
          ),
          CTextFormField(
            controller: remiseCtl,
            externalLabel: "Remise",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        CButton(
          title: "Enregistrer",
          onPressed: () {
            piece.montant = montantCtl.toDouble();
            piece.remise = remiseCtl.toDouble();
            ctl.update();
            Get.back();
          },
        ),
      ],
    ),
  );
}
