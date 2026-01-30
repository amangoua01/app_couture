import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/ligne_module.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class Abonnement extends ModelJson {
  bool etat = false;
  String? description;
  double montant = 0;
  int duree = 0;
  List<LigneModule> ligneModules = [];
  String? code;
  int numero = 0;
  DateTime? createdAt;
  bool isActive = true;

  Abonnement({
    super.id,
    this.etat = false,
    this.description,
    this.montant = 0,
    this.duree = 0,
    this.ligneModules = const [],
    this.code,
    this.numero = 0,
    this.createdAt,
    this.isActive = true,
  });

  Abonnement.fromJson(Json json) {
    id = json["id"];
    etat = json["etat"] ?? false;
    description = json["description"];
    montant = json["montant"].toString().toDouble().value;
    duree = json["duree"].toString().toInt() ?? 0;
    if (json["ligneModules"] != null) {
      ligneModules = (json["ligneModules"] as List)
          .map((e) => LigneModule.fromJson(e))
          .toList();
    }
    code = json["code"];
    numero = json["numero"] ?? 0;
    createdAt = json["createdAt"].toString().toDateTime();
    isActive = json["isActive"] ?? false;
  }

  @override
  Abonnement fromJson(Json json) => Abonnement.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "etat": etat,
        "description": description,
        "montant": montant,
        "duree": duree,
        "ligneModules": ligneModules.map((e) => e.toJson()).toList(),
        "code": code,
        "numero": numero,
        "createdAt": createdAt?.toIso8601String(),
        "isActive": isActive,
      };

  List<LigneModule> get modules => ligneModules;
  DateTime? get dateDebut => createdAt;
  DateTime? get dateFin =>
      createdAt?.add(Duration(days: duree)); // Duree en mois ou jours?
  String? get type => code;

  // Assuming duree is in months for now based on context, or just days.
  // If it's just meant to fix the linter error without logic:
  // DateTime? get dateFin => null;
}
