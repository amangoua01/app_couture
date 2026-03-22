class StockKpis {
  int? stockActuelTotal;
  int? nbModelesBoutique;
  int? nbModelesSansStock;
  int? nbMouvementsTotal;
  int? nbEntrees;
  int? nbSorties;
  int? qteEntreeTotale;
  int? qteSortieTotale;
  int? soldeNet;
  int? nbMouvementsEnAttente;

  StockKpis({
    this.stockActuelTotal,
    this.nbModelesBoutique,
    this.nbModelesSansStock,
    this.nbMouvementsTotal,
    this.nbEntrees,
    this.nbSorties,
    this.qteEntreeTotale,
    this.qteSortieTotale,
    this.soldeNet,
    this.nbMouvementsEnAttente,
  });

  StockKpis.fromJson(Map<String, dynamic> json) {
    stockActuelTotal = json['stockActuelTotal'];
    nbModelesBoutique = json['nbModelesBoutique'];
    nbModelesSansStock = json['nbModelesSansStock'];
    nbMouvementsTotal = json['nbMouvementsTotal'];
    nbEntrees = json['nbEntrees'];
    nbSorties = json['nbSorties'];
    qteEntreeTotale = json['qteEntreeTotale'];
    qteSortieTotale = json['qteSortieTotale'];
    soldeNet = json['soldeNet'];
    nbMouvementsEnAttente = json['nbMouvementsEnAttente'];
  }

  Map<String, dynamic> toJson() => {
        'stockActuelTotal': stockActuelTotal,
        'nbModelesBoutique': nbModelesBoutique,
        'nbModelesSansStock': nbModelesSansStock,
        'nbMouvementsTotal': nbMouvementsTotal,
        'nbEntrees': nbEntrees,
        'nbSorties': nbSorties,
        'qteEntreeTotale': qteEntreeTotale,
        'qteSortieTotale': qteSortieTotale,
        'soldeNet': soldeNet,
        'nbMouvementsEnAttente': nbMouvementsEnAttente,
      };
}
