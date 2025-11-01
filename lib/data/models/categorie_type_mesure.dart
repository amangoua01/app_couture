import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/data/models/categorie_mesure.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

class CategorieTypeMesure extends Model<CategorieTypeMesure> {
  CategorieMesure? categorieMesure;
  String? createdAt;

  CategorieTypeMesure({super.id, this.categorieMesure, this.createdAt});

  CategorieTypeMesure.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categorieMesure = json['categorieMesure'] != null
        ? CategorieMesure.fromJson(json['categorieMesure'])
        : null;
    createdAt = json['createdAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categorieMesure'] = categorieMesure!.id;
    data['createdAt'] = createdAt;
    return data;
  }

  @override
  CategorieTypeMesure fromJson(Json json) {
    return CategorieTypeMesure.fromJson(json);
  }
}
