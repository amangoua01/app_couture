import 'dart:math';

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
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/material.dart';

class EditionModeleBoutiquePageVctl
    extends EditionViewController<ModeleBoutique, ModeleBoutiqueApi> {
  final quantiteCtl = TextEditingController(text: "0");
  final tailleCtl = TextEditingController();
  final prixCtl = TextEditingController(text: "0");
  final prixMinimalCtl = TextEditingController(text: "0");
  final codeBarreCtl = TextEditingController();
  final modeleApi = ModeleApi();
  final boutiqueApi = BoutiqueApi();
  Boutique? boutique;
  Modele? modele;
  int? pickerColor;
  bool haveCommission = false;
  final prixMaxCtl = TextEditingController(text: "0");

  EditionModeleBoutiquePageVctl(super.item) : super(api: ModeleBoutiqueApi());

  void generateRandomBarcode() {
    final random = Random();
    String code = "200";
    for (int i = 0; i < 9; i++) {
      code += random.nextInt(10).toString();
    }
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int digit = int.parse(code[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }
    int checksum = (10 - (sum % 10)) % 10;
    codeBarreCtl.text = "$code$checksum";
    update();
  }

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
      haveCommission: haveCommission,
      prixMax: (haveCommission ? prixMaxCtl : prixMinimalCtl).toDouble(),
      codeBarre:
          codeBarreCtl.text.trim().isEmpty ? null : codeBarreCtl.text.trim(),
    );
    final res = await api.create(data).load();
    if (res.status) {
      CSnackbar.show(
        message: "Enregistré avec succès",
        isSuccess: true,
      );
      return res.data;
    } else {
      CSnackbar.show(message: "Une erreur est survenue", isSuccess: false);
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
    haveCommission = item.haveCommission ?? false;
    prixMaxCtl.text = item.prixMax.value.toString();
    codeBarreCtl.text = item.codeBarre ?? "";
  }

  @override
  Future<ModeleBoutique?> onUpdate(ModeleBoutique item) async {
    item.modele = modele;
    item.boutique = boutique;
    item.prix = prixCtl.text;
    item.prixMinimal = prixMinimalCtl.toDouble();
    item.taille = tailleCtl.text;
    item.color = pickerColor;
    item.haveCommission = haveCommission;
    item.prixMax = prixMaxCtl.toDouble();
    item.codeBarre =
        codeBarreCtl.text.trim().isEmpty ? null : codeBarreCtl.text.trim();
    final res = await api.update(item).load();
    if (res.status) {
      CSnackbar.show(
        message: "Enregistré avec succès",
        isSuccess: true,
      );
      return res.data;
    } else {
      CSnackbar.show(
        message: "Une erreur est survenue",
        isSuccess: false,
      );
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
