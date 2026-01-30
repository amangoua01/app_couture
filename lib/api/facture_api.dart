import 'dart:convert';

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/facture.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:intl/intl.dart';

class FactureApi extends CrudWebController<Facture> {
  @override
  Facture get item => Facture();

  @override
  String get module => "facture";

  Future<DataResponse<Mesure>> ajouterPaiement(
      int mesureId, double montant, String reference, int succursaleId) async {
    try {
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await client.post(
        urlBuilder(api: "facture/$mesureId", module: "paiement"),
        headers: authHeaders,
        body: {
          "montant": montant,
          "datePaiment": date,
          "succursaleId": succursaleId,
          "moyenPaiment": reference,
        }.parseToJson(),
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DataResponse.success(data: Mesure.fromJson(json["data"]));
      } else {
        return DataResponse.error(
            message: json["message"] ?? "Erreur lors du paiement");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<List<Mesure>>> getFacturesEntreprise() async {
    try {
      final response = await client.get(
        urlBuilder(api: "entreprise"),
        headers: authHeaders,
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final list =
            (json['data'] as List).map((e) => Mesure.fromJson(e)).toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(message: json['message'] ?? "Erreur");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
