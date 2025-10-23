import 'package:app_couture/data/models/entreprise.dart';

class Subscriptions {
  int? id;
  String? etat;
  Entreprise? entreprise;
  String? dateFin;
  String? type;
  String? createdAt;

  Subscriptions(
      {this.id,
      this.etat,
      this.entreprise,
      this.dateFin,
      this.type,
      this.createdAt});

  Subscriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    etat = json['etat'];
    entreprise = json['entreprise'] != null
        ? Entreprise.fromJson(json['entreprise'])
        : null;
    dateFin = json['dateFin'];
    type = json['type'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['etat'] = etat;
    if (entreprise != null) {
      data['entreprise'] = entreprise!.toJson();
    }
    data['dateFin'] = dateFin;
    data['type'] = type;
    data['createdAt'] = createdAt;
    return data;
  }
}
