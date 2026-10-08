import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class ComparaisonEntite extends ModelJson {
  @override
  int? id;
  String? nom;
  String? type;
  int chiffreAffaires = 0;
  int totalDepenses = 0;

  ComparaisonEntite({
    this.id,
    this.nom,
    this.type,
    this.chiffreAffaires = 0,
    this.totalDepenses = 0,
  });

  bool get isBoutique => type == 'boutique';

  @override
  ComparaisonEntite fromJson(Json json) {
    return ComparaisonEntite.fromJson(json);
  }

  ComparaisonEntite.fromJson(Json json) {
    id = json['id'];
    nom = json['nom'];
    type = json['type'];
    chiffreAffaires = json['chiffreAffaires'] ?? 0;
    totalDepenses = json['totalDepenses'] ?? 0;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['type'] = type;
    data['chiffreAffaires'] = chiffreAffaires;
    data['totalDepenses'] = totalDepenses;
    return data;
  }
}
