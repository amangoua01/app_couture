import 'dart:async';

import 'package:ateliya/api/accueil_api.dart';
import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/data/models/accueil_data.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/printer_manager_view_mixin.dart';
import 'package:flutter/material.dart';

class HomePageVctl extends AuthViewController with PrinterManagerViewMixin {
  var data = AccueilData();
  final api = AccueilApi();
  final scrollCtl = ScrollController();
  final boutiqueApi = BoutiqueApi();

  Future<void> loadData() async {
    final entite = getEntite().value;
    loadUnreadCount();
    if (entite.isNotEmpty) {
      final res = await api.getAccueilData(entite.id!, entite.type).load();
      if (res.status) {
        data = res.data!;
        update();
      } else {
        CMessageDialog.show(message: res.message);
      }
    }
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }

  @override
  void onClose() {
    scrollCtl.dispose();
    super.onClose();
  }

  Future<void> deletePaiement(int id) async {
    final confirm = await CChoiceMessageDialog.show(
      message: "Voulez-vous vraiment supprimer cette vente ?",
      validText: "Supprimer",
      cancelText: "Annuler",
      secondaryColor: Colors.red,
    );
    if (confirm == true) {
      final res = await boutiqueApi.deletePaiement(id).load();
      if (res.status) {
        data.meilleuresVentes.removeWhere((e) => e.id == id);
        update();
      } else {
        CMessageDialog.show(message: res.message);
      }
    }
  }
}
