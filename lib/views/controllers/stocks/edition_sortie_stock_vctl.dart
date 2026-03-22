import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/api/modele_boutique_api.dart';
import 'package:ateliya/data/dto/ligne_mouvement_stock_dto.dart';
import 'package:ateliya/data/dto/mouvement_stock_dto.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/stock_modele_item.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionSortieStockVctl extends AuthViewController {
  final _boutiqueApi = BoutiqueApi();
  final _modeleBoutiqueApi = ModeleBoutiqueApi();

  bool isLoading = false;
  final commentaireCtl = TextEditingController();

  /// Groupes modèle → variantes (StockModeleItem) pour le dropdown
  List<StockModeleItem> stockItems = [];

  /// Toutes les variantes aplaties (une ligne = un ModeleBoutique)
  List<ModeleBoutique> get allVariantes =>
      stockItems.expand((s) => s.variantes).toList();

  /// Lignes du formulaire
  final List<SortieStockLigneForm> lignes = [SortieStockLigneForm()];

  EditionSortieStockVctl(ModeleBoutique? item) {
    if (item != null) {
      lignes.first.modele = item;
    }
  }

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
    lignes.add(SortieStockLigneForm());
    update();
  }

  void removeLigne(int index) {
    if (lignes.length > 1) {
      lignes[index].dispose();
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
      if (qty > (ligne.modele?.quantite ?? 0)) {
        CMessageDialog.show(message: 'Ligne ${i + 1} : stock insuffisant');
        return;
      }
    }

    final entite = getEntite().value;
    if (entite is! Boutique || entite.id == null) {
      CMessageDialog.show(message: 'Aucune boutique sélectionnée');
      return;
    }

    final lignesPayload = lignes
        .map((l) => LigneMouvementStockDto(
              modeleBoutiqueId: l.modele!.id!,
              quantite: int.tryParse(l.quantiteCtl.text) ?? 1,
              motif:
                  l.motifCtl.text.isEmpty ? 'Sortie directe' : l.motifCtl.text,
            ))
        .toList();

    //  {
    //       'modeleBoutiqueId': l.modele!.id!,
    //       'quantite': int.tryParse(l.quantiteCtl.text) ?? 1,
    //       'motif': l.motifCtl.text.isEmpty ? 'Sortie directe' : l.motifCtl.text,
    //     }

    final res = await _modeleBoutiqueApi
        .sortieDirecte(
          MouvementStockDto(
            boutiqueId: entite.id!,
            commentaire: commentaireCtl.text,
            lignes: lignesPayload,
          ),
        )
        .load();

    if (res.status) {
      CMessageDialog.show(
        message: 'Sortie de stock enregistrée avec succès',
        isSuccess: true,
      );
      Get.back(result: true);
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  @override
  void onClose() {
    commentaireCtl.dispose();
    for (final l in lignes) {
      l.dispose();
    }
    super.onClose();
  }
}

class SortieStockLigneForm {
  ModeleBoutique? modele;
  final quantiteCtl = TextEditingController(text: '1');
  final motifCtl = TextEditingController();

  void dispose() {
    quantiteCtl.dispose();
    motifCtl.dispose();
  }
}
