class LigneMouvementCaisse {
  int? caisseId;
  String? caisseLibelle;
  String? montant;

  LigneMouvementCaisse({this.caisseId, this.caisseLibelle, this.montant});

  LigneMouvementCaisse.fromJson(Map<String, dynamic> json) {
    caisseId = json['caisseId'];
    caisseLibelle = json['caisseLibelle'];
    montant = json['montant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caisseId'] = caisseId;
    data['caisseLibelle'] = caisseLibelle;
    data['montant'] = montant;
    return data;
  }
}
