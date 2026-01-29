import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/abstract/model.dart';
import 'package:ateliya/data/models/abstract/model_form_data.dart';
import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/models/paginated_data.dart';
import 'package:http/http.dart' as http;

abstract class CrudWebController<T extends Model> extends WebController {
  T get item;

  final String createApi, updateApi, deleteApi, deleteMultipleApi, listApi;

  CrudWebController({
    this.listApi = "/",
    this.createApi = "create",
    this.updateApi = "update",
    this.deleteApi = "delete",
    this.deleteMultipleApi = "delete/all/items",
  });

  Future<DataResponse<PaginatedData<T>>> list({
    int? id,
    int? page,
    String? search,
  }) async {
    try {
      Uri url;
      if (id == null) {
        url = urlBuilder(api: listApi);
      } else {
        url = urlBuilder(api: "$listApi/$id");
      }

      if (page != null) {
        url = url.replace(queryParameters: {
          "page": "$page",
        });
      }

      final res = await client.get(url, headers: authHeaders);

      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if ((data as Map).containsKey("data")) data = data["data"];
        return DataResponse.success(
          data: PaginatedData<T>(
            items: (data as List).map<T>((e) => item.fromJson(e)).toList(),
            page: page ?? 1,
          ),
        );
      } else {
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase.value,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<T>> create(T item) async {
    try {
      final http.Response res;
      if (item is ModelJson) {
        res = await client.post(
          urlBuilder(api: createApi),
          body: jsonEncode(item.toJson()),
          headers: authHeaders,
        );
      } else {
        res = await client.multiPart(
          urlBuilder(api: createApi),
          body: (item as ModelFormData).toFields(),
          files: await item.toMultipartFile(),
          headers: authHeaders,
        );
      }
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: item.fromJson(data["data"]));
      } else {
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase.value,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<T>> update(T item) async {
    try {
      final http.Response res;
      if (item is ModelJson) {
        res = await client.put(
          urlBuilder(api: "$updateApi/${item.id.value}"),
          body: jsonEncode(item.toJson()),
          headers: authHeaders,
        );
      } else {
        res = await client.multiPart(
          urlBuilder(api: "$updateApi/${item.id.value}"),
          body: (item as ModelFormData).toFields(),
          files: await item.toMultipartFile(),
          headers: authHeaders,
        );
      }
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: item.fromJson(data["data"]));
      } else {
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase.value,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<bool>> delete(int id) async {
    try {
      final res = await client.delete(
        urlBuilder(api: "$deleteApi/$id"),
        headers: authHeaders,
      );
      if (res.statusCode == 200) {
        return DataResponse.success(data: true);
      } else {
        final data = jsonDecode(res.body);
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase.value,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<bool>> deleteMultiple(List<int> ids) async {
    try {
      final res = await client.post(
        urlBuilder(api: deleteMultipleApi),
        headers: authHeaders,
        body: jsonEncode({"ids": ids}),
      );
      if (res.statusCode == 200) {
        return DataResponse.success(data: true);
      } else {
        final data = jsonDecode(res.body);
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase.value,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<T>> getOne(int id) async {
    try {
      final res = await client.get(
        urlBuilder(api: "$id"),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: item.fromJson(data["data"]));
      } else {
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase.value,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
