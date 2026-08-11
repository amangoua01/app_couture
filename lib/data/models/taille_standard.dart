class TailleStandard {
  int? id;
  String? libelle;
  String? description;
  String? uuid;
  String? createdAt;
  bool? isActive;

  TailleStandard({
    this.id,
    this.libelle,
    this.description,
    this.uuid,
    this.createdAt,
    this.isActive,
  });

  TailleStandard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    description = json['description'];
    uuid = json['uuid'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['description'] = description;
    data['uuid'] = uuid;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }
}

