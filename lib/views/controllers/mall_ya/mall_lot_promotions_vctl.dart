import 'dart:io';
import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LignePromotion {
  MallModeleBoutique? modele;
  File? image;
  final TextEditingController qteCtrl = TextEditingController(text: '1');
  final TextEditingController nombreStockCtrl = TextEditingController();
  final TextEditingController prixLotCtrl = TextEditingController();
  final TextEditingController prixUniteCtrl = TextEditingController();
  final TextEditingController finCtrl = TextEditingController();
  DateTime? dateFin;
  bool actif = true;

  LignePromotion();

  void dispose() {
    qteCtrl.dispose();
    nombreStockCtrl.dispose();
    prixLotCtrl.dispose();
    prixUniteCtrl.dispose();
    finCtrl.dispose();
  }
}

class MallLotPromotionsVctl extends AuthViewController {
  final _api = MallApi();
  final List<MallModeleBoutique> modeles;

  MallLotPromotionsVctl({required this.modeles});

  List<LignePromotion> lignes = [LignePromotion()];

  void addLigne() {
    lignes.add(LignePromotion());
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
    if (m != null && lignes[index].prixLotCtrl.text.isEmpty) {
      lignes[index].prixLotCtrl.text = m.prix;
    }
    update();
  }

  void setImage(int index, File? f) {
    lignes[index].image = f;
    update();
  }

  void setDateFin(int index, DateTime date) {
    lignes[index].dateFin = date;
    lignes[index].finCtrl.text =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
              'isNouveau': false,
              'isPromotion': true,
              'isActive': l.actif,
              if (l.prixLotCtrl.text.isNotEmpty)
                'prixPromotion': l.prixLotCtrl.text,
              if (l.prixUniteCtrl.text.isNotEmpty)
                'prixUnite': l.prixUniteCtrl.text,
              if (l.dateFin != null)
                'dateFinPromotion':
                    '${l.dateFin!.year}-${l.dateFin!.month.toString().padLeft(2, '0')}-${l.dateFin!.day.toString().padLeft(2, '0')} 23:59:59',
            })
        .toList();

    final images = lignes.map((l) => l.image).toList();

    final res =
        await _api.createPromotionsNouveautes(items, images: images).load();
    if (res.status) {
      CSnackbar.show(message: 'Promotions créées avec succès', isSuccess: true);
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
