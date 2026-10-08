import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/accueil_data.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/components/data_cache.dart';
import 'package:ateliya/tools/models/data_response.dart';

class AccueilApi extends WebController {
  @override
  String get module => "accueil";

  String _cacheKey(int entiteId, EntiteEntrepriseType type) =>
      "accueil:$entiteId:${type.name}";

  /// Dernier tableau de bord connu, affiché le temps que le réseau réponde.
  Future<AccueilData?> readCached(int entiteId, EntiteEntrepriseType type) async {
    final raw = await DataCache.read(_cacheKey(entiteId, type));
    if (raw is! Map) return null;
    try {
      return AccueilData.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  Future<DataResponse<AccueilData>> getAccueilData(
      int entiteId, EntiteEntrepriseType type) async {
    try {
      final res = await client.get(
        urlBuilder(
          api: "$entiteId/${type.name.toLowerCase()}",
        ),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await DataCache.write(_cacheKey(entiteId, type), data["data"]);
        return DataResponse.success(data: AccueilData.fromJson(data["data"]));
      } else {
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase ?? "Erreur inconnu",
          detailErrors: data["code"],
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
