import 'package:app_couture/data/models/boutique.dart';
import 'package:app_couture/data/models/succursale.dart';

class EntrepriseEntitiesResponse {
  List<Boutique> boutiques = [];
  List<Succursale> surcusales = [];

  EntrepriseEntitiesResponse();

  EntrepriseEntitiesResponse.fromJson(Map<String, dynamic> json) {
    if (json['boutiques'] is List) {
      boutiques = <Boutique>[];
      for (var v in (json['boutiques'] as List)) {
        boutiques.add(Boutique.fromJson(v));
      }
    }
    if (json['surccursales'] is List) {
      surcusales = <Succursale>[];
      for (var v in (json['surccursales'] as List)) {
        surcusales.add(Succursale.fromJson(v));
      }
    }
  }

  bool get isEmpty => boutiques.isEmpty && surcusales.isEmpty;
}
