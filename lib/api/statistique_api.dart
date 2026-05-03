import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/data/models/stats/stock_statistiques.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/models/period_stat_req.dart';

class StatistiqueApi extends WebController {
  @override
  String get module => "statistique";

  Future<DataResponse<StockStatistiques>> getStockStatistiques(
    int boutiqueId,
    PeriodStatReq params,
  ) async {
    try {
      final res = await client.post(
        urlBuilder(api: "stock/$boutiqueId"),
        body: jsonEncode(params.toJson()),
        headers: authHeaders,
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
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

  Future<DataResponse<StatistiquesBoutique>> getDashboardData(
    PeriodStatReq params,
  ) async {
    try {
      final res = await client.post(
        urlBuilder(api: "ateliya/dashboard"),
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
}
