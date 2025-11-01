import 'dart:io';

import 'package:app_couture/api/client_api.dart';
import 'package:app_couture/data/models/client.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/material.dart';

class EditionClientPage extends EditionViewController<Client, ClientApi> {
  final nomCtl = TextEditingController();
  final prenomCtl = TextEditingController();
  final telCtl = TextEditingController();
  List typeClient = [];
  File? photo;

  EditionClientPage(super.item) : super(api: ClientApi());

  @override
  Future<Client?> onCreate() async {
    final client = Client(
      nom: nomCtl.text,
      prenom: prenomCtl.text,
      tel: telCtl.text,
      typeClient: typeClient,
    );
    final res = await api.create(client);
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
    typeClient = item.typeClient;
  }

  @override
  Future<Client?> onUpdate(Client item) async {
    item.nom = nomCtl.text;
    item.prenom = prenomCtl.text;
    item.tel = telCtl.text;
    item.typeClient = typeClient;
    item.photo = item.photo;
    final res = await api.update(item);
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }
}
