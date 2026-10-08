/// Rapprochement de libellés dictés et de libellés du catalogue.
///
/// La dictée vocale ne restitue jamais exactement le libellé enregistré : le
/// moteur écrit « do » pour « dos », le couturier dit « longueur manche » là où
/// la catégorie s'appelle « Longueur de manche ». Une comparaison par simple
/// inclusion de texte échouait sur ces deux cas — et, à l'inverse, acceptait
/// des rapprochements absurdes (« col » se retrouvant dans « colonne »).
///
/// On compare donc mot à mot, après avoir retiré accents, ponctuation et mots
/// de liaison, avec une tolérance aux petites différences d'orthographe.
library;

const _avecAccents = 'àâäáãåèéêëìíîïòóôöõùúûüçñýÿ';
const _sansAccents = 'aaaaaaeeeeiiiiooooouuuucnyy';

/// Mots de liaison sans valeur distinctive : les ignorer est ce qui rend
/// « longueur manche » et « longueur de manche » équivalents.
const _motsDeLiaison = {
  'de', 'du', 'des', 'd', 'la', 'le', 'les', 'l',
  'a', 'au', 'aux', 'en', 'et', 'sur', 'pour', 'un', 'une',
};

/// Score minimal pour considérer deux libellés comme désignant la même mesure.
///
/// Calibré pour accepter « do » → « dos » (0,67) tout en rejetant
/// « col » → « colonne » (0,43).
const double seuilCorrespondanceLibelle = 0.62;

String normaliserLibelle(String? valeur) {
  final brut = (valeur ?? '').toLowerCase().trim();
  final tampon = StringBuffer();
  for (final rune in brut.runes) {
    final caractere = String.fromCharCode(rune);
    final index = _avecAccents.indexOf(caractere);
    tampon.write(index >= 0 ? _sansAccents[index] : caractere);
  }
  return tampon
      .toString()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .trim();
}

List<String> motsSignificatifs(String? valeur) => normaliserLibelle(valeur)
    .split(' ')
    .where((mot) => mot.isNotEmpty && !_motsDeLiaison.contains(mot))
    .toList();

int _distanceEdition(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  var precedente = List<int>.generate(b.length + 1, (i) => i);
  var courante = List<int>.filled(b.length + 1, 0);

  for (var i = 0; i < a.length; i++) {
    courante[0] = i + 1;
    for (var j = 0; j < b.length; j++) {
      final cout = a[i] == b[j] ? 0 : 1;
      final suppression = precedente[j + 1] + 1;
      final insertion = courante[j] + 1;
      final substitution = precedente[j] + cout;
      var minimum = suppression < insertion ? suppression : insertion;
      if (substitution < minimum) minimum = substitution;
      courante[j + 1] = minimum;
    }
    final tampon = precedente;
    precedente = courante;
    courante = tampon;
  }
  return precedente[b.length];
}

double _similariteMot(String a, String b) {
  if (a == b) return 1;
  final longueurMax = a.length > b.length ? a.length : b.length;
  if (longueurMax == 0) return 1;
  return 1 - _distanceEdition(a, b) / longueurMax;
}

/// Renvoie entre 0 et 1 à quel point deux libellés désignent la même mesure.
double similariteLibelle(String? a, String? b) {
  final motsA = motsSignificatifs(a);
  final motsB = motsSignificatifs(b);
  if (motsA.isEmpty || motsB.isEmpty) return 0;
  if (motsA.join(' ') == motsB.join(' ')) return 1;

  final courte = motsA.length <= motsB.length ? motsA : motsB;
  final longue = motsA.length <= motsB.length ? motsB : motsA;

  var cumul = 0.0;
  for (final mot in courte) {
    var meilleure = 0.0;
    for (final candidat in longue) {
      final score = _similariteMot(mot, candidat);
      if (score > meilleure) meilleure = score;
    }
    cumul += meilleure;
  }

  // Un libellé bien plus court que l'autre reste plausible (« manche » pour
  // « longueur de manche ») mais doit passer après une correspondance complète.
  final proportion = courte.length / longue.length;
  return (cumul / courte.length) * (0.65 + 0.35 * proportion);
}
