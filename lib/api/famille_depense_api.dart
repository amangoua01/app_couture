import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/components/data_cache.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/models/paginated_data.dart';

class FamilleDepenseApi extends WebController {
  @override
  String get module => "famille-depense";

  static const _cacheKey = "typesDepense:visible";

  /// Derniers types connus (globaux + privés), affichés avant le réseau.
  Future<List<FamilleDepense>?> readCachedList() async {
    final raw = await DataCache.readList(_cacheKey);
    if (raw == null) return null;
    try {
      return raw.map((e) => FamilleDepense.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<DataResponse<PaginatedData<FamilleDepense>>> list({
    int page = 1,
  }) async {
    try {
      final res = await client.get(
        urlBuilder(api: "/", params: {"page": page.toString()}),
        headers: authHeaders,
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if ((data as Map).containsKey("data")) data = data["data"];
        if (page == 1) await DataCache.write(_cacheKey, data);
        return DataResponse.success(
          data: PaginatedData<FamilleDepense>(
            items:
                (data as List).map((e) => FamilleDepense.fromJson(e)).toList(),
            page: page,
          ),
        );
      } else {
        return DataResponse.error(message: data["message"] ?? res.reasonPhrase);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Crée un type privé, visible uniquement par notre entreprise.
  Future<DataResponse<FamilleDepense>> create(String libelle) async {
    try {
      final res = await client.post(
        urlBuilder(api: "create"),
        body: jsonEncode({"libelle": libelle}),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await DataCache.invalidate(_cacheKey);
        return DataResponse.success(
          data: FamilleDepense.fromJson(data["data"]),
        );
      } else {
        return DataResponse.error(message: data["message"] ?? res.reasonPhrase);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Supprime un type privé que nous avons créé (un type global ne peut
  /// pas être supprimé depuis l'app : le serveur refusera sinon).
  Future<DataResponse<bool>> delete(int id) async {
    try {
      final res = await client.delete(
        urlBuilder(api: "delete/$id"),
        headers: authHeaders,
      );
      if (res.statusCode == 200) {
        await DataCache.invalidate(_cacheKey);
        return DataResponse.success(data: true);
      } else {
        final data = jsonDecode(res.body);
        return DataResponse.error(message: data["message"] ?? res.reasonPhrase);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
