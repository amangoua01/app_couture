import 'package:ateliya/data/models/caisse.dart';

class LigneDepenseCaisse {
  int? id;
  Caisse? caisse;
  String? montant;
  String? createdAt;
  bool? isActive;

  LigneDepenseCaisse({
    this.id,
    this.caisse,
    this.montant,
    this.createdAt,
    this.isActive,
  });

  LigneDepenseCaisse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    caisse = json['caisse'] != null ? Caisse.fromJson(json['caisse']) : null;
    montant = json['montant'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (caisse != null) {
      data['caisse'] = caisse!.toJson();
    }
    data['montant'] = montant;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }
}
