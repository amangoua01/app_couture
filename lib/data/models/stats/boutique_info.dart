class BoutiqueInfo {
  int? id;
  String? libelle;

  BoutiqueInfo({this.id, this.libelle});

  BoutiqueInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'libelle': libelle};
}
