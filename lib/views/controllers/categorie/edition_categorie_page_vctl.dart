import 'package:app_couture/api/categorie_mesure_api.dart';
import 'package:app_couture/data/models/categorie_mesure.dart';
import 'package:app_couture/tools/extensions/future.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/material.dart';

class EditionCategoriePageVctl
    extends EditionViewController<CategorieMesure, CategorieMesureApi> {
  final libelleCtl = TextEditingController();
  EditionCategoriePageVctl(super.item) : super(api: CategorieMesureApi());

  @override
  Future<CategorieMesure?> onCreate() async {
    final categorie = CategorieMesure(
      libelle: libelleCtl.text,
    );
    final res = await api.create(categorie).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }

  @override
  void onInitForm(CategorieMesure item) {
    libelleCtl.text = item.libelle.value;
  }

  @override
  Future<CategorieMesure?> onUpdate(CategorieMesure item) async {
    item.libelle = libelleCtl.text;
    final res = await api.update(item).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }
}
