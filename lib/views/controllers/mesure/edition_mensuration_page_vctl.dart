import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';
import 'package:ateliya/tools/utils/label_matcher.dart';
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
    // Chaque mensuration prend la valeur dictée qui lui ressemble le plus, et
    // cette valeur n'est plus réutilisable ensuite. La comparaison par simple
    // inclusion de texte, elle, ratait « longueur manche » pour « longueur de
    // manche » et, pire, affectait la première valeur venue dès qu'un libellé
    // était vide.
    final disponibles = [...extracted];
    for (final m in mensurations) {
      MensurationDto? meilleure;
      var meilleurScore = 0.0;
      for (final ext in disponibles) {
        final score = similariteLibelle(
          m.categorieMesure.libelle,
          ext.categorieMesure.libelle,
        );
        if (score > meilleurScore) {
          meilleurScore = score;
          meilleure = ext;
        }
      }
      if (meilleure != null && meilleurScore >= seuilCorrespondanceLibelle) {
        m.valeur = meilleure.valeur;
        m.isActive = true;
        disponibles.remove(meilleure);
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
