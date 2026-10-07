import 'package:ateliya/api/caisse_api.dart';
import 'package:ateliya/api/charge_api.dart';
import 'package:ateliya/api/depense_api.dart';
import 'package:ateliya/api/famille_depense_api.dart';
import 'package:ateliya/data/dto/depense_dto.dart';
import 'package:ateliya/data/dto/ligne_depense_dto.dart';
import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/data/models/charge.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/services/gemini_assistant_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionDepensePageVctl extends GetxController {
  final DepenseExtractionResult? initialData;
  EditionDepensePageVctl({this.initialData});

  final formKey = GlobalKey<FormState>();
  final montantCtl = TextEditingController();
  final descriptionCtl = TextEditingController();
  FamilleDepense? selectedFamille;
  Caisse? selectedCaisse;
  Charge? selectedCharge;
  bool isLoading = false;
  bool isAiPrefilled = false;

  /// Une dépense part soit d'une charge récurrente (type et montant
  /// hérités), soit d'une saisie libre : les deux parcours sont exclusifs
  /// plutôt que mélangés dans un même formulaire.
  bool isFromCharge = false;

  void setFromCharge(bool value) {
    if (isFromCharge == value) return;
    isFromCharge = value;
    selectedCharge = null;
    selectedFamille = null;
    montantCtl.clear();
    update();
  }

  final familleDepenseApi = FamilleDepenseApi();
  final chargeApi = ChargeApi();
  final caisseApi = CaisseApi();
  final depenseApi = DepenseApi();

  Future<List<FamilleDepense>> getFamilles() async {
    final res = await familleDepenseApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }

  Future<List<Charge>> getCharges() async {
    final res = await chargeApi.list();
    return res.status ? res.data! : [];
  }

  /// Pré-remplit le type et le montant à partir d'une charge récurrente ;
  /// l'utilisateur garde la main pour tout ajuster avant de valider.
  void applyCharge(Charge? charge) {
    selectedCharge = charge;
    if (charge != null) {
      selectedFamille = charge.familleDepense ?? selectedFamille;
      montantCtl.text = charge.montant ?? montantCtl.text;
    }
    update();
  }

  Future<List<Caisse>> getCaisses() async {
    final res = await caisseApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }

  List<Caisse> caisses = [];
  final ligneRows = <LigneDepenseForm>[].obs;

  @override
  void onInit() {
    super.onInit();
    montantCtl.addListener(update);
    _initData();
  }

  Future<void> _initData() async {
    await loadCaisses();
    if (initialData != null) {
      await applyExtraction(initialData!);
    }
  }

  Future<void> applyExtraction(DepenseExtractionResult data) async {
    isAiPrefilled = true;
    if (data.montant != null) {
      montantCtl.text = data.montant.toString();
    }
    if (data.description != null && data.description!.isNotEmpty) {
      descriptionCtl.text = data.description!;
    }

    try {
      final familles = await getFamilles();
      if (familles.isNotEmpty) {
        if (data.suggestionCategorie != null) {
          final query = data.suggestionCategorie!.toLowerCase();
          final match = familles.firstWhereOrNull((f) {
            final lib = (f.libelle ?? '').toLowerCase();
            return lib.contains(query) || query.contains(lib);
          });
          selectedFamille = match ?? familles.first;
        } else {
          selectedFamille = familles.first;
        }
      }
    } catch (_) {}

    try {
      if (caisses.isNotEmpty && data.montant != null) {
        Caisse? matchedCaisse;
        if (data.caisse != null) {
          final q = data.caisse!.toLowerCase();
          matchedCaisse = caisses.firstWhereOrNull((c) {
            final lib = (c.entite?.libelle ?? '').toLowerCase();
            final type = (c.type ?? '').toLowerCase();
            return lib.contains(q) || type.contains(q);
          });
        }
        matchedCaisse ??= caisses.first;

        ligneRows.clear();
        final line = createLine(matchedCaisse, data.montant.toString());
        line.montantCtl.addListener(update);
        ligneRows.add(line);
      }
    } catch (_) {}

    update();
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
      CMessageDialog.show(message: "Veuillez d'abord saisir le montant total");
      return;
    }
    final row = LigneDepenseForm();
    row.montantCtl.addListener(update);
    ligneRows.add(row);
    update();
  }

  static LigneDepenseForm createLine(Caisse caisse, String montant) {
    final row = LigneDepenseForm();
    row.caisse = caisse;
    row.montantCtl.text = montant;
    return row;
  }

  void removeLigne(int index) {
    final row = ligneRows.removeAt(index);
    row.montantCtl.removeListener(update);
    update();
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
    if (isFromCharge) {
      if (selectedCharge == null) {
        CMessageDialog.show(message: "Veuillez sélectionner une charge");
        return;
      }
    } else if (selectedFamille == null) {
      CMessageDialog.show(message: "Veuillez sélectionner un type de dépense");
      return;
    }

    if (montantCtl.text.isEmpty) {
      CMessageDialog.show(message: "Veuillez saisir le montant total");
      return;
    }

    if (ligneRows.isEmpty) {
      CMessageDialog.show(
        message: "Veuillez ajouter au moins une ligne de paiement",
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      List<LignesDepenseDto> lignesDto = [];
      double totalAmount = double.tryParse(montantCtl.text) ?? 0;
      double linesSum = 0;

      for (var row in ligneRows) {
        if (row.caisse == null || row.montantCtl.text.isEmpty) {
          CMessageDialog.show(
            message: "Veuillez compléter toutes les lignes de paiement",
          );
          return;
        }

        double lineAmount = double.tryParse(row.montantCtl.text) ?? 0;
        double caisseBalance = double.tryParse(row.caisse?.montant ?? "0") ?? 0;

        if (lineAmount > caisseBalance) {
          CMessageDialog.show(
            message:
                "Le montant dépasse le solde de la caisse ${row.caisse?.entite?.libelle} (${row.caisse?.type})",
          );
          return;
        }

        linesSum += lineAmount;

        lignesDto.add(
          LignesDepenseDto(
            caisseId: row.caisse!.id,
            montant: row.montantCtl.text,
          ),
        );
      }

      if (linesSum != totalAmount) {
        CMessageDialog.show(
          message:
              "La somme des lignes ($linesSum) doit être égale au montant total ($totalAmount)",
        );
        return;
      }

      final dto = DepenseDto(
        montant: montantCtl.text,
        description: descriptionCtl.text,
        familleDepenseId: selectedFamille?.id,
        chargeId: selectedCharge?.id,
        lignes: lignesDto,
      );

      isLoading = true;
      update();

      final res = await depenseApi.createOne(dto).load();

      isLoading = false;
      update();

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

class LigneDepenseForm {
  Caisse? caisse;
  final TextEditingController montantCtl = TextEditingController();
}
