import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/paiement_boutique_lignes.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class Vente extends ModelJson<Vente> {
  Boutique? boutique;
  int? quantite;
  Client? client;
  List<PaiementBoutiqueLignes> paiementBoutiqueLignes = [];

  double? montant;
  String? reference;
  String? type;
  String? createdAt;

  Vente(
      {this.boutique,
      this.quantite,
      this.client,
      this.paiementBoutiqueLignes = const [],
      super.id,
      this.montant,
      this.reference,
      this.type,
      this.createdAt});

  Vente.fromJson(Map<String, dynamic> json) {
    boutique =
        json['boutique'] != null ? Boutique.fromJson(json['boutique']) : null;
    quantite = json['quantite'];
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
    if (json['paiementBoutiqueLignes'] is List) {
      paiementBoutiqueLignes = (json['paiementBoutiqueLignes'] as List)
          .map((e) => PaiementBoutiqueLignes.fromJson(e))
          .toList();
    }
    id = json['id'];
    montant = json['montant'].toString().toDouble().value;
    reference = json['reference'];
    type = json['type'];
    createdAt = json['createdAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (boutique != null) {
      data['boutique'] = boutique!.toJson();
    }
    data['quantite'] = quantite;
    if (client != null) {
      data['client'] = client!.toJson();
    }
    data['paiementBoutiqueLignes'] =
        paiementBoutiqueLignes.map((v) => v.toJson()).toList();
    data['id'] = id;
    data['montant'] = montant;
    data['reference'] = reference;
    data['type'] = type;
    data['createdAt'] = createdAt;
    return data;
  }

  @override
  Vente fromJson(Json json) => Vente.fromJson(json);
}
