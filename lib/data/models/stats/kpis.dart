import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Kpis extends ModelJson {
  int chiffreAffaires = 0;
  int reservationsActives = 0;
  int clientsActifs = 0;
  int commandesEnCours = 0;
  int totalDepenses = 0;
  int totalMouvements = 0;
  int totalMouvementsEntrants = 0;
  int totalMouvementsSortants = 0;
  int? nombreModelesStockBas;
  int? stockTotalBoutique;
  int caisse = 0;
  int? ticketMoyen;
  int? tauxRecouvrement;
  int? nbVentesBoutique;
  int? recettesNettes;
  int? montantDuClients;
  int? revenusReservations;
  int? revenusVenteDirecte;

  // Succursale fields
  int? facturesActives;
  int? mesuresEnCours;
  int? revenusFactures;

  Kpis({
    this.chiffreAffaires = 0,
    this.reservationsActives = 0,
    this.clientsActifs = 0,
    this.commandesEnCours = 0,
    this.totalDepenses = 0,
    this.totalMouvements = 0,
    this.totalMouvementsEntrants = 0,
    this.totalMouvementsSortants = 0,
    this.nombreModelesStockBas,
    this.stockTotalBoutique,
    this.caisse = 0,
    this.ticketMoyen,
    this.tauxRecouvrement,
    this.nbVentesBoutique,
    this.recettesNettes,
    this.montantDuClients,
    this.revenusReservations,
    this.revenusVenteDirecte,
    this.facturesActives,
    this.mesuresEnCours,
    this.revenusFactures,
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
    totalMouvementsEntrants = json['totalMouvementsEntrants'] ?? 0;
    totalMouvementsSortants = json['totalMouvementsSortants'] ?? 0;
    nombreModelesStockBas = json['nombreModelesStockBas'];
    stockTotalBoutique = json['stockTotalBoutique'];
    caisse = json['caisse'] ?? 0;
    ticketMoyen = json['ticketMoyen'];
    tauxRecouvrement = json['tauxRecouvrement'];
    nbVentesBoutique = json['nbVentesBoutique'];
    recettesNettes = json['recettesNettes'];
    montantDuClients = json['montantDuClients'];
    revenusReservations = json['revenusReservations'];
    revenusVenteDirecte = json['revenusVenteDirecte'];
    facturesActives = json['facturesActives'];
    mesuresEnCours = json['mesuresEnCours'];
    revenusFactures = json['revenusFactures'];
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
    data['totalMouvementsEntrants'] = totalMouvementsEntrants;
    data['totalMouvementsSortants'] = totalMouvementsSortants;
    data['nombreModelesStockBas'] = nombreModelesStockBas;
    data['stockTotalBoutique'] = stockTotalBoutique;
    data['caisse'] = caisse;
    data['ticketMoyen'] = ticketMoyen;
    data['tauxRecouvrement'] = tauxRecouvrement;
    data['nbVentesBoutique'] = nbVentesBoutique;
    data['recettesNettes'] = recettesNettes;
    data['montantDuClients'] = montantDuClients;
    data['revenusReservations'] = revenusReservations;
    data['revenusVenteDirecte'] = revenusVenteDirecte;
    data['facturesActives'] = facturesActives;
    data['mesuresEnCours'] = mesuresEnCours;
    data['revenusFactures'] = revenusFactures;
    return data;
  }
}
