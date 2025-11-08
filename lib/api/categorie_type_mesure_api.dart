import 'dart:convert';

import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/dto/create_categorie_type_mesure_dto.dart';
import 'package:app_couture/data/models/categorie_type_mesure.dart';
import 'package:app_couture/tools/extensions/types/map.dart';
import 'package:app_couture/tools/models/data_response.dart';

class CategorieTypeMesureApi extends CrudWebController<CategorieTypeMesure> {
  @override
  CategorieTypeMesure get item => CategorieTypeMesure();

  @override
  String get module => "categorieTypeMesure";

  @override
  Future<DataResponse<CategorieTypeMesure>> create(CategorieTypeMesure item) {
    throw UnimplementedError();
  }

  Future<DataResponse<List<CategorieTypeMesure>>> createInTypeMesure(
    CreateCategorieTypeMesureDto dto,
  ) async {
    try {
      var response = await client.post(
        urlBuilder(api: "create"),
        headers: authHeaders,
        body: dto.toJson().parseToJson(),
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return DataResponse.success(
          data: (body['data'] as List)
              .map((e) => CategorieTypeMesure.fromJson(e))
              .toList(),
        );
      } else {
        return DataResponse.error(message: body['message']);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, systemtraceError: st);
    }
  }
}
