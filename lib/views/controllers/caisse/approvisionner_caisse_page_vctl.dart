import 'package:ateliya/api/caisse_api.dart';
import 'package:ateliya/data/dto/ligne_mouvement_caisse_dto.dart';
import 'package:ateliya/data/dto/mouvement_caisse_dto.dart';
import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/constants/sens_mouvement_caisse_enum.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MouvementCaisseLine {
  Caisse? caisse;
  final montantCtl = TextEditingController();
}

class ApprovisionnerCaissePageVctl extends GetxController {
  final api = CaisseApi();
  final descriptionCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ModePaiementEnum modePaiement = ModePaiementEnum.especes;
  SensMouvementCaisseEnum sens = SensMouvementCaisseEnum.entree;

  // List to manage multiple lines
  // List to manage multiple lines
  final lines = <MouvementCaisseLine>[].obs;

  @override
  void onInit() {
    super.onInit();
    // No initial line added anymore, handled by BottomSheet
  }

  void addLine() {
    final line = MouvementCaisseLine();
    line.montantCtl.addListener(() {
      update();
    });
    lines.add(line);
    update();
  }

  static MouvementCaisseLine createLine(Caisse caisse, String montant) {
    final line = MouvementCaisseLine();
    line.caisse = caisse;
    line.montantCtl.text = montant;
    return line;
  }

  void removeLine(int index) {
    lines.removeAt(index);
    update();
  }

  double get totalMontant {
    double total = 0;
    for (var line in lines) {
      total += line.montantCtl.text.fromAmountToDouble() ?? 0;
    }
    return total;
  }

  Future<List<Caisse>> getCaisses() async {
    final res = await api.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      // Validate that all lines have a caisse selected and a montant
      for (var line in lines) {
        if (line.caisse == null) {
          CMessageDialog.show(
              message:
                  "Veuillez sélectionner une caisse pour toutes les lignes");
          return;
        }
        if (line.montantCtl.text.isEmpty) {
          CMessageDialog.show(
              message: "Veuillez saisir un montant pour toutes les lignes");
          return;
        }

        // final montantSaisi = line.montantCtl.text.fromAmountToDouble() ?? 0.0;
        // final montantDisponible =
        //     line.caisse!.montant.fromAmountToDouble() ?? 0.0;

        // if (montantSaisi > montantDisponible) {
        //   CMessageDialog.show(
        //     message:
        //         "Solde inssufisant pour la caisse ${line.caisse!.reference} (Disponible: ${line.caisse!.montant.toAmount(unit: 'F')})",
        //   );
        //   return;
        // }
      }

      // Calculate total amount
      double totalMontant = 0;
      final lignesData = <LigneMouvementCaisseDto>[];

      for (var line in lines) {
        final montantSaisi = line.montantCtl.text.fromAmountToDouble() ?? 0.0;
        totalMontant += montantSaisi;
        lignesData.add(LigneMouvementCaisseDto(
          caisseId: line.caisse!.id,
          montant: montantSaisi.toInt().toString(),
        ));
      }

      final data = MouvementCaisseDto(
        sens: sens,
        montant: totalMontant.toDouble().value.toString(),
        description: descriptionCtl.text,
        moyenPaiement: modePaiement.label,
        lignes: lignesData,
      );

      final res = await api.addMouvement(data).load();
      if (res.status) {
        Get.back(result: true);
        CMessageDialog.show(
          message: "Mouvement ajouté avec succès",
          isSuccess: true,
        );
      } else {
        CMessageDialog.show(message: res.message);
      }
    }
  }
}
