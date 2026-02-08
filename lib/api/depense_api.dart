import 'dart:convert';

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/dto/depense_dto.dart';
import 'package:ateliya/data/models/depense.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/models/data_response.dart';

class DepenseApi extends CrudWebController<Depense> {
  DepenseApi() : super(listApi: "entreprise");

  @override
  Depense get item => Depense();

  @override
  String get module => "depense";

  Future<DataResponse<Depense>> createOne(DepenseDto dto) async {
    try {
      final res = await client.post(
        urlBuilder(api: "create"),
        body: dto.toJson().parseToJson(),
        headers: authHeaders,
      );
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: Depense.fromJson(json["data"]));
      } else {
        return DataResponse.error(message: json["message"]);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
