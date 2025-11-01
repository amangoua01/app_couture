import 'package:app_couture/tools/constants/env.dart';
import 'package:app_couture/tools/extensions/types/string.dart';

class Fichier {
  int? id;
  String? path;
  String? alt;

  Fichier({this.id, this.path, this.alt});

  Fichier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    alt = json['alt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['path'] = path;
    data['alt'] = alt;
    return data;
  }

  String? get fullUrl {
    return Env.fullImageUrl("${path.value}/${alt.value}");
  }
}
