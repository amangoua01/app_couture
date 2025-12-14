import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/entre_stock.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class LigneEntres extends ModelJson {
  int? quantite;
  EntreStock? entreStock;

  LigneEntres({this.quantite, this.entreStock});

  @override
  LigneEntres fromJson(Json json) {
    return LigneEntres.fromJson(json);
  }

  LigneEntres.fromJson(Json json) {
    id = json['id'];
    quantite = json['quantite'];
    entreStock = json['entreStock'] != null
        ? EntreStock.fromJson(json['entreStock'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantite'] = quantite;
    if (entreStock != null) {
      data['entreStock'] = entreStock!.toJson();
    }
    return data;
  }
}