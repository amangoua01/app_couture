import 'package:ateliya/data/dto/ligne_depense_dto.dart';

class DepenseDto {
  String? montant;
  String? description;
  int? familleDepenseId;
  int? chargeId;
  List<LignesDepenseDto>? lignes;

  DepenseDto({
    this.montant,
    this.description,
    this.familleDepenseId,
    this.chargeId,
    this.lignes,
  });

  DepenseDto.fromJson(Map<String, dynamic> json) {
    montant = json['montant'];
    description = json['description'];
    familleDepenseId = json['famille_depense_id'];
    chargeId = json['charge_id'];
    if (json['lignes'] != null) {
      lignes = <LignesDepenseDto>[];
      json['lignes'].forEach((v) {
        lignes!.add(LignesDepenseDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['montant'] = montant;
    data['description'] = description;
    data['famille_depense_id'] = familleDepenseId;
    data['charge_id'] = chargeId;
    if (lignes != null) {
      data['lignes'] = lignes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
