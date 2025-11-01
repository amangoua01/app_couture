import 'package:app_couture/data/models/abstract/entite_entreprise.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

class Succursale extends EntiteEntreprise {
  String? libelle;
  String? contact;

  Succursale({super.id, this.libelle, this.contact});

  Succursale.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    libelle = json['libelle'];
    contact = json['contact'];
  }

  @override
  Succursale fromJson(Json json) {
    return Succursale.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['libelle'] = libelle;
    data['contact'] = contact;
    return data;
  }
}
