import 'package:app_couture/data/models/abstract/fichier.dart';
import 'package:app_couture/data/models/abstract/model_form_data.dart';
import 'package:app_couture/data/models/fichier_local.dart';
import 'package:app_couture/data/models/fichier_server.dart';
import 'package:app_couture/tools/extensions/types/map.dart';
import 'package:http/http.dart' as http;

class Modele extends ModelFormData<Modele> {
  String? libelle;
  int? quantite;
  Fichier? photo;

  Modele({this.libelle, this.quantite, this.photo});

  Modele.fromJson(Json json) {
    id = json["id"];
    libelle = json["libelle"];
    quantite = json["quantite"];
    if (json["photo"] != null) {
      photo = FichierServer.fromJson(json["photo"]);
    }
  }
  @override
  Modele fromJson(Json json) {
    return Modele.fromJson(json);
  }

  @override
  Map<String, String> toFields() {
    final map = <String, String>{};
    if (libelle != null) {
      map["libelle"] = libelle!;
    }
    if (quantite != null) {
      map["quantite"] = quantite.toString();
    } else {
      map["quantite"] = "0";
    }
    return map;
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
