import 'package:ateliya/data/dto/abstract/dto_model.dart';

class LignePaiementBoutiqueDto extends DtoModel {
  double montant;
  int boutiqueModeleId;
  int quantite;
  double remise;

  LignePaiementBoutiqueDto({
    required this.montant,
    required this.boutiqueModeleId,
    required this.quantite,
    this.remise = 0,
  });

  @override
  Map<String, dynamic> toJson() => {
        "montant": montant,
        "modeleBoutiqueId": boutiqueModeleId,
        "quantite": quantite,
        "remise": remise,
      };
}
