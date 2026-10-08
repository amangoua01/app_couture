import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/int.dart';

/// Restriction des écrans du personnel à l'atelier actif.
///
/// Un ouvrier appartient à un atelier : afficher ceux de tous les ateliers
/// mélangeait des équipes distinctes, et le pointage comme le bilan de paie
/// portaient sur des gens qui ne travaillent pas sur place.
///
/// Les boutiques n'ont pas d'ouvriers rattachés : sélectionner une boutique
/// laisse donc la liste non filtrée plutôt que de la vider.
Map<String, String> filtreAtelierActif(EntiteEntreprise entite) {
  if (entite.type != EntiteEntrepriseType.succursale) return const {};
  final id = entite.id.value;
  if (id == 0) return const {};
  return {'succursaleId': '$id'};
}

/// Identifiant de l'atelier actif, ou `null` hors contexte atelier.
int? idAtelierActif(EntiteEntreprise entite) {
  if (entite.type != EntiteEntrepriseType.succursale) return null;
  final id = entite.id.value;
  return id == 0 ? null : id;
}

/// Mention de l'atelier à afficher sous le titre d'un écran du personnel, ou
/// `null` quand la liste n'est pas restreinte.
String? mentionAtelierActif(EntiteEntreprise entite) {
  if (idAtelierActif(entite) == null) return null;
  final nom = entite.libelle;
  return (nom == null || nom.isEmpty) ? "Atelier actif" : nom;
}
