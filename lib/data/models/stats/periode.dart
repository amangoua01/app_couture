import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Periode extends ModelJson {
  String? debut;
  String? fin;
  int? nbJours;

  Periode({this.debut, this.fin, this.nbJours});

  @override
  Periode fromJson(Json json) {
    return Periode.fromJson(json);
  }

  Periode.fromJson(Json json) {
    debut = json['debut'];
    fin = json['fin'];
    nbJours = json['nbJours'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['debut'] = debut;
    data['fin'] = fin;
    data['nbJours'] = nbJours;
    return data;
  }
}