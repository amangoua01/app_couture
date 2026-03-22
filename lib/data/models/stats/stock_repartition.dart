import 'package:ateliya/data/models/stats/stock_movement_summary.dart';

class StockRepartition {
  StockMovementSummary? entrees;
  StockMovementSummary? sorties;

  StockRepartition({this.entrees, this.sorties});

  StockRepartition.fromJson(Map<String, dynamic> json) {
    entrees = json['entrees'] != null
        ? StockMovementSummary.fromJson(json['entrees'])
        : null;
    sorties = json['sorties'] != null
        ? StockMovementSummary.fromJson(json['sorties'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'entrees': entrees?.toJson(),
        'sorties': sorties?.toJson(),
      };
}
