import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/charge.dart';
import 'package:ateliya/tools/components/data_cache.dart';
import 'package:ateliya/tools/models/data_response.dart';

class ChargeApi extends WebController {
  @override
  String get module => "charge";

  static const _cacheKey = "charges:mine";

  /// Dernières charges connues, affichées avant la réponse réseau.
  Future<List<Charge>?> readCachedList() async {
    final raw = await DataCache.readList(_cacheKey);
    if (raw == null) return null;
    try {
      return raw.map((e) => Charge.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<DataResponse<List<Charge>>> list() async {
    try {
      final res = await client.get(urlBuilder(api: "/"), headers: authHeaders);
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (data is Map && data.containsKey("data")) data = data["data"];
        await DataCache.write(_cacheKey, data);
        return DataResponse.success(
          data: (data as List).map((e) => Charge.fromJson(e)).toList(),
        );
      } else {
        return DataResponse.error(message: data["message"] ?? res.reasonPhrase);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<Charge>> create(Charge charge) async {
    try {
      final res = await client.post(
        urlBuilder(api: "create"),
        body: jsonEncode(charge.toJson()),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await DataCache.invalidate(_cacheKey);
        return DataResponse.success(data: charge.fromJson(data["data"]));
      } else {
        return DataResponse.error(message: data["message"] ?? res.reasonPhrase);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<Charge>> update(Charge charge) async {
    try {
      final res = await client.put(
        urlBuilder(api: "update/${charge.id}"),
        body: jsonEncode(charge.toJson()),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await DataCache.invalidate(_cacheKey);
        return DataResponse.success(data: charge.fromJson(data["data"]));
      } else {
        return DataResponse.error(message: data["message"] ?? res.reasonPhrase);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<bool>> delete(int id) async {
    try {
      final res = await client.delete(
        urlBuilder(api: "delete/$id"),
        headers: authHeaders,
      );
      if (res.statusCode == 200) {
        await DataCache.invalidate(_cacheKey);
        return DataResponse.success(data: true);
      } else {
        final data = jsonDecode(res.body);
        return DataResponse.error(message: data["message"] ?? res.reasonPhrase);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
