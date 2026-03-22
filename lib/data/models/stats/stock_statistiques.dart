import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/stats/boutique_info.dart';
import 'package:ateliya/data/models/stats/stat_periode.dart';
import 'package:ateliya/data/models/stats/stock_detail_modele.dart';
import 'package:ateliya/data/models/stats/stock_evolution.dart';
import 'package:ateliya/data/models/stats/stock_kpis.dart';
import 'package:ateliya/data/models/stats/stock_par_modele.dart';
import 'package:ateliya/data/models/stats/stock_par_taille.dart';
import 'package:ateliya/data/models/stats/stock_repartition.dart';
import 'package:ateliya/data/models/stats/stock_top_modele.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

export 'package:ateliya/data/models/stats/boutique_info.dart';
export 'package:ateliya/data/models/stats/stat_periode.dart';
export 'package:ateliya/data/models/stats/stock_detail_modele.dart';
export 'package:ateliya/data/models/stats/stock_evolution.dart';
export 'package:ateliya/data/models/stats/stock_kpis.dart';
export 'package:ateliya/data/models/stats/stock_par_modele.dart';
export 'package:ateliya/data/models/stats/stock_par_taille.dart';
export 'package:ateliya/data/models/stats/stock_repartition.dart';
export 'package:ateliya/data/models/stats/stock_top_modele.dart';
export 'package:ateliya/data/models/stats/stock_variante.dart';
export 'package:ateliya/data/models/stats/stock_movement_summary.dart';

class StockStatistiques extends ModelJson<StockStatistiques> {
  BoutiqueInfo? boutique;
  StatPeriode? periode;
  StockKpis? kpis;
  StockRepartition? repartition;
  List<StockEvolution>? evolution;
  List<StockTopModele>? topModeles;
  List<StockDetailModele>? detailModeles;
  List<StockParModele>? stockParModele;
  List<StockParTaille>? stockParTaille;

  StockStatistiques({
    this.boutique,
    this.periode,
    this.kpis,
    this.repartition,
    this.evolution,
    this.topModeles,
    this.detailModeles,
    this.stockParModele,
    this.stockParTaille,
  });

  @override
  StockStatistiques fromJson(Json json) => StockStatistiques.fromJson(json);

  StockStatistiques.fromJson(Json json) {
    boutique = json['boutique'] != null
        ? BoutiqueInfo.fromJson(json['boutique'])
        : null;
    periode =
        json['periode'] != null ? StatPeriode.fromJson(json['periode']) : null;
    kpis = json['kpis'] != null ? StockKpis.fromJson(json['kpis']) : null;
    repartition = json['repartition'] != null
        ? StockRepartition.fromJson(json['repartition'])
        : null;

    if (json['evolution'] != null) {
      evolution = <StockEvolution>[];
      json['evolution']
          .forEach((v) => evolution!.add(StockEvolution.fromJson(v)));
    }
    if (json['topModeles'] != null) {
      topModeles = <StockTopModele>[];
      json['topModeles']
          .forEach((v) => topModeles!.add(StockTopModele.fromJson(v)));
    }
    if (json['detailModeles'] != null) {
      detailModeles = <StockDetailModele>[];
      json['detailModeles']
          .forEach((v) => detailModeles!.add(StockDetailModele.fromJson(v)));
    }
    if (json['stockParModele'] != null) {
      stockParModele = <StockParModele>[];
      json['stockParModele']
          .forEach((v) => stockParModele!.add(StockParModele.fromJson(v)));
    }
    if (json['stockParTaille'] != null) {
      stockParTaille = <StockParTaille>[];
      json['stockParTaille']
          .forEach((v) => stockParTaille!.add(StockParTaille.fromJson(v)));
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (boutique != null) data['boutique'] = boutique!.toJson();
    if (periode != null) data['periode'] = periode!.toJson();
    if (kpis != null) data['kpis'] = kpis!.toJson();
    if (repartition != null) data['repartition'] = repartition!.toJson();
    if (evolution != null) {
      data['evolution'] = evolution!.map((v) => v.toJson()).toList();
    }
    if (topModeles != null) {
      data['topModeles'] = topModeles!.map((v) => v.toJson()).toList();
    }
    if (detailModeles != null) {
      data['detailModeles'] = detailModeles!.map((v) => v.toJson()).toList();
    }
    if (stockParModele != null) {
      data['stockParModele'] = stockParModele!.map((v) => v.toJson()).toList();
    }
    if (stockParTaille != null) {
      data['stockParTaille'] = stockParTaille!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
