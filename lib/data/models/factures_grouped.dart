import 'package:ateliya/data/models/mesure.dart';

class FacturesGrouped {
  List<Mesure> terminees;
  List<Mesure> nonTerminees;
  List<Mesure> soldeesNonTerminees;

  FacturesGrouped({
    this.terminees = const [],
    this.nonTerminees = const [],
    this.soldeesNonTerminees = const [],
  });

  factory FacturesGrouped.fromJson(Map<String, dynamic> json) {
    return FacturesGrouped(
      terminees: (json["terminees"] as List?)
              ?.map((x) => Mesure.fromJson(x))
              .toList() ??
          [],
      nonTerminees: (json["nonTerminees"] as List?)
              ?.map((x) => Mesure.fromJson(x))
              .toList() ??
          [],
      soldeesNonTerminees: (json["soldeesNonTerminees"] as List?)
              ?.map((x) => Mesure.fromJson(x))
              .toList() ??
          [],
    );
  }
}
