import 'package:ateliya/data/models/abstract/model.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/data/models/ligne_depense_caisse.dart';

class Depense extends Model<Depense> {
  List<LigneDepenseCaisse>? depenseCaisses;
  String? description;
  FamilleDepense? familleDepense;
  String? montant;
  String? reference;
  String? type;
  String? moyenPaiement;
  String? createdAt;
  bool? isActive;

  Depense({
    this.depenseCaisses,
    this.description,
    this.familleDepense,
    super.id,
    this.montant,
    this.reference,
    this.type,
    this.moyenPaiement,
    this.createdAt,
    this.isActive,
  });

  Depense.fromJson(Map<String, dynamic> json) {
    if (json['depenseCaisses'] != null) {
      depenseCaisses = <LigneDepenseCaisse>[];
      json['depenseCaisses'].forEach((v) {
        depenseCaisses!.add(LigneDepenseCaisse.fromJson(v));
      });
    }
    description = json['description'];
    familleDepense = json['familleDepense'] != null
        ? FamilleDepense.fromJson(json['familleDepense'])
        : null;
    id = json['id'];
    montant = json['montant'];
    reference = json['reference'];
    type = json['type'];
    moyenPaiement = json['moyenPaiement'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }
  @override
  Depense fromJson(Map<String, dynamic> json) => Depense.fromJson(json);
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (depenseCaisses != null) {
      data['depenseCaisses'] = depenseCaisses!.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    if (familleDepense != null) {
      data['familleDepense'] = familleDepense!.toJson();
    }
    data['id'] = id;
    data['montant'] = montant;
    data['reference'] = reference;
    data['type'] = type;
    data['moyenPaiement'] = moyenPaiement;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }
}
