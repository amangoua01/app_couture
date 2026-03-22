import 'package:ateliya/data/models/stats/stock_variante.dart';

class StockParModele {
  int? modeleId;
  String? libelle;
  int? stockTotal;
  int? nbVariantes;
  List<StockVariante>? variantes;

  StockParModele({
    this.modeleId,
    this.libelle,
    this.stockTotal,
    this.nbVariantes,
    this.variantes,
  });

  StockParModele.fromJson(Map<String, dynamic> json) {
    modeleId = json['modeleId'];
    libelle = json['libelle'];
    stockTotal = json['stockTotal'];
    nbVariantes = json['nbVariantes'];
    if (json['variantes'] != null) {
      variantes = <StockVariante>[];
      json['variantes']
          .forEach((v) => variantes!.add(StockVariante.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() => {
        'modeleId': modeleId,
        'libelle': libelle,
        'stockTotal': stockTotal,
        'nbVariantes': nbVariantes,
        'variantes': variantes?.map((v) => v.toJson()).toList(),
      };
}
