/// Remise au vocabulaire de la couture d'une dictée transcrite.
///
/// La reconnaissance vocale ne connaît pas le métier : elle transcrit ce qui
/// sonne le plus probable en français courant. « Dos » devient « d'eau » ou
/// « do », « épaule » devient « et pour », « col » devient « colle ». Aucune
/// comparaison de lettres ne peut rattraper « eau » → « dos » : il faut
/// connaître le domaine.
///
/// Ce dictionnaire ne corrige que des mots qui n'ont aucun sens dans une prise
/// de mesures (de l'eau, un coup, une dot…), ce qui évite d'abîmer une dictée
/// légitime.
library;

const _avecAccents = 'àâäáãåèéêëìíîïòóôöõùúûüçñýÿ';
const _sansAccents = 'aaaaaaeeeeiiiiooooouuuucnyy';

/// Transcriptions fautives de deux mots, testées avant les mots isolés.
const Map<String, String> _correctionsDeuxMots = {
  'd eau': 'dos',
  'd os': 'dos',
  'et pour': 'epaule',
  'et paule': 'epaule',
  'entre jambe': 'entrejambe',
  'entre jambes': 'entrejambe',
  'en manchure': 'emmanchure',
  'tour taille': 'tour de taille',
  'long manche': 'longueur de manche',
};

/// Transcriptions fautives d'un seul mot.
const Map<String, String> _correctionsUnMot = {
  // Dos : de loin la confusion la plus fréquente.
  'deau': 'dos', 'deaux': 'dos', 'do': 'dos', 'dot': 'dos',
  'dots': 'dos', 'eau': 'dos', 'daud': 'dos',
  // Col et cou.
  'colle': 'col', 'cole': 'col', 'coll': 'col',
  'coup': 'cou', 'cout': 'cou', 'coud': 'cou', 'coups': 'cou',
  // Épaule.
  'epaules': 'epaule', 'epaulee': 'epaule', 'epaulés': 'epaule',
  // Manches et longueurs.
  'manches': 'manche', 'planche': 'manche', 'manchette': 'manche',
  'longueurs': 'longueur', 'longeur': 'longueur', 'longeurs': 'longueur',
  // Autres mesures courantes.
  'poignee': 'poignet', 'poignees': 'poignet', 'poignets': 'poignet',
  'cuisses': 'cuisse', 'cuise': 'cuisse',
  'hanches': 'hanche', 'anche': 'hanche', 'anches': 'hanche',
  'genoux': 'genou',
  'bacin': 'bassin', 'bassins': 'bassin',
  'carure': 'carrure', 'carrures': 'carrure',
  'poitrines': 'poitrine', 'poitrinne': 'poitrine',
  'tours': 'tour',
  'ceintures': 'ceinture',
  'mollets': 'mollet',
  'bustes': 'buste', 'bust': 'buste',
  'totale': 'totale', 'total': 'totale',
};

String _sansAccent(String valeur) {
  final tampon = StringBuffer();
  for (final rune in valeur.runes) {
    final caractere = String.fromCharCode(rune);
    final index = _avecAccents.indexOf(caractere);
    tampon.write(index >= 0 ? _sansAccents[index] : caractere);
  }
  return tampon.toString();
}

/// Réécrit une dictée en vocabulaire de couture.
///
/// Les nombres et les mots inconnus sont laissés tels quels : seule la
/// terminologie métier est rétablie.
String corrigerVocabulaireCouture(String texte) {
  if (texte.trim().isEmpty) return texte;

  // Les apostrophes portent la confusion (« d'eau ») : on les traite comme des
  // séparateurs pour pouvoir reconnaître la paire de mots.
  final mots = texte
      .replaceAll(RegExp(r"[’']"), ' ')
      .split(RegExp(r'\s+'))
      .where((m) => m.isNotEmpty)
      .toList();

  final resultat = <String>[];
  var i = 0;
  while (i < mots.length) {
    final motSeul = _cleParMot(mots[i]);

    if (i + 1 < mots.length) {
      final paire = '$motSeul ${_cleParMot(mots[i + 1])}';
      final correctionPaire = _correctionsDeuxMots[paire];
      if (correctionPaire != null) {
        resultat.add(correctionPaire);
        i += 2;
        continue;
      }
    }

    final correction = _correctionsUnMot[motSeul];
    resultat.add(correction ?? mots[i]);
    i++;
  }
  return resultat.join(' ');
}

/// Forme comparable d'un mot : minuscules, sans accent ni ponctuation.
String _cleParMot(String mot) =>
    _sansAccent(mot.toLowerCase()).replaceAll(RegExp(r'[^a-z0-9]'), '');
