import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/tools/constants/env.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class FichierServer extends Fichier {
  int? id;
  String? path;
  String? alt;

  FichierServer({this.id, this.path, this.alt});

  FichierServer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    alt = json['alt'];
  }

  String? get fullUrl {
    return Env.fullImageUrl("${path?.value}/${alt?.value}");
  }
}
