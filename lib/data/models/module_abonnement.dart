import 'package:ateliya/data/models/avantage_abn.dart';
import 'package:ateliya/data/models/ligne_module_abonnement.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class ModuleAbonnement {
  int? id;
  bool? etat;
  String? description;
  String? montant;
  String? duree;
  List<LigneModuleAbonnement> ligneModules = const [];
  String? code;
  int? numero;
  Null createdAt;
  bool? isActive;

  ModuleAbonnement(
      {this.id,
      this.etat,
      this.description,
      this.montant,
      this.duree,
      this.ligneModules = const [],
      this.code,
      this.numero,
      this.createdAt,
      this.isActive});

  ModuleAbonnement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    etat = json['etat'];
    description = json['description'];
    montant = json['montant'];
    duree = json['duree'];
    if (json['ligneModules'] != null) {
      ligneModules = <LigneModuleAbonnement>[];
      json['ligneModules'].forEach((v) {
        ligneModules.add(LigneModuleAbonnement.fromJson(v));
      });
    }
    code = json['code'];
    numero = json['numero'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['etat'] = etat;
    data['description'] = description;
    data['montant'] = montant;
    data['duree'] = duree;
    data['ligneModules'] = ligneModules.map((v) => v.toJson()).toList();
    data['code'] = code;
    data['numero'] = numero;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }

  List<AvantageAbn> get ligneModuleAvantages => ligneModules
      .map(
        (e) => AvantageAbn(
          libelle: e.libelle.value,
          description: e.description.value,
          value: e.quantite.toInt().value,
        ),
      )
      .toList();
}
