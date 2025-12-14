import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class RevenusQuotidiens extends ModelJson {
  String? jour;
  int? reservations;
  int? ventes;
  int? factures;
  int? revenus;

  RevenusQuotidiens({
    this.jour,
    this.reservations,
    this.ventes,
    this.factures,
    this.revenus,
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
    revenus = json['revenus'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jour'] = jour;
    data['reservations'] = reservations;
    data['ventes'] = ventes;
    data['factures'] = factures;
    data['revenus'] = revenus;
    return data;
  }
}