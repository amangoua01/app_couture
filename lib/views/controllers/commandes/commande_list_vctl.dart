import 'package:ateliya/api/facture_api.dart';
import 'package:ateliya/data/models/factures_grouped.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';

class CommandeListVctl extends AuthViewController {
  final api = FactureApi();

  bool isLoading = false;
  FacturesGrouped? data;

  // Filtres
  final dateDebut = DateTimeEditingController();
  final dateFin = DateTimeEditingController();
  final nomClientCtrl = TextEditingController();
  final numeroClientCtrl = TextEditingController();
  String? etatFacture;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  Future<void> getList() async {
    isLoading = true;
    update();

    final dateDebutStr = dateDebut.dateTime?.toIso8601String().split('T').first;
    final dateFinStr = dateFin.dateTime?.toIso8601String().split('T').first;

    final res = await api.getFacturesEntreprise(
      getEntite().value.id.value,
      dateDebut: dateDebutStr,
      dateFin: dateFinStr,
      nomClient: nomClientCtrl.text.trim(),
      numeroClient: numeroClientCtrl.text.trim(),
      etatFacture: etatFacture,
    );

    isLoading = false;

    if (res.status) {
      data = res.data;
    } else {
      CMessageDialog.show(message: res.message);
      data = FacturesGrouped(); // fallback
    }

    update();
  }

  void rechargerList() {
    getList();
  }

  void resetFilters() {
    dateDebut.clear();
    dateFin.clear();
    nomClientCtrl.clear();
    numeroClientCtrl.clear();
    etatFacture = null;
    getList();
  }
}
