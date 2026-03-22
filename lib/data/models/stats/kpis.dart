import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Kpis extends ModelJson {
  int chiffreAffaires = 0;
  int reservationsActives = 0;
  int clientsActifs = 0;
  int commandesEnCours = 0;
  int totalDepenses = 0;
  int totalMouvements = 0;
  // Dashboard fields
  int? recettesNettes;
  int? ticketMoyen;
  int? facturesActives; // Succursale
  int? mesuresEnCours; // Succursale

  Kpis({
    this.chiffreAffaires = 0,
    this.reservationsActives = 0,
    this.clientsActifs = 0,
    this.commandesEnCours = 0,
    this.totalDepenses = 0,
    this.totalMouvements = 0,
    this.recettesNettes,
    this.ticketMoyen,
    this.facturesActives,
    this.mesuresEnCours,
  });

  @override
  Kpis fromJson(Json json) {
    return Kpis.fromJson(json);
  }

  Kpis.fromJson(Json json) {
    chiffreAffaires = json['chiffreAffaires'] ?? 0;
    reservationsActives = json['reservationsActives'] ?? 0;
    clientsActifs = json['clientsActifs'] ?? 0;
    commandesEnCours = json['commandesEnCours'] ?? 0;
    totalDepenses = json['totalDepenses'] ?? 0;
    totalMouvements = json['totalMouvements'] ?? 0;
    recettesNettes = json['recettesNettes'];
    ticketMoyen = json['ticketMoyen'];
    facturesActives = json['facturesActives'];
    mesuresEnCours = json['mesuresEnCours'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chiffreAffaires'] = chiffreAffaires;
    data['reservationsActives'] = reservationsActives;
    data['clientsActifs'] = clientsActifs;
    data['commandesEnCours'] = commandesEnCours;
    data['totalDepenses'] = totalDepenses;
    data['totalMouvements'] = totalMouvements;
    data['recettesNettes'] = recettesNettes;
    data['ticketMoyen'] = ticketMoyen;
    data['facturesActives'] = facturesActives;
    data['mesuresEnCours'] = mesuresEnCours;
    return data;
  }
}
