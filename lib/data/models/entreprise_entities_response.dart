import 'package:ateliya/data/models/atelier.dart';
import 'package:ateliya/data/models/boutique.dart';

class EntrepriseEntitiesResponse {
  List<Boutique> boutiques = [];
  List<Atelier> ateliers = [];

  EntrepriseEntitiesResponse();

  EntrepriseEntitiesResponse.fromJson(Map<String, dynamic> json) {
    if (json['boutiques'] is List) {
      boutiques = <Boutique>[];
      for (var v in (json['boutiques'] as List)) {
        boutiques.add(Boutique.fromJson(v));
      }
    }
    if (json['surccursales'] is List) {
      ateliers = <Atelier>[];
      for (var v in (json['surccursales'] as List)) {
        ateliers.add(Atelier.fromJson(v));
      }
    }
  }

  bool get isEmpty => boutiques.isEmpty && ateliers.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
