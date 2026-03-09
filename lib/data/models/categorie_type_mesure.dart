import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/categorie_mesure.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class CategorieTypeMesure extends ModelJson<CategorieTypeMesure> {
  CategorieMesure? categorieMesure;
  String? createdAt;
  TypeMesure? typeMesure;
  int ordre = 0;

  CategorieTypeMesure({
    super.id,
    this.categorieMesure,
    this.createdAt,
    this.typeMesure,
    this.ordre = 0,
  });

  CategorieTypeMesure.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categorieMesure = json['categorieMesure'] != null
        ? CategorieMesure.fromJson(json['categorieMesure'])
        : null;
    createdAt = json['createdAt'];
    ordre = json['ordre'] ?? 0;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categorieMesure'] = categorieMesure!.id;
    data['createdAt'] = createdAt;
    data["ordre"] = ordre;
    return data;
  }

  @override
  CategorieTypeMesure fromJson(Json json) {
    return CategorieTypeMesure.fromJson(json);
  }
}
