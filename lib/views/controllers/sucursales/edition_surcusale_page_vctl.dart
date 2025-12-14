import 'package:ateliya/api/succursale_api.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/cupertino.dart';

class EditionSurcusalePageVctl
    extends EditionViewController<Succursale, SuccursaleApi> {
  final libelleCtl = TextEditingController();
  final contactCtl = TextEditingController();

  EditionSurcusalePageVctl(super.item) : super(api: SuccursaleApi());

  @override
  void onClose() {
    libelleCtl.dispose();
    contactCtl.dispose();
    super.onClose();
  }

  @override
  Future<Succursale?> onCreate() async {
    final succ = Succursale(
      libelle: libelleCtl.text,
      contact: contactCtl.text,
    );
    final res = await api.create(succ).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }

  @override
  void onInitForm(Succursale item) {
    libelleCtl.text = item.libelle.value;
    contactCtl.text = item.contact.value;
  }

  @override
  Future<Succursale?> onUpdate(Succursale item) async {
    item.libelle = libelleCtl.text;
    item.contact = contactCtl.text;
    final res = await api.update(item).load();
    if (res.status) {
      return res.data;
    } else {
      CAlertDialog.show(message: res.message);
    }
    return null;
  }
}
