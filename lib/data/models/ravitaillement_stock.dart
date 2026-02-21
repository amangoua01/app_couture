import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/entreprise.dart';
import 'package:ateliya/data/models/ligne_entree_stock.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

/// Représente un ravitaillement (entrée de stock) tel que retourné par
/// GET /stock/{boutiqueId}.
class RavitaillementStock extends ModelJson<RavitaillementStock> {
  String? date;
  int? quantite;
  String? type;
  String? statut;
  String? commentaire;
  String? createdAt;
  bool? isActive;
  Entreprise? entreprise;
  Boutique? boutique;
  List<LigneEntreeStock> ligneEntres = [];

  RavitaillementStock({
    this.date,
    this.quantite,
    this.type,
    this.statut,
    this.commentaire,
    this.createdAt,
    this.isActive,
    this.entreprise,
    this.boutique,
    List<LigneEntreeStock>? ligneEntres,
  }) : ligneEntres = ligneEntres ?? [];

  @override
  RavitaillementStock fromJson(Json json) => RavitaillementStock.fromJson(json);

  RavitaillementStock.fromJson(Json json) {
    id = json['id'];
    date = json['date'];
    quantite = json['quantite'];
    type = json['type'];
    statut = json['statut'];
    commentaire = json['commentaire'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];

    entreprise = json['entreprise'] != null
        ? Entreprise.fromJson(json['entreprise'])
        : null;
    boutique =
        json['boutique'] != null ? Boutique.fromJson(json['boutique']) : null;

    if (json['ligneEntres'] != null) {
      ligneEntres = (json['ligneEntres'] as List)
          .map((e) => LigneEntreeStock.fromJson(e))
          .toList();
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'quantite': quantite,
        'type': type,
        'statut': statut,
        'commentaire': commentaire,
        'createdAt': createdAt,
        'isActive': isActive,
        'entreprise': entreprise?.toJson(),
        'boutique': boutique?.toJson(),
        'ligneEntres': ligneEntres.map((e) => e.toJson()).toList(),
      };

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool get isEntree => type == 'Entree';
  bool get isSortie => type == 'Sortie';
  bool get isEnAttente => statut == 'EN_ATTENTE';
  bool get isValide => statut == 'VALIDE';

  /// Date formatée lisible (ex: "20 fév 2026 à 19h27")
  String get dateFormatted =>
      date?.toDateTime()?.let(
            (d) =>
                '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} à ${d.hour}h${d.minute.toString().padLeft(2, '0')}',
          ) ??
      '';
}

extension _DateTimeExt on DateTime {
  T let<T>(T Function(DateTime) fn) => fn(this);
}
