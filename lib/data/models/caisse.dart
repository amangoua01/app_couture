import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/data/models/abstract/model.dart';

class Caisse extends Model<Caisse> {
  EntiteEntreprise? entite;
  String? montant;
  String? reference;
  String? type;
  String? createdAt;
  bool? isActive;

  Caisse({
    this.entite,
    super.id,
    this.montant,
    this.reference,
    this.type,
    this.createdAt,
    this.isActive,
  });

  Caisse.fromJson(Map<String, dynamic> json) {
    final entiteData = json['boutique'] ?? json['succursale'];
    entite = entiteData != null
        ? EntiteEntreprise.fromJsonToChild(entiteData)
        : null;
    id = json['id'];
    montant = json['montant'];
    reference = json['reference'];
    type = json['type'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  @override
  Caisse fromJson(Map<String, dynamic> json) => Caisse.fromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (entite != null) {
      data['boutique'] = entite!.toJson();
    }
    data['id'] = id;
    data['montant'] = montant;
    data['reference'] = reference;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }
}
