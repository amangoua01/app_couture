import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/data/models/abstract/model_form_data.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:http/http.dart' as http;

class Entreprise extends ModelFormData<Entreprise> {
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

  @override
  Map<String, String> toFields() {
    return {
      if (id != null) 'id': id.toString(),
      if (libelle != null) 'libelle': libelle!,
      if (numero != null) 'numero': numero!,
      if (email != null) 'email': email!,
    };
  }

  @override
  Future<List<http.MultipartFile>> toMultipartFile() async {
    List<http.MultipartFile> files = [];

    if (logo != null && logo is FichierLocal) {
      final fichierLocal = logo as FichierLocal;
      if (fichierLocal.path.isNotEmpty) {
        files.add(await http.MultipartFile.fromPath(
          'logo',
          fichierLocal.path,
        ));
      }
    }

    return files;
  }
}
