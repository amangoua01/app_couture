import 'package:app_couture/data/models/boutique.dart';
import 'package:app_couture/data/models/surcusale.dart';

class EntrepriseEntitiesResponse {
  List<Boutique> boutiques = [];
  List<Surcursale> surcusales = [];

  EntrepriseEntitiesResponse();

  EntrepriseEntitiesResponse.fromJson(Map<String, dynamic> json) {
    if (json['boutiques'] is List) {
      boutiques = <Boutique>[];
      for (var v in (json['boutiques'] as List)) {
        boutiques.add(Boutique.fromJson(v));
      }
    }
    if (json['surccursales'] is List) {
      surcusales = <Surcursale>[];
      for (var v in (json['surccursales'] as List)) {
        surcusales.add(Surcursale.fromJson(v));
      }
    }
  }

  bool get isEmpty => boutiques.isEmpty && surcusales.isEmpty;
}
