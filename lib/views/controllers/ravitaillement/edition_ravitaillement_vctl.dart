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

class EditionRavitaillementVctl extends AuthViewController {
  final _boutiqueApi = BoutiqueApi();
  final _stockApi = ModeleBoutiqueApi();

  bool isLoading = false;

  /// Groupes modèle → variantes (StockModeleItem) pour le dropdown
  List<StockModeleItem> stockItems = [];

  /// Toutes les variantes aplaties (une ligne = un ModeleBoutique)
  List<ModeleBoutique> get allVariantes =>
      stockItems.expand((s) => s.variantes).toList();

  /// Lignes du formulaire
  final List<_LigneForm> lignes = [_LigneForm()];

  @override
  void onReady() {
    super.onReady();
    _loadStockItems();
  }

  Future<void> _loadStockItems() async {
    final entite = getEntite().value;
    if (entite.isEmpty || entite is! Boutique) return;

    isLoading = true;
    update();

    try {
      final res = await _boutiqueApi.getModeleBoutiqueByBoutiqueId(entite.id!);
      if (res.status) {
        stockItems = res.data ?? [];
      } else {
        CMessageDialog.show(message: res.message);
      }
    } catch (_) {}

    isLoading = false;
    update();
  }

  void addLigne() {
    lignes.add(_LigneForm());
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
    update();
  }

  Future<void> submit() async {
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
    }

    final entite = getEntite().value;
    if (entite is! Boutique || entite.id == null) {
      CMessageDialog.show(message: 'Aucune boutique sélectionnée');
      return;
    }

    final lignesPayload = lignes
        .map((l) => {
              'modeleBoutiqueId': l.modele!.id!,
              'quantite': int.tryParse(l.quantiteCtl.text) ?? 1,
            })
        .toList();

    final res = await _stockApi
        .entreeStock(
          boutiqueId: entite.id!,
          lignes: lignesPayload,
        )
        .load();

    if (res.status) {
      CMessageDialog.show(
        message: 'Ravitaillement enregistré avec succès',
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

class _LigneForm {
  ModeleBoutique? modele;
  final TextEditingController quantiteCtl = TextEditingController(text: '1');
}
