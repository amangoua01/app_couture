import 'package:ateliya/data/dto/abstract/dto_model.dart';
import 'package:ateliya/data/dto/ligne_mouvement_stock_dto.dart';

class MouvementStockDto extends DtoModel {
  int boutiqueId;
  String? commentaire;
  List<LigneMouvementStockDto> lignes;

  MouvementStockDto({
    required this.boutiqueId,
    this.commentaire,
    required this.lignes,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['boutiqueId'] = boutiqueId;
    data['commentaire'] = commentaire;
    data['lignes'] = lignes.map((e) => e.toJson()).toList();
    return data;
  }
}
