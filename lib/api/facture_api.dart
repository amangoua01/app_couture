import 'dart:convert';

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/facture.dart';
import 'package:ateliya/data/models/factures_grouped.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/data/models/transaction_response.dart';
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

  Future<DataResponse<FacturesGrouped>> getFacturesEntreprise(
    int succursaleId, {
    String? dateDebut,
    String? dateFin,
    String? nomClient,
    String? numeroClient,
    String? etatFacture,
  }) async {
    try {
      final body = {};
      if (dateDebut != null) body['dateDebut'] = dateDebut;
      if (dateFin != null) body['dateFin'] = dateFin;
      if (nomClient != null && nomClient.isNotEmpty) {
        body['nomClient'] = nomClient;
      }
      if (numeroClient != null && numeroClient.isNotEmpty) {
        body['numeroClient'] = numeroClient;
      }
      if (etatFacture != null) body['etatFacture'] = etatFacture;

      final response = await client.post(
        urlBuilder(api: "advanced/$succursaleId"),
        headers: authHeaders,
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return DataResponse.success(
            data: FacturesGrouped.fromJson(json['data'] ?? {}));
      } else {
        return DataResponse.error(message: json['message'] ?? "Erreur");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<TransactionResponse>> getTransactions({
    required int entityId,
    required String type,
    String? date,
    String? month,
    String? dateDebut,
    String? dateFin,
  }) async {
    try {
      final Map<String, dynamic> query = {};
      if (date != null) query['date'] = date;
      if (month != null) query['month'] = month;
      if (dateDebut != null) query['date_debut'] = dateDebut;
      if (dateFin != null) query['date_fin'] = dateFin;

      final url = urlBuilder(
        api: "transactions/$entityId/$type",
        module: "paiement",
      ).replace(queryParameters: query);

      final response = await client.get(url, headers: authHeaders);

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return DataResponse.success(data: TransactionResponse.fromJson(json));
      } else {
        return DataResponse.error(
            message: json['message'] ??
                "Erreur lors de la récupération des transactions");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
