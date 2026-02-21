import 'package:ateliya/data/models/modele.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

/// Représente l'élément retourné par l'API boutique.
/// Structure :
/// {
///   "modele": {...},
///   "quantiteBoutique": 114,
///   "bilan": { "parTaille": {...}, "parPrix": {...}, "parCouleur": {...} },
///   "variantes": [...]
/// }
class StockModeleItem {
  Modele? modele;
  int quantiteBoutique;
  BilanStock bilan;
  List<ModeleBoutique> variantes;

  StockModeleItem({
    this.modele,
    this.quantiteBoutique = 0,
    BilanStock? bilan,
    this.variantes = const [],
  }) : bilan = bilan ?? BilanStock();

  factory StockModeleItem.fromJson(Json json) {
    return StockModeleItem(
      modele: json['modele'] != null ? Modele.fromJson(json['modele']) : null,
      quantiteBoutique: json['quantiteBoutique'] ?? 0,
      bilan: json['bilan'] != null
          ? BilanStock.fromJson(json['bilan'])
          : BilanStock(),
      variantes: json['variantes'] is List
          ? (json['variantes'] as List)
              .map((e) => ModeleBoutique.fromJson(e as Json))
              .toList()
          : [],
    );
  }

  /// Prix min parmi toutes les variantes (formaté)
  String get prixMin {
    if (variantes.isEmpty) return '0 F';
    final prices = variantes
        .where((v) => v.prixMinimal != null)
        .map((v) => v.prixMinimal!)
        .toList();
    if (prices.isEmpty) {
      return variantes.first.prix.toAmount(unit: 'F');
    }
    prices.sort();
    return prices.first.toAmount(unit: 'F');
  }

  /// Prix max parmi toutes les variantes (formaté)
  String get prixMax {
    if (variantes.isEmpty) return '0 F';
    final prices = variantes
        .where((v) => v.prix != null)
        .map((v) => v.prix.toStrictDouble())
        .toList();
    if (prices.isEmpty) return '0 F';
    prices.sort();
    return prices.last.toAmount(unit: 'F');
  }

  /// Tailles disponibles (filtrées, sans valeurs vides ou "N/A")
  List<String> get tailles {
    return bilan.parTaille.keys
        .where((t) => t.isNotEmpty && t != 'N/A')
        .toList();
  }

  /// Couleurs disponibles (filtrées)
  List<String> get couleurs {
    return bilan.parCouleur.keys
        .where((c) => c.isNotEmpty && c != 'N/A')
        .toList();
  }
}

class BilanStock {
  Map<String, int> parTaille;
  Map<String, int> parPrix;
  Map<String, int> parCouleur;

  BilanStock({
    this.parTaille = const {},
    this.parPrix = const {},
    this.parCouleur = const {},
  });

  factory BilanStock.fromJson(Json json) {
    Map<String, int> parseMap(dynamic raw) {
      if (raw is Map) {
        return raw.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
      }
      return {};
    }

    return BilanStock(
      parTaille: parseMap(json['parTaille']),
      parPrix: parseMap(json['parPrix']),
      parCouleur: parseMap(json['parCouleur']),
    );
  }
}
