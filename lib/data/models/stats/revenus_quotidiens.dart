import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class RevenusQuotidiens extends ModelJson {
  String? jour;
  int? reservations;
  int? ventes;
  int? factures;
  num revenus = 0;
  // Dashboard fields
  num mesures = 0;
  num livraisons = 0;

  RevenusQuotidiens({
    this.jour,
    this.reservations,
    this.ventes,
    this.factures,
    this.revenus = 0,
    this.mesures = 0,
    this.livraisons = 0,
  });

  @override
  RevenusQuotidiens fromJson(Json json) {
    return RevenusQuotidiens.fromJson(json);
  }

  RevenusQuotidiens.fromJson(Json json) {
    jour = json['jour'];
    reservations = json['reservations'];
    ventes = json['ventes'];
    factures = json['factures'];
    revenus = json['revenus'] ?? 0;
    mesures = json['mesures'] ?? 0;
    livraisons = json['livraisons'] ?? 0;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jour'] = jour;
    data['reservations'] = reservations;
    data['ventes'] = ventes;
    data['factures'] = factures;
    data['revenus'] = revenus;
    data['mesures'] = mesures;
    data['livraisons'] = livraisons;
    return data;
  }
}
