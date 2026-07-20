import 'dart:io';

import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MallEditionModeleVctl extends AuthViewController {
  final MallModeleBoutique item;
  MallEditionModeleVctl({required this.item});

  final _api = MallApi();

  late final prixCtrl = TextEditingController(text: item.prix);

  bool isVisible = true;
  bool isNouveaute = false;
  bool isSurMesure = false;
  bool isPromotion = false;

  File? imagePromo;
  File? photo;

  void toggleVisible(bool v) {
    isVisible = v;
    update();
  }

  void toggleNouveaute(bool v) {
    isNouveaute = v;
    update();
  }

  void toggleSurMesure(bool v) {
    isSurMesure = v;
    update();
  }

  void togglePromotion(bool v) {
    isPromotion = v;
    update();
  }

  void setImagePromo(File f) {
    imagePromo = f;
    update();
  }

  void setPhoto(File f) {
    photo = f;
    update();
  }

  Future<void> save() async {
    final res = await _api.updateModeleVisibility(item.id).load();
    if (res.status) {
      CSnackbar.show(message: 'Modèle mis à jour avec succès', isSuccess: true);
      Get.back(result: true);
    } else {
      CSnackbar.show(message: res.message ?? 'Erreur inconnue');
    }
  }

  @override
  void onClose() {
    prixCtrl.dispose();
    super.onClose();
  }
}
