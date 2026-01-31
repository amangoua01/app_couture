import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/paiement_boutique_lignes.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class PaiementBoutique extends ModelJson {
  int? quantite;
  Client? client;
  String? createdAt;
  bool? isActive;
  double? montant;
  String? reference;
  List<PaiementBoutiqueLignes> lignes = [];

  PaiementBoutique({
    this.quantite,
    this.client,
    this.createdAt,
    this.isActive,
    this.montant,
    this.reference,
    this.lignes = const [],
  });

  @override
  PaiementBoutique fromJson(Json json) {
    return PaiementBoutique.fromJson(json);
  }

  PaiementBoutique.fromJson(Json json) {
    id = json['id'];
    quantite = json['quantite'];
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
    createdAt = json['createdAt'];
    isActive = json['isActive'];
    montant =
        (json['montant'] ?? json['montantTotal']).toString().toDouble().value;
    reference = json['reference'];
    if (json['paiementBoutiqueLignes'] != null) {
      lignes = (json['paiementBoutiqueLignes'] as List)
          .map((e) => PaiementBoutiqueLignes.fromJson(e))
          .toList();
    } else if (json['lignes'] != null) {
      lignes = (json['lignes'] as List)
          .map((e) => PaiementBoutiqueLignes.fromJson(e))
          .toList();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantite'] = quantite;
    data['client'] = client?.id;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    data['montant'] = montant;
    data['reference'] = reference;
    return data;
  }
}
