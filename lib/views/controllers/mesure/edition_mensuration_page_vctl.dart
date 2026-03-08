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

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Get.back(result: mensurations);
    }
  }
}
