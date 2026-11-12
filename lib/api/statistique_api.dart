import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/stats/comparaison_entite.dart';
import 'package:ateliya/data/models/stats/globale_stats.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/data/models/stats/stock_statistiques.dart';
import 'package:ateliya/tools/components/data_cache.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/models/period_stat_req.dart';

class StatistiqueApi extends WebController {
  @override
  String get module => "statistique";

  String _stockStatsCacheKey(int boutiqueId, Map<String, dynamic> params) =>
      "stockStats:$boutiqueId:${params['filtre']}:${params['dateDebut']}:${params['dateFin']}";

  /// Dernières statistiques de stock connues pour cette boutique et cette
  /// période, affichées avant la réponse réseau.
  Future<StockStatistiques?> readCachedStockStatistiques(
    int boutiqueId,
    PeriodStatReq params,
  ) async {
    final raw = await DataCache.read(
      _stockStatsCacheKey(boutiqueId, params.toJson()),
    );
    if (raw is! Map) return null;
    try {
      return StockStatistiques.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  Future<DataResponse<StockStatistiques>> getStockStatistiques(
    int boutiqueId,
    PeriodStatReq params,
  ) async {
    try {
      final paramsJson = params.toJson();
      final res = await client.post(
        urlBuilder(api: "stock/$boutiqueId"),
        body: jsonEncode(paramsJson),
        headers: authHeaders,
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await DataCache.write(
          _stockStatsCacheKey(boutiqueId, paramsJson),
          body["data"],
        );
        return DataResponse.success(
          data: StockStatistiques.fromJson(body["data"]),
        );
      } else {
        return DataResponse.error(message: body['message']);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<StatistiquesBoutique>> getData(
    int boutiqueId,
    PeriodStatReq params,
    EntiteEntrepriseType type,
  ) async {
    try {
      final res = await client.post(
        urlBuilder(api: "ateliya/${type.name}/$boutiqueId"),
        body: params.toJson().parseToJson(),
        headers: authHeaders,
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: StatistiquesBoutique.fromJson(body["data"]),
        );
      } else {
        return DataResponse.error(message: body['message']);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  String _dashboardCacheKey(Map<String, dynamic> params) =>
      "dashboardStats:${params['filtre']}:${params['dateDebut']}:${params['dateFin']}:${params['espaceType']}";

  /// Dernières statistiques d'entreprise connues pour cette période.
  Future<StatistiquesBoutique?> readCachedDashboardData(
    PeriodStatReq params,
  ) async {
    final raw = await DataCache.read(_dashboardCacheKey(params.toJson()));
    if (raw is! Map) return null;
    try {
      return StatistiquesBoutique.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  Future<DataResponse<StatistiquesBoutique>> getDashboardData(
    PeriodStatReq params,
  ) async {
    try {
      final paramsJson = params.toJson();
      final res = await client.post(
        urlBuilder(api: "ateliya/dashboard"),
        body: paramsJson.parseToJson(),
        headers: authHeaders,
      );
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await DataCache.write(_dashboardCacheKey(paramsJson), body["data"]);
        return DataResponse.success(
          data: StatistiquesBoutique.fromJson(body["data"]),
        );
      } else {
        return DataResponse.error(message: body['message']);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Vue globale (boutiques + ateliers + période précédente) en un seul appel.
  Future<DataResponse<GlobaleStats>> getGlobale(PeriodStatReq params) async {
    try {
      final paramsJson = params.toJson()..remove('espaceType');
      final res = await client.post(
        urlBuilder(api: "ateliya/globale"),
        body: paramsJson.parseToJson(),
        headers: authHeaders,
      );
      if (res.statusCode == 404) return _globaleParRepli(params);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 && body["data"] != null) {
        return DataResponse.success(
          data: GlobaleStats.fromJson(Map<String, dynamic>.from(body["data"])),
        );
      }
      return DataResponse.error(message: body['message']);
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Serveur pas encore à jour : on assemble la vue globale à partir de deux
  /// appels au tableau de bord (boutiques puis ateliers), sans comparaison
  /// avec la période précédente.
  Future<DataResponse<GlobaleStats>> _globaleParRepli(PeriodStatReq params) async {
    final b = await getDashboardData(params..espaceType = "boutique");
    final a = await getDashboardData(params..espaceType = "succursale");
    params.espaceType = null;
    if (!b.status || !a.status) {
      return DataResponse.error(message: (b.status ? a : b).message);
    }
    return DataResponse.success(
      data: GlobaleStats(
        boutiques: b.data,
        ateliers: a.data,
        entites: [
          for (final e in b.data?.comparaisonEntites ?? <ComparaisonEntite>[]) e,
        ],
      ),
    );
  }
}
