import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/entreprise.dart';
import 'package:ateliya/data/models/ligne_module_abonnement.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Abonnement extends ModelJson<Abonnement> {
  String? etat;
  Entreprise? entreprise;
  String? dateFin;
  String? type;
  String? dateDebut;
  bool? isActive;
  List<LigneModuleAbonnement> modules = [];
  String? montant;
  String? description;

  Abonnement({
    super.id,
    this.etat,
    this.entreprise,
    this.dateFin,
    this.type,
    this.dateDebut,
    this.isActive,
    this.modules = const [],
    this.montant,
    this.description,
  });

  Abonnement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    etat = json['etat'];
    entreprise = json['entreprise'] != null
        ? Entreprise.fromJson(json['entreprise'])
        : null;
    dateFin = json['dateFin'];
    type = json['type'];
    dateDebut = json['dateDebut'];
    isActive = json['isActive'];
    modules = json["moduleAbonnement"]['ligneModules'] != null
        ? List<LigneModuleAbonnement>.from(json["moduleAbonnement"]
                ['ligneModules']
            .map((x) => LigneModuleAbonnement.fromJson(x)))
        : [];
    montant = json["moduleAbonnement"]['montant'];
    description = json["moduleAbonnement"]['description'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['etat'] = etat;
    if (entreprise != null) {
      data['entreprise'] = entreprise!.toJson();
    }
    data['dateFin'] = dateFin;
    data['type'] = type;
    data['createdAt'] = dateDebut;
    data['isActive'] = isActive;
    data['ligneModules'] = modules.map((x) => x.toJson()).toList();
    data['montant'] = montant;
    data['description'] = description;
    return data;
  }

  @override
  Abonnement fromJson(Json json) {
    return Abonnement.fromJson(json);
  }
}
