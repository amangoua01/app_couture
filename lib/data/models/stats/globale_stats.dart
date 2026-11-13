import 'package:ateliya/data/models/stats/comparaison_entite.dart';
import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/data/models/stats/revenus_par_type.dart';
import 'package:ateliya/data/models/stats/revenus_quotidiens.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';

/// Vue globale d'une entreprise : toutes ses boutiques d'un côté, tous ses
/// ateliers de l'autre, avec les indicateurs de la période précédente.
class GlobaleStats {
  final StatistiquesBoutique boutiques;
  final StatistiquesBoutique ateliers;
  final Kpis boutiquesPrec;
  final Kpis ateliersPrec;
  final List<ComparaisonEntite> entites;

  GlobaleStats({
    StatistiquesBoutique? boutiques,
    StatistiquesBoutique? ateliers,
    Kpis? boutiquesPrec,
    Kpis? ateliersPrec,
    this.entites = const [],
  })  : boutiques = boutiques ?? StatistiquesBoutique(),
        ateliers = ateliers ?? StatistiquesBoutique(),
        boutiquesPrec = boutiquesPrec ?? Kpis(),
        ateliersPrec = ateliersPrec ?? Kpis();

  factory GlobaleStats.fromJson(Map<String, dynamic> json) {
    StatistiquesBoutique block(dynamic v) => v is Map
        ? StatistiquesBoutique.fromJson(Map<String, dynamic>.from(v))
        : StatistiquesBoutique();
    Kpis kpis(dynamic v) =>
        v is Map ? Kpis.fromJson(Map<String, dynamic>.from(v)) : Kpis();
    final prec = json['precedent'] is Map ? json['precedent'] as Map : {};
    return GlobaleStats(
      boutiques: block(json['boutiques']),
      ateliers: block(json['ateliers']),
      boutiquesPrec: kpis(prec['boutiques']),
      ateliersPrec: kpis(prec['ateliers']),
      entites: [
        for (final e in (json['comparaisonEntites'] as List? ?? const []))
          ComparaisonEntite.fromJson(Map<String, dynamic>.from(e)),
      ],
    );
  }

  int get chiffreAffaires =>
      boutiques.kpis.chiffreAffaires + ateliers.kpis.chiffreAffaires;
  int get chiffreAffairesPrec =>
      boutiquesPrec.chiffreAffaires + ateliersPrec.chiffreAffaires;

  /// Variation du chiffre d'affaires par rapport à la période précédente, en %.
  /// Null quand il n'y a rien à comparer.
  double? get variation {
    final prev = chiffreAffairesPrec;
    if (prev <= 0) return null;
    return (chiffreAffaires - prev) / prev * 100;
  }

  /// Boutiques et ateliers additionnés, pour la vue « Ensemble ».
  StatistiquesBoutique get ensemble {
    final a = boutiques.kpis, b = ateliers.kpis;
    final k = Kpis(
      chiffreAffaires: a.chiffreAffaires + b.chiffreAffaires,
      reservationsActives: a.reservationsActives + b.reservationsActives,
      clientsActifs: a.clientsActifs + b.clientsActifs,
      commandesEnCours: a.commandesEnCours + b.commandesEnCours,
      totalDepenses: a.totalDepenses + b.totalDepenses,
      totalMouvements: a.totalMouvements + b.totalMouvements,
      totalMouvementsEntrants:
          a.totalMouvementsEntrants + b.totalMouvementsEntrants,
      totalMouvementsSortants:
          a.totalMouvementsSortants + b.totalMouvementsSortants,
      caisse: a.caisse + b.caisse,
      recettesNettes: (a.recettesNettes ?? 0) + (b.recettesNettes ?? 0),
      montantDuClients: (a.montantDuClients ?? 0) + (b.montantDuClients ?? 0),
      nbVentesBoutique: (a.nbVentesBoutique ?? 0) + (b.nbVentesBoutique ?? 0),
    );
    final total = chiffreAffaires;
    k.ticketMoyen = null;
    final du = k.montantDuClients ?? 0;
    k.tauxRecouvrement =
        (total + du) > 0 ? (total / (total + du) * 100).round() : null;

    final n = boutiques.revenusQuotidiens.length >
            ateliers.revenusQuotidiens.length
        ? boutiques.revenusQuotidiens.length
        : ateliers.revenusQuotidiens.length;
    RevenusQuotidiens? at(List<RevenusQuotidiens> l, int i) =>
        i < l.length ? l[i] : null;
    final jours = <RevenusQuotidiens>[
      for (var i = 0; i < n; i++)
        RevenusQuotidiens(
          jour: at(boutiques.revenusQuotidiens, i)?.jour ??
              at(ateliers.revenusQuotidiens, i)?.jour,
          revenus: (at(boutiques.revenusQuotidiens, i)?.revenus ?? 0) +
              (at(ateliers.revenusQuotidiens, i)?.revenus ?? 0),
        ),
    ];

    final types = <String, int>{};
    for (final r in [...boutiques.revenusParType, ...ateliers.revenusParType]) {
      types[r.type ?? 'Autre'] = (types[r.type ?? 'Autre'] ?? 0) + (r.revenus ?? 0);
    }
    return StatistiquesBoutique(
      entityType: 'entreprise',
      periode: boutiques.periode ?? ateliers.periode,
      kpis: k,
      revenusQuotidiens: jours,
      revenusParType: [
        for (final e in types.entries) RevenusParType(type: e.key, revenus: e.value),
      ],
    );
  }
}
