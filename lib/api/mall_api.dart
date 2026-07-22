import 'dart:convert';
import 'dart:io';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:http/http.dart' as http;
import 'package:ateliya/data/models/mall_dashboard_stats.dart';
import 'package:ateliya/data/models/mall_favori.dart';
import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/data/models/mall_settings.dart';
import 'package:ateliya/data/models/mall_slide.dart';
import 'package:ateliya/data/models/mall_statut.dart';
import 'package:ateliya/data/models/user_adresse.dart';
import 'package:ateliya/tools/models/data_response.dart';

class MallApi extends WebController {
  @override
  String get module => 'mall';

  Future<DataResponse<List<MallRecentOrder>>> getUserCommandes(
      int userId) async {
    try {
      final res = await client.get(
        urlBuilder(api: 'user/$userId/commandes'),
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
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

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
      List<Map<String, dynamic>> items, {List<File?> images = const []}) async {
    try {
      final files = <http.MultipartFile>[];
      for (int i = 0; i < images.length; i++) {
        final img = images[i];
        if (img != null) {
          files.add(await http.MultipartFile.fromPath('images[$i]', img.path));
        }
      }
      final res = await client.multiPart(
        urlBuilder(api: 'promotions-nouveautes'),
        body: {'items': jsonEncode(items)},
        files: files,
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<List<MallModeleBoutique>>> getPromotions(
      String entrepriseId) async {
    try {
      final res = await client.get(
        urlBuilder(api: 'promotions', params: {'entrepriseId': entrepriseId}),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (data['data'] as List)
            .map((e) => MallModeleBoutique.fromJson(e))
            .toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<List<MallModeleBoutique>>> getNouveautes(
      String entrepriseId) async {
    try {
      final res = await client.get(
        urlBuilder(api: 'nouveautes', params: {'entrepriseId': entrepriseId}),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (data['data'] as List)
            .map((e) => MallModeleBoutique.fromJson(e))
            .toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<List<MallModeleBoutique>>> getMyModeles() async {
    try {
      final res = await client.get(
        urlBuilder(api: 'my-modeles'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (data['data'] as List)
            .map((e) => MallModeleBoutique.fromJson(e))
            .toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> updateModeleVisibility(int id) async {
    try {
      final res = await client.put(
        urlBuilder(api: 'modeles/$id'),
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

  Future<DataResponse<void>> deleteModele(int id) async {
    try {
      final res = await client.delete(
        urlBuilder(api: 'modeles/$id'),
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

  Future<DataResponse<List<MallSlide>>> getSlides() async {
    try {
      final res = await client.get(
        urlBuilder(api: 'slides'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list =
            (data['data'] as List).map((e) => MallSlide.fromJson(e)).toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> createSlide(Map<String, dynamic> body,
      {File? image}) async {
    try {
      final http.Response res;
      if (image != null) {
        res = await client.multiPart(
          urlBuilder(api: 'slides'),
          body: body.map((k, v) => MapEntry(k, v?.toString() ?? '')),
          files: [await http.MultipartFile.fromPath('image', image.path)],
          headers: authHeaders,
        );
      } else {
        res = await client.post(
          urlBuilder(api: 'slides'),
          headers: authHeaders,
          body: jsonEncode(body),
        );
      }
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

  Future<DataResponse<void>> updateSlide(int id, Map<String, dynamic> body,
      {File? image}) async {
    try {
      final http.Response res;
      if (image != null) {
        res = await client.multiPart(
          urlBuilder(api: 'slides/$id'),
          body: body.map((k, v) => MapEntry(k, v?.toString() ?? '')),
          files: [await http.MultipartFile.fromPath('image', image.path)],
          headers: authHeaders,
        );
      } else {
        res = await client.post(
          urlBuilder(api: 'slides/$id'),
          headers: authHeaders,
          body: jsonEncode(body),
        );
      }
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

  Future<DataResponse<void>> deleteSlide(int id) async {
    try {
      final res = await client.delete(
        urlBuilder(api: 'slides/$id'),
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

  Future<DataResponse<List<MallStatut>>> getStatuts() async {
    try {
      final res = await client.get(
        urlBuilder(api: 'statuts'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list =
            (data['data'] as List).map((e) => MallStatut.fromJson(e)).toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<List<MallStatut>>> getStatutsEntreprise(
      int entrepriseId) async {
    try {
      final res = await client.get(
        urlBuilder(api: 'statuts/entreprise/$entrepriseId'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = <MallStatut>[];
        for (final group in (data['data'] as List)) {
          for (final s in (group['statuts'] as List)) {
            list.add(MallStatut.fromJson(s));
          }
        }
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> createStatut(
      int entrepriseId, String type, String? contenu,
      {File? fichier}) async {
    try {
      final res = await client.multiPart(
        urlBuilder(api: 'statuts'),
        body: {
          'entrepriseId': entrepriseId.toString(),
          'type': type,
          if (contenu != null && contenu.isNotEmpty) 'contenu': contenu,
        },
        files: fichier != null
            ? [await http.MultipartFile.fromPath('fichier', fichier.path)]
            : [],
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> deleteStatut(int id, int entrepriseId) async {
    try {
      final res = await client.delete(
        urlBuilder(api: 'statuts/$id/entreprise/$entrepriseId'),
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

  Future<DataResponse<void>> incrementStatutVues(int id) async {
    try {
      final res = await client.put(
        urlBuilder(api: 'statuts/$id/view'),
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

  Future<DataResponse<void>> invaliderCommande(int id) async {
    try {
      final res = await client.put(
        urlBuilder(api: 'commandes/$id/invalider'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
          message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue',
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<void>> validerCommande(int commandeId) async {
    try {
      final res = await client.post(
        urlBuilder(api: 'commandes/valider'),
        headers: authHeaders,
        body: jsonEncode({'id': commandeId}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
          message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue',
        );
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
