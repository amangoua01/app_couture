import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/dto/dash_item_dto.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/models/period_stat_req.dart';

class StatistiqueApi extends WebController {
  @override
  String get module => "statistique";

  Future<DataResponse<StatistiquesBoutique>> getData(
    int boutiqueId,
    PeriodStatReq params,
  ) async {
    try {
      final res = await client.post(
        urlBuilder(api: "ateliya/boutique/$boutiqueId"),
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
    DashItemDto params,
    EntiteEntrepriseType type,
  ) async {
    try {
      final res = await client.post(
        urlBuilder(api: "ateliya/${type.name}/${params.id}"),
        body: params.toJson().parseToJson(),
        headers: authHeaders,
      );
      final body = await jsonDecode(res.body);
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
