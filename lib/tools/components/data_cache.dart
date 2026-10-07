import 'dart:convert';

import 'package:ateliya/tools/components/cache.dart';
import 'package:flutter/foundation.dart';

/// Cache des réponses de l'API, destiné au premier affichage d'un écran.
///
/// La stratégie est volontairement « périmé puis rafraîchi » : on réaffiche
/// immédiatement la dernière réponse connue, puis le réseau remplace les
/// données dès qu'il répond. L'écran n'est donc jamais bloqué par un
/// chargement complet quand il a déjà été consulté.
abstract class DataCache {
  /// Préfixe commun, qui permet de vider ce cache sans toucher à la session.
  static const prefix = "dc:";

  /// Au-delà, une entrée est considérée trop vieille pour être affichée.
  static const defaultMaxAge = Duration(days: 7);

  static String _key(String key) => "$prefix$key";

  static Future<void> write(String key, dynamic json) async {
    try {
      await Cache.setString(
        _key(key),
        jsonEncode({
          "at": DateTime.now().millisecondsSinceEpoch,
          "data": json,
        }),
      );
    } catch (e) {
      // Un cache non écrit ne doit jamais faire échouer un appel réseau.
      if (kDebugMode) debugPrint("DataCache.write($key) ignoré: $e");
    }
  }

  static Future<dynamic> read(
    String key, {
    Duration maxAge = defaultMaxAge,
  }) async {
    try {
      final raw = await Cache.getString(_key(key));
      if (raw == null) return null;

      final entry = jsonDecode(raw);
      if (entry is! Map) return null;

      final at = entry["at"];
      if (at is! int) return null;

      final age = DateTime.now().millisecondsSinceEpoch - at;
      if (age > maxAge.inMilliseconds) {
        await Cache.remove(_key(key));
        return null;
      }
      return entry["data"];
    } catch (e) {
      if (kDebugMode) debugPrint("DataCache.read($key) ignoré: $e");
      return null;
    }
  }

  static Future<List<dynamic>?> readList(
    String key, {
    Duration maxAge = defaultMaxAge,
  }) async {
    final data = await read(key, maxAge: maxAge);
    return data is List ? data : null;
  }

  /// Supprime toutes les entrées d'un module après une écriture.
  static Future<void> invalidate(String keyPrefix) =>
      Cache.removeWithPrefix(_key(keyPrefix));

  /// Vide l'intégralité du cache de données (déconnexion, changement de compte).
  static Future<void> clear() => Cache.removeWithPrefix(prefix);
}
