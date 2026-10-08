import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/pointage_ligne.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Pointage extends ModelJson<Pointage> {
  int? employeId;
  String? dateJour;
  String? arrivee;
  String? depart;
  int piecesTerminees = 0;
  int piecesEnCours = 0;
  String? observation;
  int dureeMinutes = 0;
  List<PointageLigne> lignes = [];

  Pointage({
    super.id,
    this.employeId,
    this.dateJour,
    this.arrivee,
    this.depart,
    this.piecesTerminees = 0,
    this.piecesEnCours = 0,
    this.observation,
    this.dureeMinutes = 0,
    this.lignes = const [],
  });

  @override
  Pointage fromJson(Json json) => Pointage.fromJson(json);

  Pointage.fromJson(Json json) {
    id = json['id'];
    dateJour = json['dateJour'];
    arrivee = json['arrivee'];
    depart = json['depart'];
    piecesTerminees = json['piecesTerminees'] ?? 0;
    piecesEnCours = json['piecesEnCours'] ?? 0;
    observation = json['observation'];
    dureeMinutes = json['dureeMinutes'] ?? 0;
    // Le backend sérialise l'employé complet (groupe "group1"), pas juste
    // son id, pour éviter un second appel réseau côté mobile.
    if (json['employe'] is Map && json['employe']['id'] != null) {
      employeId = json['employe']['id'];
    }
    if (json['lignes'] is List) {
      lignes =
          (json['lignes'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => PointageLigne.fromJson(e))
              .toList();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeId'] = employeId;
    data['date'] = dateJour;
    data['heureArrivee'] = arrivee;
    data['heureDepart'] = depart;
    data['piecesEnCours'] = piecesEnCours;
    data['observation'] = observation;
    data['lignes'] = lignes.map((l) => l.toJson()).toList();
    return data;
  }
}
