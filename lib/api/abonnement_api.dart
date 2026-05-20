import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/module_abonnement.dart';
import 'package:ateliya/tools/models/data_response.dart';

class AbonnementApi extends WebController {
  @override
  String get module => "abonnement";

  Future<DataResponse<Map<String, dynamic>>> list() async {
    try {
      final res = await client.get(
        urlBuilder(api: "entreprise"),
        headers: authHeaders,
      );
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: body['data'] as Map<String, dynamic>,
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

  Future<DataResponse<String>> pay({
    required int forfaitId,
    required String email,
    required String numero,
    required int operateur,
    List<int> dataUser = const [],
    List<int> dataBoutique = const [],
    List<int> dataSuccursale = const [],
  }) async {
    try {
      final body = {
        "dataUser": dataUser,
        "dataBoutique": dataBoutique,
        "dataSuccursale": dataSuccursale,
        "email": email,
        "numero": numero,
        "operateur": operateur,
        "device": "mobile",
        'returnURL': '',
      };

      final res = await client.post(
        urlBuilder(api: "abonnement/$forfaitId"),
        headers: authHeaders,
        body: jsonEncode(body),
      );

      final resBody = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return DataResponse.success(data: resBody['data']["redirectUrl"]);
      } else {
        return DataResponse.error(
            message: resBody['message'] ?? "Erreur lors du paiement");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
