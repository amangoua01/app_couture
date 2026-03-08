import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/api/modele_boutique_api.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/stock_modele_item.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionTransfertStockVctl extends AuthViewController {
  final _boutiqueApi = BoutiqueApi();
  final _stockApi = ModeleBoutiqueApi();

  bool isLoading = false;
  bool isBoutiquesLoading = false;

  /// Boutiques disponibles pour le transfert
  List<Boutique> boutiques = [];
  Boutique? selectedBoutique;

  /// Groupes modèle → variantes (StockModeleItem) pour le dropdown
  List<StockModeleItem> stockItems = [];

  /// Toutes les variantes aplaties (une ligne = un ModeleBoutique)
  List<ModeleBoutique> get allVariantes =>
      stockItems.expand((s) => s.variantes).toList();

  /// Lignes du formulaire
  final List<_LigneTransfertForm> lignes = [_LigneTransfertForm()];

  @override
  void onReady() {
    super.onReady();
    _loadData();
  }

  Future<void> _loadData() async {
    final entite = getEntite().value;
    if (entite.isEmpty || entite is! Boutique) {
      CMessageDialog.show(
          message: "Veuillez sélectionner une boutique source.");
      Get.back();
      return;
    }

    isLoading = true;
    update();

    try {
      // Load current boutique's stock
      final resStock =
          await _boutiqueApi.getModeleBoutiqueByBoutiqueId(entite.id!);
      if (resStock.status) {
        stockItems = resStock.data ?? [];
      } else {
        CMessageDialog.show(message: resStock.message);
      }

      // Load all boutiques to allow choosing a destination
      final resBoutique = await _boutiqueApi.list();
      if (resBoutique.status) {
        // Exclude the current boutique from the list of destinations
        boutiques = (resBoutique.data?.items ?? [])
            .where((b) => b.id != entite.id)
            .toList();
      } else {
        CMessageDialog.show(message: resBoutique.message);
      }
    } catch (_) {}

    isLoading = false;
    update();
  }

  void addLigne() {
    lignes.add(_LigneTransfertForm());
    update();
  }

  void removeLigne(int index) {
    if (lignes.length > 1) {
      lignes[index].quantiteCtl.dispose();
      lignes.removeAt(index);
      update();
    }
  }

  void setModele(int index, ModeleBoutique? modele) {
    lignes[index].modele = modele;
    // Par défaut, mettre la quantité à 1 s'il n'y avait rien ou réinitialiser.
    if (lignes[index].quantiteCtl.text.isEmpty) {
      lignes[index].quantiteCtl.text = '1';
    }
    update();
  }

  void setSelectedBoutique(Boutique? boutique) {
    selectedBoutique = boutique;
    update();
  }

  Future<void> submit() async {
    if (selectedBoutique == null) {
      CMessageDialog.show(
          message: "Veuillez sélectionner la boutique réceptrice.");
      return;
    }

    // Validation
    for (var i = 0; i < lignes.length; i++) {
      final ligne = lignes[i];
      if (ligne.modele == null) {
        CMessageDialog.show(
            message: 'Ligne ${i + 1} : sélectionnez un article');
        return;
      }
      final qty = int.tryParse(ligne.quantiteCtl.text) ?? 0;
      if (qty <= 0) {
        CMessageDialog.show(message: 'Ligne ${i + 1} : quantité invalide');
        return;
      }
      final maxQty = ligne.modele?.quantite ?? 0;
      if (qty > maxQty) {
        CMessageDialog.show(
            message:
                'Ligne ${i + 1} : stock insuffisant pour cet article (max $maxQty)');
        return;
      }
    }

    final entite = getEntite().value;
    if (entite is! Boutique || entite.id == null) {
      CMessageDialog.show(message: 'Aucune boutique émettrice sélectionnée');
      return;
    }

    final lignesPayload = lignes
        .map((l) => {
              'modeleBoutiqueId': l.modele!.id!,
              'quantite': int.tryParse(l.quantiteCtl.text) ?? 1,
            })
        .toList();

    final res = await _stockApi
        .transfertStock(
          boutiqueEmetteurId: entite.id!,
          boutiqueReceptriceId: selectedBoutique!.id!,
          lignes: lignesPayload,
        )
        .load();

    if (res.status) {
      CMessageDialog.show(
        message: 'Transfert effectué avec succès',
        isSuccess: true,
      );
      Get.back(result: true);
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  @override
  void onClose() {
    for (final l in lignes) {
      l.quantiteCtl.dispose();
    }
    super.onClose();
  }
}

class _LigneTransfertForm {
  ModeleBoutique? modele;
  final TextEditingController quantiteCtl = TextEditingController(text: '1');
}
