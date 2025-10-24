import 'package:app_couture/data/models/abstract/entite_entreprise.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

class Surcursale extends EntiteEntreprise {
  String? libelle;
  String? contact;

  Surcursale({this.libelle, this.contact});

  Surcursale.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  @override
  fromJson(Json json) {
    super.fromJson(json);
    libelle = json['libelle'];
    contact = json['contact'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['libelle'] = libelle;
    data['contact'] = contact;
    return data;
  }
}
