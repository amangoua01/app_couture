import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Boutique extends EntiteEntreprise {
  String? situation;
  String? contact;
  Fichier? logo;

  Boutique({
    super.id,
    super.libelle,
    this.situation,
    this.contact,
    this.logo,
  });

  Boutique.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    situation = json['situation'];
    contact = json['contact'];
    if (json['logo'] != null) {
      logo = FichierServer.fromJson(json['logo']);
    }
  }

  @override
  fromJson(Json json) => Boutique.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['contact'] = contact;
    data['situation'] = situation;
    data['logo'] =
        (logo is FichierServer) ? (logo as FichierServer).toJson() : null;
    return data;
  }

  @override
  EntiteEntrepriseType get type => EntiteEntrepriseType.boutique;
}
