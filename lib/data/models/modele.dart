import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/data/models/abstract/model_form_data.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:http/http.dart' as http;

class Modele extends ModelFormData<Modele> {
  String? libelle;
  int? quantite;
  int? quantiteGlobale;
  Fichier? photo;
  String? createdAt;
  bool? isActive;

  Modele({this.libelle, this.quantite, this.quantiteGlobale, this.photo, this.createdAt, this.isActive});

  Modele.fromJson(Json json) {
    id = json["id"];
    libelle = json["libelle"];
    quantite = json["quantite"];
    quantiteGlobale = json["quantiteGlobale"];
    if (json["photo"] != null) {
      photo = FichierServer.fromJson(json["photo"]);
    }
    createdAt = json["createdAt"];
    isActive = json["isActive"];
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
    if (quantiteGlobale != null) {
      map["quantiteGlobale"] = quantiteGlobale.toString();
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['quantite'] = quantite;
    data['quantiteGlobale'] = quantiteGlobale;
    if (photo != null) {
      data['photo'] = (photo as FichierServer).toJson();
    }
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }
}
