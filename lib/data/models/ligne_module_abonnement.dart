class LigneModuleAbonnement {
  int? id;
  String? libelle;
  String? description;
  String? quantite;

  LigneModuleAbonnement({
    this.id,
    this.libelle,
    this.description,
    this.quantite,
  });

  LigneModuleAbonnement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    description = json['description'];
    quantite = json['quantite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['description'] = description;
    data['quantite'] = quantite;
    return data;
  }
}
