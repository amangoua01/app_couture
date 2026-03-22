class StockMovementSummary {
  int? nbMouvements;
  int? qteTotal;
  int? confirmes;
  int? enAttente;
  int? rejetes;

  StockMovementSummary({
    this.nbMouvements,
    this.qteTotal,
    this.confirmes,
    this.enAttente,
    this.rejetes,
  });

  StockMovementSummary.fromJson(Map<String, dynamic> json) {
    nbMouvements = json['nbMouvements'];
    qteTotal = json['qteTotal'];
    confirmes = json['confirmes'];
    enAttente = json['enAttente'];
    rejetes = json['rejetes'];
  }

  Map<String, dynamic> toJson() => {
        'nbMouvements': nbMouvements,
        'qteTotal': qteTotal,
        'confirmes': confirmes,
        'enAttente': enAttente,
        'rejetes': rejetes,
      };
}
