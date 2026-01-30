import 'package:ateliya/data/dto/abstract/dto_model.dart';
import 'package:ateliya/data/dto/paiement_boutique/ligne_paiement_boutique_dto.dart';

class PaiementBoutiqueDto extends DtoModel {
  final DateTime datePaiment;
  final int clientId, boutiqueId;
  final List<LignePaiementBoutiqueDto> lignes;
  final String moyenPaiement;

  PaiementBoutiqueDto({
    required this.datePaiment,
    required this.clientId,
    required this.lignes,
    required this.boutiqueId,
    this.moyenPaiement = "Espèces",
  });

  @override
  Map<String, dynamic> toJson() => {
        'datePaiment': datePaiment.toIso8601String(),
        'clientId': clientId,
        'lignes': lignes.map((e) => e.toJson()).toList(),
        'moyenPaiement': moyenPaiement,
      };
}
