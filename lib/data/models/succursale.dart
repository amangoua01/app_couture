import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Succursale extends EntiteEntreprise {
  String? contact;

  Succursale({super.id, super.libelle, this.contact});

  Succursale.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    contact = json['contact'];
  }

  @override
  Succursale fromJson(Json json) {
    return Succursale.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['contact'] = contact;
    return data;
  }
}
