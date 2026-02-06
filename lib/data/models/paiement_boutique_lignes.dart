import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/paiement_boutique.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class PaiementBoutiqueLignes extends ModelJson {
  int? quantite;
  double? montant;
  PaiementBoutique? paiementBoutique;
  ModeleBoutique? modeleBoutique;

  PaiementBoutiqueLignes({
    this.quantite,
    this.montant,
    this.paiementBoutique,
    this.modeleBoutique,
  });

  @override
  PaiementBoutiqueLignes fromJson(Json json) {
    return PaiementBoutiqueLignes.fromJson(json);
  }

  PaiementBoutiqueLignes.fromJson(Json json) {
    id = json['id'];
    quantite = json['quantite'];
    montant = json['montant'].toString().toDouble().value;
    paiementBoutique = json['paiementBoutique'] != null
        ? PaiementBoutique.fromJson(json['paiementBoutique'])
        : null;
    if (json['modeleBoutique'] != null) {
      modeleBoutique = ModeleBoutique.fromJson(json['modeleBoutique']);
    } else if (json['boutiqueModele'] != null) {
      modeleBoutique = ModeleBoutique.fromJson(json['boutiqueModele']);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantite'] = quantite;
    data['montant'] = montant;
    if (paiementBoutique != null) {
      data['paiementBoutique'] = paiementBoutique!.toJson();
    }
    return data;
  }

  double get total => quantite.value * montant.value;
}
