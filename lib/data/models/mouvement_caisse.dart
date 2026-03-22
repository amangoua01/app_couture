import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/ligne_mouvement_caisse.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class MouvementCaisse extends ModelJson<MouvementCaisse> {
  String? reference;
  String? montant;
  String? description;
  int? sens;
  String? sensLibelle;
  String? createdAt;
  List<LigneMouvementCaisse>? lignes;

  MouvementCaisse({
    super.id,
    this.reference,
    this.montant,
    this.description,
    this.sens,
    this.sensLibelle,
    this.createdAt,
    this.lignes,
  });

  @override
  MouvementCaisse fromJson(Json json) => MouvementCaisse.fromJson(json);

  MouvementCaisse.fromJson(Json json) {
    id = json['id'];
    reference = json['reference'];
    montant = json['montant'].toString();
    description = json['description'];
    sens = json['sens'];
    sensLibelle = json['sensLibelle'];
    createdAt = json['createdAt'];
    if (json['lignes'] != null) {
      lignes = <LigneMouvementCaisse>[];
      json['lignes'].forEach((v) {
        lignes!.add(LigneMouvementCaisse.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reference'] = reference;
    data['montant'] = montant;
    data['description'] = description;
    data['sens'] = sens;
    data['sensLibelle'] = sensLibelle;
    data['createdAt'] = createdAt;
    if (lignes != null) {
      data['lignes'] = lignes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
