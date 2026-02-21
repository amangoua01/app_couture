import 'dart:convert';

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/modele_boutique_details.dart';
import 'package:ateliya/data/models/ravitaillement_stock.dart';
import 'package:ateliya/tools/models/data_response.dart';

class ModeleBoutiqueApi extends CrudWebController<ModeleBoutique> {
  ModeleBoutiqueApi() : super(listApi: "/entreprise");

  @override
  ModeleBoutique get item => ModeleBoutique();

  @override
  String get module => "modeleBoutique";

  Future<DataResponse<ModeleBoutiqueDetails>> getDetails(int modeleId) async {
    try {
      final res = await client.get(
        urlBuilder(api: 'details/$modeleId'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: ModeleBoutiqueDetails.fromJson(data['data']),
        );
      } else {
        return DataResponse.error(
          message:
              data['message'] ?? 'Erreur lors de la récupération des détails',
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Récupère la liste des ravitaillements (entrées de stock) pour une boutique.
  ///
  /// [boutiqueId] : ID de la boutique.
  /// [page] : numéro de page (défaut : 1).
  /// [limit] : nombre d'items par page (défaut : 20).
  Future<DataResponse<List<RavitaillementStock>>> getListStock({
    required int boutiqueId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final res = await client.get(
        urlBuilder(
          api: '$boutiqueId',
          module: 'stock',
          params: {
            'page': page.toString(),
            'limit': limit.toString(),
          },
        ),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (data['data'] as List? ?? [])
            .map((e) => RavitaillementStock.fromJson(e))
            .toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(
          message: data['message'] ?? 'Erreur lors du chargement des stocks',
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Enregistre une entrée de stock (ravitaillement).
  ///
  /// [boutiqueId] : ID de la boutique concernée.
  /// [lignes] : liste de { 'modeleBoutiqueId': int, 'quantite': int }.
  Future<DataResponse<bool>> entreeStock({
    required int boutiqueId,
    required List<Map<String, int>> lignes,
  }) async {
    try {
      final res = await client.post(
        urlBuilder(api: 'entree', module: 'stock'),
        headers: authHeaders,
        body: jsonEncode({
          'boutiqueId': boutiqueId,
          'lignes': lignes,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return DataResponse.success(data: true);
      } else {
        return DataResponse.error(
          message: data['message'] ?? "Erreur lors de l'entrée de stock",
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Confirme un ravitaillement (entrée de stock).
  ///
  /// PUT /stock/confirmer/{id}
  /// Body : { "commentaire": "..." }
  Future<DataResponse<bool>> confirmerStock(
    int stockId, {
    String? commentaire,
  }) async {
    try {
      final res = await client.put(
        urlBuilder(api: 'confirmer/$stockId', module: 'stock'),
        headers: authHeaders,
        body: jsonEncode({'commentaire': commentaire ?? ''}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: true);
      } else {
        return DataResponse.error(
          message: data['message'] ?? 'Erreur lors de la confirmation',
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Rejette un ravitaillement (entrée de stock).
  ///
  /// PUT /stock/rejeter/{id}
  /// Body : { "commentaire": "..." }
  Future<DataResponse<bool>> rejeterStock(
    int stockId, {
    String? commentaire,
  }) async {
    try {
      final res = await client.put(
        urlBuilder(api: 'rejeter/$stockId', module: 'stock'),
        headers: authHeaders,
        body: jsonEncode({'commentaire': commentaire ?? ''}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: true);
      } else {
        return DataResponse.error(
          message: data['message'] ?? 'Erreur lors du rejet',
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
