import 'package:app_couture/data/models/abstract/model_json.dart';
import 'package:app_couture/tools/constants/type_user_enum.dart';
import 'package:app_couture/tools/extensions/types/map.dart';

class TypeUser extends ModelJson<TypeUser> {
  String? libelle;
  String? code;
  String? createdAt;

  TypeUser({super.id, this.libelle, this.code, this.createdAt});

  TypeUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    code = json['code'];
    createdAt = json['createdAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['code'] = code;
    data['createdAt'] = createdAt;
    return data;
  }

  @override
  TypeUser fromJson(Json json) {
    return TypeUser.fromJson(json);
  }

  TypeUserEnum get typeEnum => TypeUserEnum.fromCode(code);
}
