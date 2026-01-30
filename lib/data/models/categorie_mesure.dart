import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/entreprise.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class CategorieMesure extends ModelJson {
  String? libelle;
  Entreprise? entreprise;
  DateTime? createdAt;
  bool isActive = true;

  CategorieMesure({
    super.id,
    this.libelle,
    this.entreprise,
    this.createdAt,
    this.isActive = true,
  });

  CategorieMesure.fromJson(Json json) {
    id = json["id"] ?? json["idCategorie"];
    libelle = json["libelle"] ?? json["libelleCategorie"];
    if (json["entreprise"] != null) {
      entreprise = Entreprise.fromJson(json["entreprise"]);
    }
    createdAt = json["createdAt"].toString().toDateTime();
    isActive = json["isActive"] ?? true;
  }

  @override
  CategorieMesure fromJson(Json json) {
    return CategorieMesure.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "libelle": libelle,
      "entreprise": entreprise?.toJson(),
      "createdAt": createdAt?.toIso8601String(),
      "isActive": isActive,
    };
  }
}
