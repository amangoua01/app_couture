import 'package:ateliya/data/dto/abstract/dto_model.dart';
import 'package:ateliya/data/dto/ligne_mouvement_stock_dto.dart';

class TransfertStockDto extends DtoModel {
  int boutiqueEmetteurId;
  int boutiqueReceptriceId;
  List<LigneMouvementStockDto> lignes;

  TransfertStockDto({
    required this.boutiqueEmetteurId,
    required this.boutiqueReceptriceId,
    required this.lignes,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['boutiqueEmetteurId'] = boutiqueEmetteurId;
    data['boutiqueReceptriceId'] = boutiqueReceptriceId;
    data['lignes'] = lignes.map((e) => e.toJson()).toList();
    return data;
  }
}
