import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/mall_dashboard_stats.dart';
import 'package:ateliya/data/models/mall_favori.dart';
import 'package:ateliya/data/models/mall_settings.dart';
import 'package:ateliya/data/models/user_adresse.dart';
import 'package:ateliya/tools/models/data_response.dart';

class MallApi extends WebController {
  @override
  String get module => 'mall';

  Future<DataResponse<List<MallRecentOrder>>> getCommandesRecues() async {
    try {
      final res = await client.get(
        urlBuilder(api: 'commandes-recues'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (data['data'] as List)
            .map((e) => MallRecentOrder.fromJson(e))
            .toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(
          message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue',
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<List<MallFavori>>> getFavorisDetails(int userId) async {
    try {
      final res = await client.get(
        urlBuilder(api: 'user/$userId/favoris-details'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list =
            (data['data'] as List).map((e) => MallFavori.fromJson(e)).toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> toggleFavori(
      int modeleBoutiqueId, int userId) async {
    try {
      final res = await client.post(
        urlBuilder(api: 'favoris/toggle'),
        headers: authHeaders,
        body: jsonEncode(
            {'modeleBoutiqueId': modeleBoutiqueId, 'userId': userId}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<List<UserAdresse>>> getAdresses(int userId) async {
    try {
      final res = await client.get(
        urlBuilder(api: 'user/$userId/adresses'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list =
            (data['data'] as List).map((e) => UserAdresse.fromJson(e)).toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> addAdresse(
      int userId, Map<String, dynamic> body) async {
    try {
      final res = await client.post(
        urlBuilder(api: 'user/$userId/adresses'),
        headers: authHeaders,
        body: jsonEncode(body),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> updateAdresse(
      int id, Map<String, dynamic> body) async {
    try {
      final res = await client.put(
        urlBuilder(api: 'adresses/$id'),
        headers: authHeaders,
        body: jsonEncode(body),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> deleteAdresse(int id) async {
    try {
      final res = await client.delete(
        urlBuilder(api: 'adresses/$id'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<MallSettings>> getMallSettings() async {
    try {
      final res = await client.get(
        urlBuilder(api: 'settings/entreprise'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: MallSettings.fromJson(data['data']));
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> updateMallSettings(
      Map<String, dynamic> body) async {
    try {
      final res = await client.put(
        urlBuilder(api: 'settings/entreprise'),
        headers: authHeaders,
        body: jsonEncode(body),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> createPromotionsNouveautes(
      Map<String, dynamic> body) async {
    try {
      final res = await client.post(
        urlBuilder(api: 'promotions-nouveautes'),
        headers: authHeaders,
        body: jsonEncode(body),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<MallDashboardStats>> getDashboardStats() async {
    try {
      final res = await client.get(
        urlBuilder(api: 'dashboard-stats'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
            data: MallDashboardStats.fromJson(data['data']));
      } else {
        return DataResponse.error(
          message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue',
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
