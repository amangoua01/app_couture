import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

class Entreprise extends Model {
  String? libelle;
  String? numero;
  String? logo;
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
    fromJson(json);
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
  fromJson(Json json) {
    id = json['id'];
    libelle = json['libelle'];
    numero = json['numero'];
    logo = json['logo'];
    email = json['email'];
    createdAt = json['createdAt'];
  }
}
