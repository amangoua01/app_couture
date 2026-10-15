import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class ActivitesBoutique extends ModelJson {
  String? activite;
  int? nombre;
  int? revenus;
  int? progression;

  ActivitesBoutique({
    this.activite,
    this.nombre,
    this.revenus,
    this.progression,
  });

  /// Activité propre à la boutique (réservations, ventes directes).
  bool get isBoutique {
    final a = (activite ?? '').toLowerCase();
    return a.contains('réservation') ||
        a.contains('reservation') ||
        a.contains('vente');
  }

  /// Toute autre activité (factures, mesures, paiements…) relève de l'atelier.
  bool get isAtelier => !isBoutique;

  @override
  ActivitesBoutique fromJson(Json json) {
    return ActivitesBoutique.fromJson(json);
  }

  ActivitesBoutique.fromJson(Json json) {
    activite = json['activite'];
    nombre = json['nombre'];
    revenus = json['revenus'];
    progression = json['progression'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activite'] = activite;
    data['nombre'] = nombre;
    data['revenus'] = revenus;
    data['progression'] = progression;
    return data;
  }
}
