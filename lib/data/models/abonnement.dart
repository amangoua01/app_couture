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

  // Champs de l'abonnement spécifique
  DateTime? _dateDebut;
  DateTime? _dateFin;
  String? _type;

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

    // Status can be in "etat" at top level or inside moduleAbonnement
    if (json["etat"] is String) {
      etat = json["etat"] == "actif";
    } else if (json["etat"] is bool) {
      etat = json["etat"] ?? false;
    }

    final module = json["moduleAbonnement"];
    if (module != null) {
      description = module["description"];
      montant = module["montant"].toString().toDouble().value;
      duree = module["duree"].toString().toInt() ?? 0;
      if (module["ligneModules"] != null) {
        ligneModules = (module["ligneModules"] as List)
            .map((e) => LigneModule.fromJson(e))
            .toList();
      }
      code = module["code"];
      numero = module["numero"] ?? 0;
    } else {
      // Fallback to top level if moduleAbonnement is missing
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
    }

    createdAt = json["createdAt"].toString().toDateTime();
    _dateDebut = json["dateDebut"].toString().toDateTime();
    _dateFin = json["dateFin"].toString().toDateTime();
    _type = json["type"];
    isActive = json["isActive"] ?? (json["etat"] == "actif");
  }

  @override
  Abonnement fromJson(Json json) => Abonnement.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "etat": etat ? "actif" : "inactif",
        "description": description,
        "montant": montant,
        "duree": duree,
        "ligneModules": ligneModules.map((e) => e.toJson()).toList(),
        "code": code,
        "numero": numero,
        "createdAt": createdAt?.toIso8601String(),
        "dateDebut": _dateDebut?.toIso8601String(),
        "dateFin": _dateFin?.toIso8601String(),
        "type": _type,
        "isActive": isActive,
      };

  List<LigneModule> get modules => ligneModules;
  DateTime? get dateDebut => _dateDebut ?? createdAt;
  DateTime? get dateFin => _dateFin ?? createdAt?.add(Duration(days: duree));
  String? get type => _type ?? code;
}
