import 'package:ateliya/data/models/fichier_server.dart';

class Operateur {
  int? id;
  String? code;
  String? libelle;
  FichierServer? photo;
  String? createdAt;
  bool? isActive;

  Operateur(
      {this.id,
      this.code,
      this.libelle,
      this.photo,
      this.createdAt,
      this.isActive});

  Operateur.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    libelle = json['libelle'];
    photo =
        json['photo'] != null ? FichierServer.fromJson(json['photo']) : null;
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['libelle'] = libelle;
    if (photo != null) {
      data['photo'] = photo!.toJson();
    }
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }
}
