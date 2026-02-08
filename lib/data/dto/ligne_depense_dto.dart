class LignesDepenseDto {
  int? caisseId;
  String? montant;

  LignesDepenseDto({this.caisseId, this.montant});

  LignesDepenseDto.fromJson(Map<String, dynamic> json) {
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
