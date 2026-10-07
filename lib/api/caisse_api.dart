import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/dto/mouvement_caisse_dto.dart';
import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/data/models/mouvement_caisse.dart';
import 'package:ateliya/tools/components/data_cache.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:ateliya/tools/models/paginated_data.dart';

class CaisseApi extends WebController {
  @override
  String get module => "caisses";

  String _mouvementsCacheKey(
    int boutiqueId,
    String? dateDebut,
    String? dateFin,
  ) => "mouvements:$boutiqueId:${dateDebut ?? ''}:${dateFin ?? ''}";

  /// Dernière page de mouvements connue pour cette boutique et cette
  /// période, affichée le temps que le réseau réponde.
  Future<PaginatedData<MouvementCaisse>?> readCachedMouvements({
    required int boutiqueId,
    String? dateDebut,
    String? dateFin,
  }) async {
    final raw = await DataCache.readList(
      _mouvementsCacheKey(boutiqueId, dateDebut, dateFin),
    );
    if (raw == null) return null;
    try {
      return PaginatedData<MouvementCaisse>(
        items: raw.map((e) => MouvementCaisse.fromJson(e)).toList(),
        page: 1,
      );
    } catch (_) {
      return null;
    }
  }

  Future<DataResponse<PaginatedData<Caisse>>> list({int page = 1}) async {
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
        return DataResponse.error(message: data["message"] ?? res.reasonPhrase);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<PaginatedData<MouvementCaisse>>> listMouvements({
    required int boutiqueId,
    String? dateDebut,
    String? dateFin,
    int page = 1,
    bool withPagination = true,
  }) async {
    try {
      final res = await client.get(
        urlBuilder(
          module: "mouvement-caisse",
          api: "boutique/$boutiqueId/mouvements",
          params: {
            if (dateDebut != null) "date_debut": dateDebut,
            if (dateFin != null) "date_fin": dateFin,
            "with_pagination": withPagination.toString(),
            "page": page.toString(),
          },
        ),
        headers: authHeaders,
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (data is Map && data.containsKey("data")) {
          data = data["data"];
        }
        final items =
            (data as List? ?? [])
                .map((e) => MouvementCaisse.fromJson(e))
                .toList();
        if (page == 1) {
          await DataCache.write(
            _mouvementsCacheKey(boutiqueId, dateDebut, dateFin),
            data,
          );
        }
        return DataResponse.success(
          data: PaginatedData<MouvementCaisse>(items: items, page: page),
        );
      } else {
        return DataResponse.error(message: data["message"] ?? res.reasonPhrase);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse> addMouvement(MouvementCaisseDto data) async {
    try {
      final res = await client.post(
        urlBuilder(module: "mouvement-caisse", api: "create"),
        body: jsonEncode(data.toJson()),
        headers: authHeaders,
      );
      final json = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return DataResponse.success(data: json);
      } else {
        return DataResponse.error(message: json["message"] ?? res.reasonPhrase);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
