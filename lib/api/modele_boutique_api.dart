import 'dart:convert';

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/modele_boutique_details.dart';
import 'package:ateliya/tools/models/data_response.dart';

class ModeleBoutiqueApi extends CrudWebController<ModeleBoutique> {
  ModeleBoutiqueApi() : super(listApi: "/entreprise");

  @override
  ModeleBoutique get item => ModeleBoutique();

  @override
  String get module => "modeleBoutique";

  Future<DataResponse<ModeleBoutiqueDetails>> getDetails(int modeleId) async {
    try {
      final res = await client.get(
        urlBuilder(api: 'details/$modeleId'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: ModeleBoutiqueDetails.fromJson(data['data']),
        );
      } else {
        return DataResponse.error(
          message:
              data['message'] ?? 'Erreur lors de la récupération des détails',
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
