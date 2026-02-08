import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/models/paginated_data.dart';

class FamilleDepenseApi extends WebController {
  @override
  String get module => "famille-depense";

  Future<DataResponse<PaginatedData<FamilleDepense>>> list({
    int page = 1,
  }) async {
    try {
      final res = await client.get(
        urlBuilder(api: "/", params: {"page": page.toString()}),
        headers: authHeaders,
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if ((data as Map).containsKey("data")) data = data["data"];
        return DataResponse.success(
          data: PaginatedData<FamilleDepense>(
            items:
                (data as List).map((e) => FamilleDepense.fromJson(e)).toList(),
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
}
