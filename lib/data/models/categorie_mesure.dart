import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class CategorieMesure extends ModelJson {
  String? libelle;

  CategorieMesure({super.id, this.libelle});

  CategorieMesure.fromJson(Json json) {
    id = json["id"] ?? json["idCategorie"];
    libelle = json["libelle"] ?? json["libelleCategorie"];
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
    };
  }
}
