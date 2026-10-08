import 'package:ateliya/data/models/abstract/model.dart';
import 'package:ateliya/data/models/groupe_depense.dart';

class FamilleDepense extends Model<FamilleDepense> {
  String? libelle;
  GroupeDepense? groupeDepense;
  String? createdAt;
  bool? isActive;

  /// Null côté serveur = type global, visible par toutes les entreprises.
  /// Non-null = type privé créé par une entreprise (la nôtre, puisque le
  /// serveur ne nous montre jamais les types privés d'une autre).
  bool isGlobal;

  FamilleDepense({
    super.id,
    this.libelle,
    this.groupeDepense,
    this.createdAt,
    this.isActive,
    this.isGlobal = true,
  });

  FamilleDepense.fromJson(Map<String, dynamic> json)
    : isGlobal = json['entreprise'] == null {
    id = json['id'];
    libelle = json['libelle'];
    groupeDepense =
        json['groupeDepense'] != null
            ? GroupeDepense.fromJson(json['groupeDepense'])
            : null;
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  @override
  FamilleDepense fromJson(Map<String, dynamic> json) =>
      FamilleDepense.fromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    if (groupeDepense != null) {
      data['groupeDepense'] = groupeDepense!.toJson();
    }
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }
}
