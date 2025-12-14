import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Pays extends ModelJson {
  String? libelle;
  String? code;
  String? indicatif;
  String? createdAt;

  Pays({super.id, this.libelle, this.code, this.indicatif, this.createdAt});

  Pays.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['code'] = code;
    data['indicatif'] = indicatif;
    data['createdAt'] = createdAt;
    return data;
  }

  @override
  fromJson(Json json) {
    id = json['id'];
    libelle = json['libelle'];
    code = json['code'];
    indicatif = json['indicatif'];
    createdAt = json['createdAt'];
  }
}
