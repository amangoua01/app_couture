import 'dart:convert';

import 'package:app_couture/api/abstract/web_controller.dart';
import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/tools/constants/env.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/models/data_response.dart';
import 'package:app_couture/tools/models/paginated_data.dart';

abstract class CrudWebController<T extends Model> extends WebController {
  T get item;

  final String createApi, updateApi, deleteApi, listApi;

  CrudWebController({
    this.listApi = "all",
    this.createApi = "create",
    this.updateApi = "update",
    this.deleteApi = "delete",
  });

  Future<DataResponse<PaginatedData<T>>> list({
    int? id,
    int? page,
    int? perPage = Env.nbItemInListPage,
  }) async {
    try {
      Uri url;
      if (id == null) {
        url = urlBuilder(api: listApi);
      } else {
        url = urlBuilder(api: "$listApi/$id");
      }

      if (page != null && perPage != null) {
        url = url.replace(queryParameters: {
          "page": "$page",
          "per_page": "$perPage",
        });
      } else {
        if (page != null) {
          url = url.replace(queryParameters: {"page": "$page"});
        } else {
          url = url.replace(queryParameters: {"per_page": "$perPage"});
        }
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
      return DataResponse.error(systemError: e, systemtraceError: st);
    }
  }

  Future<DataResponse<T>> create(T item) async {
    try {
      final res = await client.post(
        urlBuilder(api: createApi),
        body: jsonEncode(item.toJson()),
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
      return DataResponse.error(systemError: e, systemtraceError: st);
    }
  }

  Future<DataResponse<T>> update(T item) async {
    try {
      final res = await client.put(
        urlBuilder(api: updateApi),
        headers: authHeaders,
        body: jsonEncode(item.toJson()),
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
      return DataResponse.error(systemError: e, systemtraceError: st);
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
      return DataResponse.error(systemError: e, systemtraceError: st);
    }
  }

  Future<DataResponse<bool>> deleteMultiple(List<int> ids) async {
    try {
      final res = await client.post(
        urlBuilder(api: deleteApi),
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
      return DataResponse.error(systemError: e, systemtraceError: st);
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
      return DataResponse.error(systemError: e, systemtraceError: st);
    }
  }
}
