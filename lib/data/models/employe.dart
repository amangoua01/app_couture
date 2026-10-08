import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Employe extends ModelJson<Employe> {
  String? nom;
  String? prenoms;
  String? telephone;
  String? poste;
  String? tarifPiece;
  int? succursaleId;
  String? nomComplet;

  Employe({
    super.id,
    this.nom,
    this.prenoms,
    this.telephone,
    this.poste,
    this.tarifPiece,
    this.succursaleId,
    this.nomComplet,
  });

  @override
  Employe fromJson(Json json) => Employe.fromJson(json);

  Employe.fromJson(Json json) {
    id = json['id'];
    nom = json['nom'];
    prenoms = json['prenoms'];
    telephone = json['telephone'];
    poste = json['poste'];
    tarifPiece = json['tarifPiece']?.toString();
    succursaleId = json['succursaleId'];
    nomComplet = json['nomComplet'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nom'] = nom;
    data['prenoms'] = prenoms;
    data['telephone'] = telephone;
    data['poste'] = poste;
    data['tarifPiece'] = tarifPiece;
    data['succursaleId'] = succursaleId;
    return data;
  }
}
