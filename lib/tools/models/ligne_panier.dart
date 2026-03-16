import 'package:ateliya/data/models/modele_boutique.dart';

class LignePanier {
  final ModeleBoutique modele;
  int quantite;
  double prixUnitaire;
  double remise;

  LignePanier({
    required this.modele,
    required this.quantite,
    required this.prixUnitaire,
    this.remise = 0,
  });

  double get total => (prixUnitaire * quantite) - remise;
}
