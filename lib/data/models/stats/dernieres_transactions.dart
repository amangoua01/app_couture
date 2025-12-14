import 'package:ateliya/tools/extensions/types/map.dart';

class DernieresTransactions {
  String? id;
  String? type;
  String? client;
  int? montant;
  String? statut;

  DernieresTransactions({
    this.type,
    this.client,
    this.montant,
    this.statut,
  });

  DernieresTransactions fromJson(Json json) {
    return DernieresTransactions.fromJson(json);
  }

  DernieresTransactions.fromJson(Json json) {
    id = json['id'];
    type = json['type'];
    client = json['client'];
    montant = json['montant'];
    statut = json['statut'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['client'] = client;
    data['montant'] = montant;
    data['statut'] = statut;
    return data;
  }
}
