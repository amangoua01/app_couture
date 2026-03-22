import 'package:ateliya/data/dto/abstract/dto_model.dart';

class LigneMouvementStockDto extends DtoModel {
  int modeleBoutiqueId;
  int quantite;
  String? motif;

  LigneMouvementStockDto({
    required this.modeleBoutiqueId,
    required this.quantite,
    this.motif,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['modeleBoutiqueId'] = modeleBoutiqueId;
    data['quantite'] = quantite;
    data['motif'] = motif;
    return data;
  }
}
