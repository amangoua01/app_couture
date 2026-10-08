import 'dart:convert';

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/pointage.dart';
import 'package:ateliya/tools/models/data_response.dart';

class PointageApi extends CrudWebController<Pointage> {
  @override
  Pointage get item => Pointage();

  @override
  String get module => "pointage";

  /// Fiches du jour (ou d'un employé précis) — route dédiée côté backend,
  /// différente de la liste paginée générique (`GET pointage?date=...`).
  Future<DataResponse<List<Pointage>>> listForDate(
    String date, {
    int? employeId,
  }) async {
    try {
      final queryParams = <String, String>{'date': date};
      if (employeId != null) queryParams['employeId'] = employeId.toString();

      final uri = urlBuilder(api: "").replace(queryParameters: queryParams);

      final res = await client.get(uri, headers: authHeaders);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (json['data'] as List? ?? [])
            .map((e) => Pointage.fromJson(e))
            .toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(message: json['message'] ?? "Erreur");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Historique sur une période (ex: les pointages passés d'un employé) —
  /// même route que [listForDate], avec `debut`/`fin` au lieu de `date`.
  Future<DataResponse<List<Pointage>>> listForPeriod(
    String debut,
    String fin, {
    int? employeId,
  }) async {
    try {
      final queryParams = <String, String>{'debut': debut, 'fin': fin};
      if (employeId != null) queryParams['employeId'] = employeId.toString();

      final uri = urlBuilder(api: "").replace(queryParameters: queryParams);

      final res = await client.get(uri, headers: authHeaders);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (json['data'] as List? ?? [])
            .map((e) => Pointage.fromJson(e))
            .toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(message: json['message'] ?? "Erreur");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Crée ou complète la fiche du jour d'un employé (une seule route pour
  /// les deux cas côté backend : `POST pointage/save`).
  Future<DataResponse<Pointage>> save(Pointage pointage) async {
    try {
      final res = await client.post(
        urlBuilder(api: "save"),
        body: jsonEncode(pointage.toJson()),
        headers: authHeaders,
      );
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: Pointage.fromJson(json['data']));
      } else {
        return DataResponse.error(message: json['message'] ?? "Erreur");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
