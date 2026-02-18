import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/models/paginated_data.dart';

class CaisseApi extends WebController {
  @override
  String get module => "caisses";

  Future<DataResponse<PaginatedData<Caisse>>> list({
    int page = 1,
  }) async {
    try {
      final res = await client.get(
        urlBuilder(
          api: "get-caisses",
          module: "depense",
          // params: {"page": page.toString()},
        ),
        headers: authHeaders,
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if ((data as Map).containsKey("data")) data = data["data"];
        return DataResponse.success(
          data: PaginatedData<Caisse>(
            items: (data as List).map((e) => Caisse.fromJson(e)).toList(),
            page: page,
          ),
        );
      } else {
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse> addMouvement(Map<String, dynamic> data) async {
    try {
      final res = await client.post(
        urlBuilder(module: "mouvement-caisse", api: "create"),
        body: jsonEncode(data),
        headers: authHeaders,
      );
      final json = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return DataResponse.success(data: json);
      } else {
        return DataResponse.error(
          message: json["message"] ?? res.reasonPhrase,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
