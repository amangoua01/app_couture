import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Entreprise extends ModelJson {
  String? libelle;
  String? numero;
  Fichier? logo;
  String? email;
  String? createdAt;

  Entreprise(
      {super.id,
      this.libelle,
      this.numero,
      this.logo,
      this.email,
      this.createdAt});

  Entreprise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    numero = json['numero'];
    logo = (json['logo'] != null) ? FichierServer.fromJson(json['logo']) : null;
    email = json['email'];
    createdAt = json['createdAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['numero'] = numero;
    data['logo'] = logo;
    data['email'] = email;
    data['createdAt'] = createdAt;
    return data;
  }

  @override
  Entreprise fromJson(Json json) => Entreprise.fromJson(json);
}
