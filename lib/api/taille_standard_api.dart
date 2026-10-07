import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/taille_standard.dart';
import 'package:ateliya/tools/components/data_cache.dart';
import 'package:ateliya/tools/models/data_response.dart';

class TailleStandardApi extends WebController {
  @override
  String get module => "taille-standard";

  static const _cacheKey = "tailleStandards:all";

  /// Référentiel quasi fixe : la dernière liste connue est réaffichée
  /// instantanément plutôt que de refaire l'appel réseau à chaque ouverture
  /// du formulaire de pièce.
  Future<List<TailleStandard>?> readCachedList() async {
    final raw = await DataCache.readList(_cacheKey);
    if (raw == null) return null;
    try {
      return raw.map((e) => TailleStandard.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<DataResponse<List<TailleStandard>>> list() async {
    try {
      final response = await client.get(urlBuilder(), headers: authHeaders);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'] as List? ?? [];
        await DataCache.write(_cacheKey, data);
        final items = data.map((x) => TailleStandard.fromJson(x)).toList();
        return DataResponse.success(data: items);
      } else {
        return DataResponse.error(message: "Erreur lors de la récupération");
      }
    } catch (e, st) {
      return DataResponse.error(stackTrace: st, systemError: e);
    }
  }
}
