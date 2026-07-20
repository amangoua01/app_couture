import 'dart:io';

import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_statut.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MallStatusVctl extends AuthViewController {
  final _api = MallApi();

  List<MallStatut> statuts = [];
  bool loading = true;

  // Form
  String selectedType = 'TEXTE';
  final contenuCtl = TextEditingController();
  File? fichier;

  int get entrepriseId => user.entreprise?.id ?? 0;

  void setType(String t) {
    selectedType = t;
    fichier = null;
    update();
  }

  void setFichier(File f) {
    fichier = f;
    update();
  }

  void removeFichier() {
    fichier = null;
    update();
  }

  void clearForm() {
    selectedType = 'TEXTE';
    contenuCtl.clear();
    fichier = null;
  }

  @override
  void onInit() {
    super.onInit();
    loadStatuts();
  }

  @override
  void onClose() {
    contenuCtl.dispose();
    super.onClose();
  }

  Future<void> loadStatuts({bool silent = false}) async {
    if (!silent) {
      loading = true;
      update();
    }
    final res = await _api.getStatutsEntreprise(entrepriseId).load();
    if (res.status) statuts = res.data ?? [];
    loading = false;
    update();
  }

  Future<void> createStatut(VoidCallback closeSheet) async {
    if (selectedType != 'TEXTE' && fichier == null) {
      CSnackbar.show(message: 'Veuillez sélectionner un fichier');
      return;
    }
    final res = await _api
        .createStatut(entrepriseId, selectedType, contenuCtl.text,
            fichier: fichier)
        .load();
    if (res.status) {
      CSnackbar.show(message: 'Statut publié avec succès', isSuccess: true);
      clearForm();
      closeSheet();
      loadStatuts(silent: true);
    } else {
      CSnackbar.show(message: res.message);
    }
  }

  Future<void> deleteStatut(int id) async {
    // Suppression optimiste
    statuts.removeWhere((s) => s.id == id);
    update();
    final res = await _api.deleteStatut(id, entrepriseId).load();
    if (res.status) {
      CSnackbar.show(message: 'Statut supprimé', isSuccess: true);
    } else {
      CSnackbar.show(message: res.message);
      loadStatuts(silent: true); // rollback
    }
  }

  Future<void> incrementVues(int id) async {
    // Silencieux, pas de loading
    _api.incrementStatutVues(id);
  }
}
