import 'package:ateliya/data/dto/abstract/dto_model.dart';

class LignePaiementBoutiqueDto extends DtoModel {
  double montant;
  int boutiqueModeleId;
  int quantite;

  LignePaiementBoutiqueDto({
    required this.montant,
    required this.boutiqueModeleId,
    required this.quantite,
  });

  @override
  Map<String, dynamic> toJson() => {
        "montant": montant,
        "modeleBoutiqueId": boutiqueModeleId,
        "quantite": quantite,
      };
}
