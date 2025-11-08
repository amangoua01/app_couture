import 'package:app_couture/api/modele_api.dart';
import 'package:app_couture/data/models/abstract/fichier.dart';
import 'package:app_couture/data/models/fichier_local.dart';
import 'package:app_couture/data/models/modele.dart';
import 'package:app_couture/tools/extensions/future.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/inputs/c_bottom_image_picker.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/material.dart';

class EditionModelePageVctl extends EditionViewController<Modele, ModeleApi> {
  final libelleCtl = TextEditingController();
  Fichier? photo;

  EditionModelePageVctl(super.item) : super(api: ModeleApi());

  @override
  Future<Modele?> onCreate() async {
    final categorie = Modele(
      libelle: libelleCtl.text,
      photo: photo,
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
  void onInitForm(Modele item) {
    libelleCtl.text = item.libelle.value;
    photo = item.photo;
  }

  @override
  Future<Modele?> onUpdate(Modele item) async {
    item.libelle = libelleCtl.text;
    item.photo = photo;
    final res = await api.update(item).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }

  Future<void> pickPhoto() async {
    final file = await CBottomImagePicker.show();
    if (file != null) {
      photo = FichierLocal.fromFile(file);
      update();
    }
  }
}
