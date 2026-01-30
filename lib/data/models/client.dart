import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/data/models/abstract/model_form_data.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:http/http.dart' as http;

class Client extends ModelFormData<Client> {
  String? nom;
  String? prenom;
  String? tel;
  Fichier? photo;
  Boutique? boutique;
  Succursale? succursale;
  DateTime? createdAt;
  bool isActive = true;

  Client(
      {this.nom,
      this.prenom,
      this.tel,
      this.boutique,
      this.succursale,
      this.photo,
      this.createdAt,
      this.isActive = true});

  Client.fromJson(Json json) {
    id = json["id"];
    nom = json["nom"];
    prenom = json["prenom"];
    tel = json["numero"];
    if (json["photo"] != null) {
      photo = FichierServer.fromJson(json["photo"]);
    }
    if (json["boutique"] != null) {
      boutique = Boutique.fromJson(json["boutique"]);
    }
    if (json["succursale"] != null) {
      succursale = Succursale.fromJson(json["succursale"]);
    }
    createdAt = json["createdAt"].toString().toDateTime();
    isActive = json["isActive"] ?? true;
  }

  @override
  Client fromJson(Json json) {
    return Client.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nom": nom,
      "prenom": prenom,
      "numero": tel,
      // Assuming photo implements toJson or check type
      "photo":
          (photo is FichierServer) ? (photo as FichierServer).toJson() : null,
      "boutique": boutique?.toJson(),
      "succursale": succursale?.toJson(),
      "createdAt": createdAt?.toIso8601String(),
      "isActive": isActive,
    };
  }

  String get fullName => "${nom.value} ${prenom.value}".trim();

  @override
  Map<String, String> toFields() {
    var fields = <String, String>{};
    fields["nom"] = nom.value;
    fields["prenoms"] = prenom.value;
    fields["numero"] = tel.value;
    if (boutique?.id != null) {
      fields["boutique"] = boutique!.id!.toString();
    } else {
      fields["boutique"] = "";
    }
    if (succursale?.id != null) {
      fields["succursale"] = succursale!.id!.toString();
    } else {
      fields["succursale"] = "";
    }
    return fields;
  }

  @override
  Future<List<http.MultipartFile>> toMultipartFile() async {
    final files = <http.MultipartFile>[];
    if (photo is FichierLocal) {
      files.add(
        await http.MultipartFile.fromPath(
          "photo",
          (photo as FichierLocal).path,
        ),
      );
    }
    return Future.value(files);
  }
}
