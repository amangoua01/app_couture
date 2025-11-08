import 'package:app_couture/data/models/abstract/model_json.dart';
import 'package:app_couture/data/models/categorie_mesure.dart';
import 'package:app_couture/data/models/entreprise.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

class TypeMesure extends ModelJson {
  String? libelle;
  Entreprise? entreprise;
  List<CategorieMesure> categories = [];

  TypeMesure({
    super.id,
    this.libelle,
    this.entreprise,
    this.categories = const [],
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
      "entreprise": entreprise?.id,
    };
  }

  String get categoriesString {
    if (categories.isEmpty) {
      return "Aucune catégorie";
    }
    return "${categories.length} catégorie(s)";
  }
}
