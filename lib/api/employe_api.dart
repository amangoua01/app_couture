import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/employe.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'dart:convert';

class EmployeApi extends CrudWebController<Employe> {
  @override
  Employe get item => Employe();

  @override
  String get module => "employe";

  Future<DataResponse<List<dynamic>>> getBilanPaie({
    String? debut,
    String? fin,
    int? succursaleId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (debut != null) queryParams['debut'] = debut;
      if (fin != null) queryParams['fin'] = fin;
      if (succursaleId != null) queryParams['succursaleId'] = succursaleId.toString();

      final uri = urlBuilder(api: "bilan").replace(queryParameters: queryParams);

      final response = await client.get(
        uri,
        headers: authHeaders,
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DataResponse.success(data: json["data"] ?? []);
      } else {
        return DataResponse.error(
          message: json["message"] ?? "Erreur lors de la récupération du bilan",
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Paiement en un tap du solde dû : réutilise (ou crée) la charge de
  /// l'employé puis crée la dépense liée — voir PayerEmployeUseCase côté
  /// backend.
  Future<DataResponse<void>> payer(
    int employeId,
    double montant, {
    int? caisseId,
    String? debut,
    String? fin,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (debut != null) queryParams['debut'] = debut;
      if (fin != null) queryParams['fin'] = fin;

      final uri = urlBuilder(
        api: "$employeId/payer",
      ).replace(queryParameters: queryParams);

      final res = await client.post(
        uri,
        body: jsonEncode({
          'montant': montant,
          if (caisseId != null) 'caisseId': caisseId,
        }),
        headers: authHeaders,
      );
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: null);
      } else {
        return DataResponse.error(
          message: json['message'] ?? "Erreur lors du paiement",
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
