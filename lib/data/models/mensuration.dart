import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/categorie_mesure.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class Mensuration extends ModelJson {
  double taille = 0;
  CategorieMesure? categorieMesure;
  DateTime? createdAt;
  bool isActive = true;

  Mensuration({
    super.id,
    this.taille = 0,
    this.categorieMesure,
    this.createdAt,
    this.isActive = true,
  });

  Mensuration.fromJson(Json json) {
    id = json["id"];
    taille = json["taille"].toString().toDouble().value;
    if (json["categorieMesure"] != null) {
      categorieMesure = CategorieMesure.fromJson(json["categorieMesure"]);
    }
    createdAt = json["createdAt"].toString().toDateTime();
    isActive = json["isActive"] ?? true;
  }

  @override
  Mensuration fromJson(Json json) => Mensuration.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "taille": taille,
        "categorieMesure": categorieMesure?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "isActive": isActive,
      };
}
