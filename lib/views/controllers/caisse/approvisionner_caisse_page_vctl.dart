import 'package:ateliya/api/caisse_api.dart';
import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/text_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MouvementLine {
  Caisse? caisse;
  final montantCtl = TextEditingController();
}

class ApprovisionnerCaissePageVctl extends GetxController {
  final api = CaisseApi();
  final descriptionCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // List to manage multiple lines
  final lines = <MouvementLine>[].obs;

  @override
  void onInit() {
    super.onInit();
    addLine(); // Add one initial line
  }

  void addLine() {
    final line = MouvementLine();
    line.montantCtl.addListener(() {
      update();
    });
    lines.add(line);
    update();
  }

  void removeLine(int index) {
    if (lines.length > 1) {
      lines.removeAt(index);
      update();
    }
  }

  double get totalMontant {
    double total = 0;
    for (var line in lines) {
      total += line.montantCtl.toDouble();
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
      final lignesData = <Map<String, dynamic>>[];

      for (var line in lines) {
        final montant = line.montantCtl.toDouble();
        totalMontant += montant;
        lignesData.add({
          "caisse_id": line.caisse!.id,
          "montant": line.montantCtl.text,
        });
      }

      final data = {
        "montant": totalMontant.toInt().toString(),
        "description": descriptionCtl.text,
        "lignes": lignesData,
      };

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
