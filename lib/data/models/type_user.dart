class TypeUser {
  int? id;
  String? libelle;
  String? code;
  String? createdAt;

  TypeUser({this.id, this.libelle, this.code, this.createdAt});

  TypeUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    code = json['code'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['code'] = code;
    data['createdAt'] = createdAt;
    return data;
  }
}