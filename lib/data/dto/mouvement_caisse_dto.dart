import 'package:ateliya/data/dto/abstract/dto_model.dart';
import 'package:ateliya/data/dto/ligne_mouvement_caisse_dto.dart';
import 'package:ateliya/tools/constants/sens_mouvement_caisse_enum.dart';

class MouvementCaisseDto extends DtoModel {
  String? montant;
  String? description;
  SensMouvementCaisseEnum sens;
  String? moyenPaiement;
  List<LigneMouvementCaisseDto> lignes = const [];

  MouvementCaisseDto({
    required this.sens,
    this.montant,
    this.description,
    this.moyenPaiement,
    this.lignes = const [],
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['montant'] = montant;
    data['description'] = description;
    data['sens'] = sens.name;
    data['moyenPaiement'] = moyenPaiement;
    data['lignes'] = lignes.map((v) => v.toJson()).toList();
    return data;
  }
}
