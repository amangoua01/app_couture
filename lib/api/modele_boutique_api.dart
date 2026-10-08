import 'dart:convert';

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/dto/mouvement_stock_dto.dart';
import 'package:ateliya/data/dto/transfert_stock_dto.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/modele_boutique_details.dart';
import 'package:ateliya/data/models/ravitaillement_stock.dart';
import 'package:ateliya/tools/components/data_cache.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/models/data_response.dart';

class ModeleBoutiqueApi extends CrudWebController<ModeleBoutique> {
  ModeleBoutiqueApi() : super(listApi: "/entreprise");

  String _stockCacheKey(int boutiqueId) => "ravitaillement:$boutiqueId";

  /// Dernière page de ravitaillements connue pour cette boutique.
  Future<List<RavitaillementStock>?> readCachedStock(int boutiqueId) async {
    final raw = await DataCache.readList(_stockCacheKey(boutiqueId));
    if (raw == null) return null;
    try {
      return raw.map((e) => RavitaillementStock.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

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
    String? dateDebut,
    String? dateFin,
  }) async {
    try {
      final res = await client.get(
        urlBuilder(
          api: "boutique/$boutiqueId",
          module: "stock",
          params: {
            "page": page.toString(),
            "limit": limit.toString(),
            if (dateDebut != null) "dateDebut": dateDebut,
            if (dateFin != null) "dateFin": dateFin,
          },
        ),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final rawList = data['data'] as List? ?? [];
        if (page == 1) {
          await DataCache.write(_stockCacheKey(boutiqueId), rawList);
        }
        final list =
            rawList.map((e) => RavitaillementStock.fromJson(e)).toList();
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
  Future<DataResponse<bool>> entreeStock(
    MouvementStockDto mouvementStockDto,
  ) async {
    try {
      final res = await client.post(
        urlBuilder(api: 'entree', module: 'stock'),
        headers: authHeaders,
        body: mouvementStockDto.toJson().parseToJson(),
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
        // La route n'indique pas la boutique concernée : on invalide tout
        // le cache de ravitaillements plutôt que de risquer un statut figé.
        await DataCache.invalidate("ravitaillement:");
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
        await DataCache.invalidate("ravitaillement:");
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

  /// Transfère un stock d'une boutique vers une autre.
  ///
  /// POST /stock/transfert
  Future<DataResponse<bool>> transfertStock(
    TransfertStockDto transfertStockDto,
  ) async {
    try {
      final res = await client.post(
        urlBuilder(api: 'transfert', module: 'stock'),
        headers: authHeaders,
        body: transfertStockDto.toJson().parseToJson(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return DataResponse.success(data: true);
      } else {
        return DataResponse.error(
          message: data['message'] ?? "Erreur lors du transfert de stock",
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Enregistre une sortie de stock directe.
  ///
  /// POST /stock/sortie-directe
  Future<DataResponse<bool>> sortieDirecte(
    MouvementStockDto mouvementStockDto,
  ) async {
    try {
      final res = await client.post(
        urlBuilder(api: 'sortie-directe', module: 'stock'),
        headers: authHeaders,
        body: mouvementStockDto.toJson().parseToJson(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return DataResponse.success(data: true);
      } else {
        return DataResponse.error(
          message: data['message'] ?? "Erreur lors de la sortie de stock",
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<ModeleBoutique>> getModeleBoutiqueByBarcode(
    String barcode,
  ) async {
    try {
      final res = await client.get(
        urlBuilder(api: 'codebar/$barcode'),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: ModeleBoutique.fromJson(data['data']),
        );
      } else {
        return DataResponse.error(
          message:
              data['message'] ?? 'Erreur lors de la récupération de l\'article',
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
