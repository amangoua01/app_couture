import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class HistoriqueMouvement extends ModelJson<HistoriqueMouvement> {
  int? mouvementId;
  String? date;
  String? type;
  String? statut;
  String? commentaire;
  List<LigneMouvement>? lignes;

  HistoriqueMouvement({
    this.mouvementId,
    this.date,
    this.type,
    this.statut,
    this.commentaire,
    this.lignes,
  });

  @override
  HistoriqueMouvement fromJson(Json json) => HistoriqueMouvement.fromJson(json);

  HistoriqueMouvement.fromJson(Json json) {
    mouvementId = json['mouvementId'];
    date = json['date'];
    type = json['type'];
    statut = json['statut'];
    commentaire = json['commentaire'];

    if (json['lignes'] != null) {
      lignes = <LigneMouvement>[];
      json['lignes'].forEach((v) {
        lignes!.add(LigneMouvement.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mouvementId'] = mouvementId;
    data['date'] = date;
    data['type'] = type;
    data['statut'] = statut;
    data['commentaire'] = commentaire;
    if (lignes != null) {
      data['lignes'] = lignes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LigneMouvement {
  int? modeleBoutiqueId;
  String? modeleLibelle;
  String? taille;
  int? quantiteMouvement;
  int? quantiteAvant;
  int? quantiteApres;

  LigneMouvement({
    this.modeleBoutiqueId,
    this.modeleLibelle,
    this.taille,
    this.quantiteMouvement,
    this.quantiteAvant,
    this.quantiteApres,
  });

  LigneMouvement.fromJson(Map<String, dynamic> json) {
    modeleBoutiqueId = json['modeleBoutiqueId'];
    modeleLibelle = json['modeleLibelle'];
    taille = json['taille'];
    quantiteMouvement = json['quantiteMouvement'];
    quantiteAvant = json['quantiteAvant'];
    quantiteApres = json['quantiteApres'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['modeleBoutiqueId'] = modeleBoutiqueId;
    data['modeleLibelle'] = modeleLibelle;
    data['taille'] = taille;
    data['quantiteMouvement'] = quantiteMouvement;
    data['quantiteAvant'] = quantiteAvant;
    data['quantiteApres'] = quantiteApres;
    return data;
  }
}
