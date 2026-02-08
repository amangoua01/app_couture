class GroupeDepense {
  int? id;
  String? libelle;
  String? createdAt;
  bool? isActive;

  GroupeDepense({this.id, this.libelle, this.createdAt, this.isActive});

  GroupeDepense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }
}
