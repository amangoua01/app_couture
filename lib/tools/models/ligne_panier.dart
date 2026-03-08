import 'package:ateliya/data/models/modele_boutique.dart';

class LignePanier {
  final ModeleBoutique modele;
  int quantite;
  double prixUnitaire;

  LignePanier({
    required this.modele,
    required this.quantite,
    required this.prixUnitaire,
  });

  double get total => quantite * prixUnitaire;
}
