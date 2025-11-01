import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/tools/extensions/types/map.dart';
import 'package:app_couture/tools/extensions/types/string.dart';

class Client extends Model {
  String? nom;
  String? prenom;
  String? tel;
  List typeClient = [];
  String? photo;
  Client(
      {this.nom,
      this.prenom,
      this.tel,
      this.typeClient = const [],
      this.photo});

  Client.fromJson(Json json) {
    nom = json["nom"];
    prenom = json["prenom"];
    tel = json["tel"];
    typeClient = json["typeClient"];
    photo = json["photo"];
  }

  @override
  fromJson(Json json) {
    return Client.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "nom": nom,
      "prenom": prenom,
      "tel": tel,
      "typeClient": typeClient,
      "photo": photo,
    };
  }

  String get fullName => "${nom.value} ${prenom.value}".trim();
}
