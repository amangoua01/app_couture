class StockParTaille {
  String? taille;
  int? stockTotal;
  int? nbModeleBoutique;

  StockParTaille({this.taille, this.stockTotal, this.nbModeleBoutique});

  StockParTaille.fromJson(Map<String, dynamic> json) {
    taille = json['taille'];
    stockTotal = json['stockTotal'];
    nbModeleBoutique = json['nbModeleBoutique'];
  }

  Map<String, dynamic> toJson() => {
        'taille': taille,
        'stockTotal': stockTotal,
        'nbModeleBoutique': nbModeleBoutique,
      };
}
