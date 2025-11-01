import 'package:app_couture/data/models/abstract/entite_entreprise.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

class Boutique extends EntiteEntreprise {
  String? libelle;
  String? situation;
  String? contact;

  Boutique({super.id, this.libelle, this.situation, this.contact});

  Boutique.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    libelle = json['libelle'];
    situation = json['situation'];
    contact = json['contact'];
  }

  @override
  fromJson(Json json) => Boutique.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['libelle'] = libelle;
    data['contact'] = contact;
    data['situation'] = situation;
    return data;
  }
}
