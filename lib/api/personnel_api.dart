import 'dart:convert';

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/models/data_response.dart';

class PersonnelApi extends CrudWebController<User> {
  PersonnelApi()
    : super(
        listApi: "entreprise",
        createApi: "create/membre",
        updateApi: "update/membre",
      );

  @override
  User get item => User();

  @override
  String get module => 'user';

  Future<DataResponse<void>> toggleActive(int id) async {
    try {
      final res = await client.patch(
        urlBuilder(api: "$id/toggle-active"),
        headers: authHeaders,
      );
      if (res.statusCode == 200) {
        return DataResponse.success(data: null);
      }
      final data = jsonDecode(res.body);
      return DataResponse.error(message: data["message"] ?? res.reasonPhrase);
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
