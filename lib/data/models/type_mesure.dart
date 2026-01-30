import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/categorie_mesure.dart';
import 'package:ateliya/data/models/entreprise.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class TypeMesure extends ModelJson {
  String? libelle;
  Entreprise? entreprise;
  List<CategorieMesure> categories = [];
  DateTime? createdAt;
  bool isActive = true;

  TypeMesure({
    super.id,
    this.libelle,
    this.entreprise,
    this.categories = const [],
    this.createdAt,
    this.isActive = true,
  });

  TypeMesure.fromJson(Json json) {
    id = json["id"];
    libelle = json["libelle"];
    entreprise = json["entreprise"] != null
        ? Entreprise.fromJson(json["entreprise"])
        : null;
    if (json["categories"] != null) {
      categories = (json["categories"] as List)
          .map((e) => CategorieMesure.fromJson(e))
          .toList();
    } else {
      categories = [];
    }
    createdAt = json["createdAt"].toString().toDateTime();
    isActive = json["isActive"] ?? true;
  }

  @override
  TypeMesure fromJson(Json json) {
    return TypeMesure.fromJson(json);
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

  String get categoriesString {
    if (categories.isEmpty) {
      return "Aucune catégorie";
    }
    return "${categories.length} catégorie(s)";
  }
}
