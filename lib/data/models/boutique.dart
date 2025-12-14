import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Boutique extends EntiteEntreprise {
  String? situation;
  String? contact;

  Boutique({super.id, super.libelle, this.situation, this.contact});

  Boutique.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    situation = json['situation'];
    contact = json['contact'];
  }

  @override
  fromJson(Json json) => Boutique.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['contact'] = contact;
    data['situation'] = situation;
    return data;
  }
}
