class StockEvolution {
  String? date;
  int? qteEntree;
  int? qteSortie;
  int? solde;

  StockEvolution({this.date, this.qteEntree, this.qteSortie, this.solde});

  StockEvolution.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    qteEntree = json['qteEntree'];
    qteSortie = json['qteSortie'];
    solde = json['solde'];
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'qteEntree': qteEntree,
        'qteSortie': qteSortie,
        'solde': solde,
      };
}
