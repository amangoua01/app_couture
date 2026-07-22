import 'dart:io';
import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LigneNouveaute {
  MallModeleBoutique? modele;
  File? image;
  final TextEditingController qteCtrl = TextEditingController(text: '1');
  final TextEditingController nombreStockCtrl = TextEditingController();
  final TextEditingController prixCtrl = TextEditingController();
  bool actif = true;

  LigneNouveaute();

  void dispose() {
    qteCtrl.dispose();
    nombreStockCtrl.dispose();
    prixCtrl.dispose();
  }
}

class MallLotNouveautesVctl extends AuthViewController {
  final _api = MallApi();
  final List<MallModeleBoutique> modeles;

  MallLotNouveautesVctl({required this.modeles});

  List<LigneNouveaute> lignes = [LigneNouveaute()];

  void addLigne() {
    lignes.add(LigneNouveaute());
    update();
  }

  void removeLigne(int index) {
    if (lignes.length == 1) return;
    lignes[index].dispose();
    lignes.removeAt(index);
    update();
  }

  void setModele(int index, MallModeleBoutique? m) {
    lignes[index].modele = m;
    if (m != null && lignes[index].prixCtrl.text.isEmpty) {
      lignes[index].prixCtrl.text = m.prix;
    }
    update();
  }

  void setImage(int index, File? f) {
    lignes[index].image = f;
    update();
  }

  void toggleActif(int index, bool val) {
    lignes[index].actif = val;
    update();
  }

  Future<void> soumettre() async {
    final invalides = lignes.where((l) => l.modele == null).toList();
    if (invalides.isNotEmpty) {
      CSnackbar.show(
          message: 'Veuillez sélectionner un modèle pour chaque ligne');
      return;
    }

    final items = lignes
        .map((l) => {
              'modeleBoutiqueId': l.modele!.id,
              'quantite': int.tryParse(l.qteCtrl.text) ?? 1,
              if (l.nombreStockCtrl.text.isNotEmpty)
                'nombreStock': int.tryParse(l.nombreStockCtrl.text),
              'isNouveau': true,
              'isPromotion': false,
              'isActive': l.actif,
              if (l.prixCtrl.text.isNotEmpty) 'prixNouveau': l.prixCtrl.text,
            })
        .toList();

    final images = lignes.map((l) => l.image).toList();

    final res = await _api
        .createPromotionsNouveautes(items, images: images)
        .load();
    if (res.status) {
      CSnackbar.show(
          message: 'Nouveautés déclarées avec succès', isSuccess: true);
      Get.back(result: true);
    } else {
      CSnackbar.show(message: res.message);
    }
  }

  @override
  void onClose() {
    for (final l in lignes) {
      l.dispose();
    }
    super.onClose();
  }
}
