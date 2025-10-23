import 'dart:convert';

import 'package:app_couture/api/abstract/web_controller.dart';
import 'package:app_couture/data/models/pays.dart';
import 'package:app_couture/tools/models/data_response.dart';

class PaysApi extends WebController {
  @override
  String get module => "pays";

  Future<DataResponse<List<Pays>>> getAllPays() async {
    final response = await client.get(
      urlBuilder(api: "/"),
      headers: headers,
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return DataResponse.success(
          data: (json["data"] as List)
              .map<Pays>((item) => Pays.fromJson(item))
              .toList());
    } else {
      return DataResponse.error(message: json["error"]);
    }
  }
}
