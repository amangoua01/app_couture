import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class ActivitesBoutique extends ModelJson {
  String? activite;
  int? nombre;
  int? revenus;
  int? progression;

  ActivitesBoutique({
    this.activite,
    this.nombre,
    this.revenus,
    this.progression,
  });

  @override
  ActivitesBoutique fromJson(Json json) {
    return ActivitesBoutique.fromJson(json);
  }

  ActivitesBoutique.fromJson(Json json) {
    activite = json['activite'];
    nombre = json['nombre'];
    revenus = json['revenus'];
    progression = json['progression'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activite'] = activite;
    data['nombre'] = nombre;
    data['revenus'] = revenus;
    data['progression'] = progression;
    return data;
  }
}