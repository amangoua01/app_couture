import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class LigneModule extends ModelJson {
  String? libelle;
  String? description;
  int quantite = 0;
  DateTime? createdAt;
  bool isActive = true;

  LigneModule({
    super.id,
    this.libelle,
    this.description,
    this.quantite = 0,
    this.createdAt,
    this.isActive = true,
  });

  LigneModule.fromJson(Json json) {
    id = json["id"];
    libelle = json["libelle"];
    description = json["description"];
    quantite = json["quantite"].toString().toInt() ?? 0;
    createdAt = json["createdAt"].toString().toDateTime();
    isActive = json["isActive"] ?? true;
  }

  @override
  LigneModule fromJson(Json json) => LigneModule.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "description": description,
        "quantite": quantite,
        "createdAt": createdAt?.toIso8601String(),
        "isActive": isActive,
      };
}
