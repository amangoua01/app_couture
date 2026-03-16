class LigneMouvementCaisseDto {
  int? caisseId;
  String? montant;

  LigneMouvementCaisseDto({this.caisseId, this.montant});

  LigneMouvementCaisseDto.fromJson(Map<String, dynamic> json) {
    caisseId = json['caisse_id'];
    montant = json['montant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caisse_id'] = caisseId;
    data['montant'] = montant;
    return data;
  }
}
