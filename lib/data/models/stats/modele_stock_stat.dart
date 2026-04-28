import 'package:ateliya/tools/extensions/types/map.dart';

class ModeleStockStat {
  int? id;
  String? libelle;
  int? stockGlobal;
  List<TailleStockStat> tailles = [];

  ModeleStockStat({
    this.id,
    this.libelle,
    this.stockGlobal,
    this.tailles = const [],
  });

  ModeleStockStat.fromJson(Json json) {
    id = json['id'];
    libelle = json['libelle'];
    stockGlobal = json['stockGlobal'];
    if (json['tailles'] != null) {
      tailles = <TailleStockStat>[];
      json['tailles'].forEach((v) {
        tailles.add(TailleStockStat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['stockGlobal'] = stockGlobal;
    data['tailles'] = tailles.map((v) => v.toJson()).toList();
    return data;
  }
}

class TailleStockStat {
  String? taille;
  int? quantite;

  TailleStockStat({this.taille, this.quantite});

  TailleStockStat.fromJson(Json json) {
    taille = json['taille'];
    quantite = json['quantite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taille'] = taille;
    data['quantite'] = quantite;
    return data;
  }
}
