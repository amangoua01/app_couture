import 'dart:convert';

import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/entreprise.dart';
import 'package:app_couture/data/models/entreprise_entities_response.dart';
import 'package:app_couture/tools/models/data_response.dart';

class EntrepriseApi extends CrudWebController<Entreprise> {
  @override
  Entreprise get item => Entreprise();

  @override
  String get module => 'entreprise';

  Future<DataResponse<EntrepriseEntitiesResponse>>
      getEntrepriseEntities() async {
    try {
      final res = await client.get(
        urlBuilder(api: 'surccursale/boutique'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: EntrepriseEntitiesResponse.fromJson(data),
        );
      } else {
        return DataResponse.error(
          message: data['error'],
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, systemtraceError: st);
    }
  }
}
