import 'package:ateliya/api/employe_api.dart';
import 'package:ateliya/api/succursale_api.dart';
import 'package:ateliya/data/models/atelier.dart';
import 'package:ateliya/data/models/employe.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionOuvrierPageVctl extends EditionViewController<Employe, EmployeApi> {
  final nomCtl = TextEditingController();
  final prenomsCtl = TextEditingController();
  final telephoneCtl = TextEditingController();
  final posteCtl = TextEditingController();
  final tarifPieceCtl = TextEditingController();
  final _atelierApi = SuccursaleApi();
  Atelier? selectedAtelier;

  EditionOuvrierPageVctl(super.item) : super(api: EmployeApi());

  Future<List<Atelier>> getAteliers() async {
    final res = await _atelierApi.list();
    return res.status ? res.data!.items : [];
  }

  Employe _fromInputs() => Employe(
    id: item?.id,
    nom: nomCtl.text.trim(),
    prenoms: prenomsCtl.text.trim(),
    telephone: telephoneCtl.text.trim(),
    poste: posteCtl.text.trim(),
    tarifPiece: tarifPieceCtl.text.trim(),
    succursaleId: selectedAtelier?.id,
  );

  @override
  void onInitForm(Employe item) {
    nomCtl.text = item.nom ?? "";
    prenomsCtl.text = item.prenoms ?? "";
    telephoneCtl.text = item.telephone ?? "";
    posteCtl.text = item.poste ?? "";
    tarifPieceCtl.text = item.tarifPiece ?? "";
    if (item.succursaleId != null) {
      getAteliers().then((ateliers) {
        selectedAtelier = ateliers.firstWhereOrNull((a) => a.id == item.succursaleId);
        update();
      });
    }
  }

  @override
  Future<Employe?> onCreate() async {
    final res = await api.create(_fromInputs());
    if (res.status) return res.data;
    CMessageDialog.show(message: res.message);
    return null;
  }

  @override
  Future<Employe?> onUpdate(Employe item) async {
    final res = await api.update(_fromInputs());
    if (res.status) return res.data;
    CMessageDialog.show(message: res.message);
    return null;
  }
}
