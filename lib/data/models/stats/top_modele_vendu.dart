import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class TopModeleVendu extends ModelJson {
  String? nom;
  int? ventes;
  int? revenus;

  TopModeleVendu({this.nom, this.ventes, this.revenus});

  @override
  TopModeleVendu fromJson(Json json) {
    return TopModeleVendu.fromJson(json);
  }

  TopModeleVendu.fromJson(Json json) {
    nom = json['nom'];
    ventes = json['ventes'];
    revenus = json['revenus'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nom'] = nom;
    data['ventes'] = ventes;
    data['revenus'] = revenus;
    return data;
  }
}
