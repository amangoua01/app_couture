import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/dto/mesure/mesure_dto.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/models/data_response.dart';

class MesureApi extends WebController {
  @override
  String get module => "facture";

  Future<DataResponse<Mesure>> create(MesureDto dto) async {
    try {
      final res = await client.multiPart(
        urlBuilder(api: "create"),
        headers: authHeaders,
        body: dto.toJson(),
        files: await dto.getFiles(),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: Mesure.fromJson(data["data"]));
      } else {
        return DataResponse.error(
            message: data["message"] ?? res.reasonPhrase ?? "Erreur inconnu");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<Mesure>> changeEtatmesure(
      int ligneMesureId, String etat) async {
    try {
      final res = await client.post(
        urlBuilder(api: "etat/$ligneMesureId", module: "mesure"),
        headers: authHeaders,
        body: jsonEncode({"etat": etat}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: Mesure.fromJson(data["data"]));
      } else {
        return DataResponse.error(
            message: data["message"] ?? res.reasonPhrase ?? "Erreur inconnu");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<Mesure>> changeEtatFacture(int id, String etat) async {
    try {
      final res = await client.post(
        urlBuilder(api: "facture/etat/$id", module: "mesure"),
        headers: authHeaders,
        body: jsonEncode({"etatFacture": etat}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: Mesure.fromJson(data["data"]));
      } else {
        return DataResponse.error(
            message: data["message"] ?? res.reasonPhrase ?? "Erreur inconnu");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
