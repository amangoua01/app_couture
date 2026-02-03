import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/widgets/inputs/c_bottom_image_picker.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/material.dart';

class EditionBoutiquePageVctl
    extends EditionViewController<Boutique, BoutiqueApi> {
  final nomCtl = TextEditingController();
  final contactCtl = TextEditingController();
  final situationCtl = TextEditingController();
  Fichier? logo;

  EditionBoutiquePageVctl(super.item) : super(api: BoutiqueApi());

  Future<DataResponse<Boutique>> updateItem(Boutique boutique) async {
    boutique.libelle = nomCtl.text.value;
    boutique.contact = contactCtl.text.value;
    boutique.situation = situationCtl.text.value;
    if (logo is FichierLocal) {
      boutique.logo = logo;
    }
    final res = await api.update(boutique).load();
    return res;
  }

  Future<DataResponse<Boutique>> createItem() async {
    final boutique = Boutique(
      libelle: nomCtl.text.value,
      contact: contactCtl.text.value,
      situation: situationCtl.text.value,
      logo: logo,
    );
    final res = await api.create(boutique).load();
    return res;
  }

  @override
  void onClose() {
    nomCtl.dispose();
    contactCtl.dispose();
    situationCtl.dispose();
    super.onClose();
  }

  @override
  Future<Boutique?> onCreate() async {
    final boutique = Boutique(
      libelle: nomCtl.text.value,
      contact: contactCtl.text.value,
      situation: situationCtl.text.value,
      logo: logo,
    );
    final res = await api.create(boutique).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }

  @override
  void onInitForm(Boutique item) {
    nomCtl.text = item.libelle.value;
    contactCtl.text = item.contact.value;
    situationCtl.text = item.situation.value;
    logo = item.logo;
  }

  @override
  Future<Boutique?> onUpdate(Boutique item) async {
    item.libelle = nomCtl.text.value;
    item.contact = contactCtl.text.value;
    item.situation = situationCtl.text.value;
    if (logo is FichierLocal) {
      item.logo = logo;
    }
    final res = await api.update(item).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }

  Future<void> pickLogo() async {
    final file = await CBottomImagePicker.show();
    if (file != null) {
      logo = FichierLocal.fromFile(file);
      update();
    }
  }
}
