import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/mensuration.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class LigneMesure extends ModelJson {
  String? nom;
  double montant = 0;
  double remise = 0;
  String? etat;
  List<Mensuration> mensurations = [];
  TypeMesure? typeMesure;
  Fichier? photoModele;
  Fichier? photoPagne;
  DateTime? createdAt;
  bool isActive = true;

  LigneMesure({
    super.id,
    this.nom,
    this.montant = 0,
    this.remise = 0,
    this.etat,
    this.mensurations = const [],
    this.typeMesure,
    this.photoModele,
    this.photoPagne,
    this.createdAt,
    this.isActive = true,
  });

  LigneMesure.fromJson(Json json) {
    id = json["id"];
    nom = json["nom"];
    montant = json["montant"].toString().toDouble().value;
    remise = json["remise"].toString().toDouble().value;
    etat = json["etat"];
    if (json["ligneMesures"] != null) {
      mensurations = (json["ligneMesures"] as List)
          .map((e) => Mensuration.fromJson(e))
          .toList();
    }
    if (json["typeMesure"] != null) {
      typeMesure = TypeMesure.fromJson(json["typeMesure"]);
    }

    if (json["photoModele"] != null) {
      if (json["photoModele"] is Map) {
        photoModele = FichierServer.fromJson(json["photoModele"]);
      } else if (json["photoModele"] is String) {
        photoModele = FichierLocal(path: json["photoModele"]);
      }
    }

    if (json["photoPagne"] != null) {
      if (json["photoPagne"] is Map) {
        photoPagne = FichierServer.fromJson(json["photoPagne"]);
      } else if (json["photoPagne"] is String) {
        photoPagne = FichierLocal(path: json["photoPagne"]);
      }
    }

    createdAt = json["createdAt"].toString().toDateTime();
    isActive = json["isActive"] ?? true;
  }

  @override
  LigneMesure fromJson(Json json) => LigneMesure.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "montant": montant,
        "remise": remise,
        "etat": etat,
        "ligneMesures": mensurations.map((e) => e.toJson()).toList(),
        "typeMesure": typeMesure?.toJson(),
        "photoModele": photoModele,
        "photoPagne": photoPagne,
        "createdAt": createdAt?.toIso8601String(),
        "isActive": isActive,
      };

  double get total => montant - remise;
}
