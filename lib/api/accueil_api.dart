import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/accueil_data.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/models/data_response.dart';

class AccueilApi extends WebController {
  @override
  String get module => "accueil";

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
        return DataResponse.success(data: AccueilData.fromJson(data["data"]));
      } else {
        return DataResponse.error(
            message: data["message"] ?? res.reasonPhrase ?? "Erreur inconnu");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
