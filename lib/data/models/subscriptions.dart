import 'package:ateliya/data/models/entreprise.dart';

class Subscriptions {
  int? id;
  String? etat;
  Entreprise? entreprise;
  String? dateFin;
  String? dateDebut;
  String? type;
  String? createdAt;
  Map<String, dynamic>? moduleAbonnement;

  Subscriptions(
      {this.id,
      this.etat,
      this.entreprise,
      this.dateFin,
      this.dateDebut,
      this.type,
      this.createdAt,
      this.moduleAbonnement});

  Subscriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    etat = json['etat'];
    entreprise = json['entreprise'] != null
        ? Entreprise.fromJson(json['entreprise'])
        : null;
    dateFin = json['dateFin'];
    dateDebut = json['dateDebut'];
    type = json['type'];
    createdAt = json['createdAt'];
    moduleAbonnement = json['moduleAbonnement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['etat'] = etat;
    if (entreprise != null) {
      data['entreprise'] = entreprise!.toJson();
    }
    data['dateFin'] = dateFin;
    data['dateDebut'] = dateDebut;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['moduleAbonnement'] = moduleAbonnement;
    return data;
  }
}
