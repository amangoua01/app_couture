import 'package:ateliya/api/type_mesure_api.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/material.dart';

class EditionTypeMesurePageVctl extends EditionViewController<TypeMesure, TypeMesureApi> {
  final libelleCtl = TextEditingController();

  EditionTypeMesurePageVctl(super.item, {required super.api});

  @override
  void onClose() {
    libelleCtl.dispose();
    super.onClose();
  }

  @override
  Future<TypeMesure?> onCreate() async {
    final typeMesure = TypeMesure(libelle: libelleCtl.text.value);
    final res = await api.create(typeMesure).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }

  @override
  void onInitForm(TypeMesure item) {
    libelleCtl.text = item.libelle.value;
  }

  @override
  Future<TypeMesure?> onUpdate(TypeMesure item) async {
    item.libelle = libelleCtl.text.value;
    final res = await api.update(item).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }
}