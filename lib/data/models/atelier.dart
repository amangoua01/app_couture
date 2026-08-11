import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Atelier extends EntiteEntreprise {
  String? contact;

  Atelier({super.id, super.libelle, this.contact});

  Atelier.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    contact = json['contact'];
  }

  @override
  Atelier fromJson(Json json) {
    return Atelier.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['contact'] = contact;
    return data;
  }

  @override
  EntiteEntrepriseType get type => EntiteEntrepriseType.succursale;
}
