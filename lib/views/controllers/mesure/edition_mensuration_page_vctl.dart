import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditionMensurationPageVctl extends GetxController {
  LigneMesureDto ligne;
  final formKey = GlobalKey<FormState>();
  List<MensurationDto> mensurations = const [];

  EditionMensurationPageVctl(this.ligne) {
    mensurations = ligne.typeMesureDto!.mensurations
        .map(
          (e) => e.clone(),
        )
        .toList();

    mensurations.sort(
      (a, b) => a.categorieMesure.ordre.compareTo(
        b.categorieMesure.ordre,
      ),
    );
  }

  void updateMensurations(List<MensurationDto> extracted) {
    for (var m in mensurations) {
      final key = m.categorieMesure.libelle?.toLowerCase().trim() ?? '';
      for (var ext in extracted) {
        final extKey = (ext.categorieMesure.libelle)?.toLowerCase().trim() ?? '';
        if (extKey.contains(key) || key.contains(extKey)) {
          m.valeur = ext.valeur;
          m.isActive = true;
          break;
        }
      }
    }
    update();
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Get.back(result: mensurations);
    }
  }
}
