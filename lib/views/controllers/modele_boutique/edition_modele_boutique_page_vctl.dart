import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/api/modele_api.dart';
import 'package:ateliya/api/modele_boutique_api.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/modele.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/extensions/types/text_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/material.dart';

class EditionModeleBoutiquePageVctl
    extends EditionViewController<ModeleBoutique, ModeleBoutiqueApi> {
  final quantiteCtl = TextEditingController(text: "0");
  final tailleCtl = TextEditingController();
  final prixCtl = TextEditingController(text: "0");
  final prixMinimalCtl = TextEditingController(text: "0");
  final modeleApi = ModeleApi();
  final boutiqueApi = BoutiqueApi();
  Boutique? boutique;
  Modele? modele;
  int? pickerColor;

  EditionModeleBoutiquePageVctl(super.item) : super(api: ModeleBoutiqueApi());

  @override
  Future<ModeleBoutique?> onCreate() async {
    final data = ModeleBoutique(
      modele: modele,
      boutique: boutique,
      quantite: quantiteCtl.text.toInt().value,
      taille: tailleCtl.text,
      prix: prixCtl.text,
      prixMinimal: prixMinimalCtl.toDouble(),
      color: pickerColor,
    );
    final res = await api.create(data).load();
    if (res.status) {
      return res.data;
    } else {
      await CMessageDialog.show(message: res.message);
    }
    return null;
  }

  @override
  void onInitForm(ModeleBoutique item) {
    modele = item.modele;
    boutique = item.boutique;
    tailleCtl.text = item.taille.value;
    prixCtl.text = item.prix.toDouble().value.toString();
    prixMinimalCtl.text = item.prixMinimal?.toDouble().value.toString() ?? "0";
    pickerColor = item.color;
  }

  @override
  Future<ModeleBoutique?> onUpdate(ModeleBoutique item) async {
    item.modele = modele;
    item.boutique = boutique;
    item.prix = prixCtl.text;
    item.prixMinimal = prixMinimalCtl.toDouble();
    item.taille = tailleCtl.text;
    item.color = pickerColor;
    final res = await api.update(item).load();
    if (res.status) {
      return res.data;
    } else {
      CMessageDialog.show(message: res.message);
    }
    return null;
  }

  Future<List<Modele>> getModeles() async {
    final res = await modeleApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }

  Future<List<Boutique>> getBoutiques() async {
    final res = await boutiqueApi.list();
    if (res.status) {
      return res.data!.items;
    }
    return [];
  }
}
