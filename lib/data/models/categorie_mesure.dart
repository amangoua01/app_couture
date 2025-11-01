import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

class CategorieMesure extends Model {
  String? libelle;

  CategorieMesure({super.id, this.libelle});

  CategorieMesure.fromJson(Json json) {
    id = json["id"];
    libelle = json["libelle"];
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
