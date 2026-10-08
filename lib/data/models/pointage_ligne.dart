import 'package:ateliya/tools/extensions/types/map.dart';

class PointageLigne {
  int? typeMesureId;
  String? typeMesureLibelle;
  int quantite;

  PointageLigne({this.typeMesureId, this.typeMesureLibelle, this.quantite = 0});

  PointageLigne.fromJson(Json json)
    : typeMesureId = json['typeMesureId'],
      typeMesureLibelle = json['typeMesureLibelle'],
      quantite = json['quantite'] ?? 0;

  Map<String, dynamic> toJson() => {
    'typeMesureId': typeMesureId,
    'quantite': quantite,
  };
}
