import 'package:ateliya/api/caisse_api.dart';
import 'package:ateliya/api/depense_api.dart';
import 'package:ateliya/api/famille_depense_api.dart';
import 'package:ateliya/data/dto/depense_dto.dart';
import 'package:ateliya/data/dto/ligne_depense_dto.dart';
import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EditionDepensePageVctl extends GetxController {
  final formKey = GlobalKey<FormState>();
  final montantCtl = TextEditingController();
  final descriptionCtl = TextEditingController();
  FamilleDepense? selectedFamille;
  Caisse? selectedCaisse;

  final familleDepenseApi = FamilleDepenseApi();
  final caisseApi = CaisseApi();
  final depenseApi = DepenseApi();

  Future<List<FamilleDepense>> getFamilles() async {
    final res = await familleDepenseApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }

  Future<List<Caisse>> getCaisses() async {
    final res = await caisseApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }

  List<Caisse> caisses = [];
  List<LigneDepenseRow> ligneRows = [];

  @override
  void onInit() {
    super.onInit();
    loadCaisses();
    montantCtl.addListener(update);
  }

  @override
  void onClose() {
    montantCtl.removeListener(update);
    for (var row in ligneRows) {
      row.montantCtl.removeListener(update);
    }
    super.onClose();
  }

  Future<void> loadCaisses() async {
    final res = await caisseApi.list();
    if (res.status) {
      caisses = res.data!.items;
      update();
    }
  }

  void addLigne() {
    if (montantCtl.text.isEmpty) {
      EasyLoading.showError("Veuillez d'abord saisir le montant total");
      return;
    }
    final row = LigneDepenseRow();
    row.montantCtl.addListener(update);
    ligneRows.add(row);
    update();
  }

  void removeLigne(int index) {
    if (ligneRows.isNotEmpty) {
      final row = ligneRows.removeAt(index);
      row.montantCtl.removeListener(update);
      update();
    }
  }

  double get totalMontant => double.tryParse(montantCtl.text) ?? 0;

  double get totalLignes {
    double sum = 0;
    for (var row in ligneRows) {
      sum += double.tryParse(row.montantCtl.text) ?? 0;
    }
    return sum;
  }

  double get progress {
    if (totalMontant == 0) return 0;
    return (totalLignes / totalMontant).clamp(0.0, 1.0);
  }

  Future<List<Caisse>> getCaissesHelper() async {
    if (caisses.isEmpty) await loadCaisses();
    return caisses;
  }

  Future<void> submit() async {
    if (selectedFamille == null) {
      EasyLoading.showError("Veuillez sélectionner une famille de dépense");
      return;
    }

    // Check global amount
    if (montantCtl.text.isEmpty) {
      EasyLoading.showError("Veuillez saisir le montant total");
      return;
    }

    if (ligneRows.isEmpty) {
      EasyLoading.showError("Veuillez ajouter au moins une ligne de paiement");
      return;
    }

    if (formKey.currentState!.validate()) {
      List<LignesDepenseDto> lignesDto = [];
      double totalAmount = double.tryParse(montantCtl.text) ?? 0;
      double linesSum = 0;

      for (var row in ligneRows) {
        if (row.caisse == null || row.montantCtl.text.isEmpty) {
          EasyLoading.showError(
              "Veuillez compléter toutes les lignes de paiement");
          return;
        }

        double lineAmount = double.tryParse(row.montantCtl.text) ?? 0;
        double caisseBalance = double.tryParse(row.caisse?.montant ?? "0") ?? 0;

        if (lineAmount > caisseBalance) {
          EasyLoading.showError(
              "Le montant de la ligne dépasse le solde de la caisse ${row.caisse?.entite?.libelle} (${row.caisse?.type})");
          return;
        }

        linesSum += lineAmount;

        lignesDto.add(LignesDepenseDto(
          caisseId: row.caisse!.id,
          montant: row.montantCtl.text,
        ));
      }

      if (linesSum != totalAmount) {
        EasyLoading.showError(
            "La somme des lignes ($linesSum) doit être égale au montant total ($totalAmount)");
        return;
      }

      final dto = DepenseDto(
        montant: montantCtl.text,
        description: descriptionCtl.text,
        familleDepenseId: selectedFamille!.id,
        lignes: lignesDto, // Use the generated list
      );

      final res = await depenseApi.createOne(dto).load();
      if (res.status) {
        Get.back(result: true);
        CMessageDialog.show(
          message: "Dépense enregistrée avec succès",
          isSuccess: true,
        );
      } else {
        CMessageDialog.show(message: res.message);
      }
    }
  }
}

class LigneDepenseRow {
  Caisse? caisse;
  final TextEditingController montantCtl = TextEditingController();
}
