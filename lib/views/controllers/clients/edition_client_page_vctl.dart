import 'package:app_couture/api/boutique_api.dart';
import 'package:app_couture/api/client_api.dart';
import 'package:app_couture/api/succursale_api.dart';
import 'package:app_couture/data/models/abstract/fichier.dart';
import 'package:app_couture/data/models/boutique.dart';
import 'package:app_couture/data/models/client.dart';
import 'package:app_couture/data/models/fichier_local.dart';
import 'package:app_couture/data/models/succursale.dart';
import 'package:app_couture/tools/extensions/future.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/inputs/c_bottom_image_picker.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/material.dart';

class EditionClientPageVctl extends EditionViewController<Client, ClientApi> {
  final nomCtl = TextEditingController();
  final prenomCtl = TextEditingController();
  final telCtl = TextEditingController();
  Boutique? boutique;
  Succursale? succursale;
  Fichier? photo;
  final boutiqueApi = BoutiqueApi();
  final succursaleApi = SuccursaleApi();

  EditionClientPageVctl(super.item) : super(api: ClientApi());

  @override
  Future<Client?> onCreate() async {
    final client = Client(
      nom: nomCtl.text,
      prenom: prenomCtl.text,
      tel: telCtl.text,
      boutique: boutique,
      succursale: succursale,
      photo: photo,
    );
    final res = await api.create(client).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }

  @override
  void onInitForm(Client item) {
    nomCtl.text = item.nom.value;
    prenomCtl.text = item.prenom.value;
    telCtl.text = item.tel.value;
    boutique = item.boutique;
    succursale = item.succursale;
    photo = item.photo;
  }

  @override
  void onInitCreation() {
    if (!user.isAdmin) {
      boutique = user.boutique;
      succursale = user.succursale;
    }
  }

  @override
  Future<Client?> onUpdate(Client item) async {
    item.nom = nomCtl.text;
    item.prenom = prenomCtl.text;
    item.tel = telCtl.text;
    if (photo is FichierLocal) {
      item.photo = photo;
    }
    item.boutique = boutique;
    item.succursale = succursale;
    final res = await api.update(item).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }

  Future<List<Boutique>> fetchBoutiques() async {
    final res = await boutiqueApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }

  Future<List<Succursale>> fetchSuccursales() async {
    final res = await succursaleApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }

  @override
  Future<void> submit() {
    if (boutique != null || succursale != null) {
      return super.submit();
    } else {
      return CAlertDialog.show(
        message: "Veuillez sélectionner une boutique et/ou une succursale",
      );
    }
  }

  Future<void> pickPhoto() async {
    final file = await CBottomImagePicker.show();
    if (file != null) {
      photo = FichierLocal.fromFile(file);
      update();
    }
  }
}
