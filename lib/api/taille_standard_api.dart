import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/taille_standard.dart';
import 'package:ateliya/tools/models/data_response.dart';

class TailleStandardApi extends WebController {
  @override
  String get module => "taille-standard";

  Future<DataResponse<List<TailleStandard>>> list() async {
    try {
      final response = await client.get(urlBuilder(), headers: authHeaders);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'] as List? ?? [];
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
