import 'dart:convert';

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/models/data_response.dart';

class TypeMesureApi extends CrudWebController<TypeMesure> {
  TypeMesureApi() : super(listApi: "entreprise");
  @override
  TypeMesure get item => TypeMesure();

  @override
  String get module => "typeMesure";

  Future<DataResponse<List<TypeMesure>>> typeMesureWithCategories() async {
    try {
      final res = await client.get(urlBuilder(api: "entreprise"));
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: (body["data"] as List)
              .map((e) => TypeMesure.fromJson(e))
              .toList(),
        );
      } else {
        return DataResponse.error(
          systemError: "Une erreur est survenue",
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
