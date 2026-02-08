import 'dart:io';

import 'package:ateliya/api/type_mesure_api.dart';
import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/type_mesure_dto.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/extensions/types/text_editing_controller.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionPieceCouturePageVctl extends AuthViewController {
  LigneMesureDto? ligne;
  final nomTenancierCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  TypeMesure? selectedTypeMesure;
  final montantCtl = TextEditingController();
  File? pagneImageFile;
  File? modeleImageFile;
  final remiseCtl = TextEditingController(text: "0");
  final typeMesureApi = TypeMesureApi();
  final descriptionCtl = TextEditingController();
  bool hasImagePagne = false;

  EditionPieceCouturePageVctl(this.ligne) {
    if (ligne != null) {
      nomTenancierCtl.text = ligne!.nomClient.value;
      montantCtl.setDouble = ligne!.montant;
      remiseCtl.setDouble = ligne!.remise;
      selectedTypeMesure = ligne!.typeMesureDto?.toModel();
      pagneImageFile =
          ligne!.pagneImagePath != null ? File(ligne!.pagneImagePath!) : null;
      modeleImageFile =
          ligne!.modeleImagePath != null ? File(ligne!.modeleImagePath!) : null;
    }
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      ligne ??= LigneMesureDto();

      if (ligne!.typeMesureDto == null) {
        ligne!.typeMesureDto = TypeMesureDto.fromModel(selectedTypeMesure!);
      } else {
        ligne!.typeMesureDto!.model = selectedTypeMesure!;
      }
      ligne!.nomClient = nomTenancierCtl.text;
      ligne!.montant = montantCtl.toDouble();
      ligne!.remise = remiseCtl.toDouble();
      ligne!.pagneImagePath = pagneImageFile?.path;
      ligne!.modeleImagePath = modeleImageFile?.path;
      ligne!.withOutTissu = !hasImagePagne;

      Get.back(result: ligne!);
    }
  }

  Future<List<TypeMesure>> fetchTypeMesures() async {
    final res = await typeMesureApi.list();
    if (res.status) {
      return res.data!.items.where((e) => e.categories.isNotEmpty).toList();
    }
    return [];
  }
}
