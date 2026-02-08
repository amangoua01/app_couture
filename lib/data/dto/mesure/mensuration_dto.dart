import 'package:ateliya/data/dto/abstract/dto_model.dart';
import 'package:ateliya/data/models/categorie_mesure.dart';

class MensurationDto extends DtoModel {
  CategorieMesure categorieMesure;
  double valeur;
  bool isActive;

  MensurationDto({
    required this.categorieMesure,
    this.valeur = 0,
    this.isActive = true,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "categorieMesure": categorieMesure,
      "valeur": valeur,
    };
  }

  MensurationDto clone() => MensurationDto(
        categorieMesure: categorieMesure,
        valeur: valeur,
        isActive: isActive,
      );
}
