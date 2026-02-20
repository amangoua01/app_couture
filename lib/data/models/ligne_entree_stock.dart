import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

/// Ligne d'une entrée de stock (ravitaillement).
/// Correspond à un élément de `ligneEntres` dans la réponse GET /stock/{boutiqueId}.
class LigneEntreeStock extends ModelJson<LigneEntreeStock> {
  int? quantite;
  ModeleBoutique? modele;

  LigneEntreeStock({this.quantite, this.modele});

  @override
  LigneEntreeStock fromJson(Json json) => LigneEntreeStock.fromJson(json);

  LigneEntreeStock.fromJson(Json json) {
    id = json['id'];
    quantite = json['quantite'];
    modele =
        json['modele'] != null ? ModeleBoutique.fromJson(json['modele']) : null;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'quantite': quantite,
        'modele': modele?.toJson(),
      };
}
