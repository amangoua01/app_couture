import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/tools/models/data_response.dart';

class OperateurApi extends WebController {
  @override
  String get module => "operateur";

  Future<DataResponse<List<dynamic>>> list() async {
    try {
      final res = await client.get(
        urlBuilder(),
        headers: authHeaders,
      );
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: (body['data'] as List).map((e) => e).toList(),
        );
      } else {
        return DataResponse.error(message: body['message']);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
