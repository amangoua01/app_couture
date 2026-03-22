class StockTopModele {
  int? modeleBoutiqueId;
  String? libelle;
  String? taille;
  int? stockActuel;
  int? qteEntree;
  int? qteSortie;
  int? totalMouvement;

  StockTopModele({
    this.modeleBoutiqueId,
    this.libelle,
    this.taille,
    this.stockActuel,
    this.qteEntree,
    this.qteSortie,
    this.totalMouvement,
  });

  StockTopModele.fromJson(Map<String, dynamic> json) {
    modeleBoutiqueId = json['modeleBoutiqueId'];
    libelle = json['libelle'];
    taille = json['taille'];
    stockActuel = json['stockActuel'];
    qteEntree = json['qteEntree'];
    qteSortie = json['qteSortie'];
    totalMouvement = json['totalMouvement'];
  }

  Map<String, dynamic> toJson() => {
        'modeleBoutiqueId': modeleBoutiqueId,
        'libelle': libelle,
        'taille': taille,
        'stockActuel': stockActuel,
        'qteEntree': qteEntree,
        'qteSortie': qteSortie,
        'totalMouvement': totalMouvement,
      };
}
