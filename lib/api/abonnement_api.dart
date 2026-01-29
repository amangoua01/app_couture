import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/abonnement.dart';
import 'package:ateliya/data/models/module_abonnement.dart';
import 'package:ateliya/tools/models/data_response.dart';

class AbonnementApi extends WebController {
  @override
  String get module => "abonnement";

  Future<DataResponse<List<Abonnement>>> list() async {
    try {
      final res = await client.get(
        urlBuilder(api: "entreprise"),
        headers: authHeaders,
      );
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: (body['data'] as List)
              .map((e) => Abonnement.fromJson(e))
              .toList(),
        );
      } else {
        return DataResponse.error(message: body['message']);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<List<ModuleAbonnement>>> listForfaire() async {
    try {
      final res = await client.get(
        urlBuilder(module: "moduleAbonnement"),
        headers: authHeaders,
      );
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: (body['data'] as List)
              .map((e) => ModuleAbonnement.fromJson(e))
              .toList(),
        );
      } else {
        return DataResponse.error(message: body['message']);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
