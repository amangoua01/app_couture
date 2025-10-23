class Entreprise {
  int? id;
  String? libelle;
  String? numero;
  String? logo;
  String? email;
  String? createdAt;

  Entreprise(
      {this.id,
      this.libelle,
      this.numero,
      this.logo,
      this.email,
      this.createdAt});

  Entreprise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    numero = json['numero'];
    logo = json['logo'];
    email = json['email'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['numero'] = numero;
    data['logo'] = logo;
    data['email'] = email;
    data['createdAt'] = createdAt;
    return data;
  }
}
