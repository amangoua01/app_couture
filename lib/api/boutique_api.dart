import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/dto/paiement_boutique_dto.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/paiement_boutique.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:http/http.dart' as http;

class BoutiqueApi extends CrudWebController<Boutique> {
  BoutiqueApi() : super(listApi: "entreprise");
  @override
  Boutique get item => Boutique();

  @override
  String get module => "boutique";

  @override
  Future<DataResponse<Boutique>> create(Boutique item) async {
    try {
      final http.Response res;
      if (item.logo is FichierLocal) {
        // Upload avec fichier
        final files = <http.MultipartFile>[];
        files.add(
          await http.MultipartFile.fromPath(
            'logo',
            (item.logo as FichierLocal).path,
          ),
        );
        res = await client.multiPart(
          urlBuilder(api: createApi),
          body: {
            'libelle': item.libelle.value,
            'contact': item.contact.value,
            'situation': item.situation.value,
          },
          files: files,
          headers: authHeaders,
        );
      } else {
        // Upload sans fichier (JSON)
        res = await client.post(
          urlBuilder(api: createApi),
          body: jsonEncode(item.toJson()),
          headers: authHeaders,
        );
      }
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: item.fromJson(data["data"]));
      } else {
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase.value,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  @override
  Future<DataResponse<Boutique>> update(Boutique item) async {
    try {
      final http.Response res;
      if (item.logo is FichierLocal) {
        // Upload avec fichier
        final files = <http.MultipartFile>[];
        files.add(
          await http.MultipartFile.fromPath(
            'logo',
            (item.logo as FichierLocal).path,
          ),
        );
        res = await client.multiPart(
          urlBuilder(api: "$updateApi/${item.id.value}"),
          body: {
            'libelle': item.libelle.value,
            'contact': item.contact.value,
            'situation': item.situation.value,
          },
          files: files,
          headers: authHeaders,
        );
      } else {
        // Upload sans fichier (JSON)
        res = await client.put(
          urlBuilder(api: "$updateApi/${item.id.value}"),
          body: jsonEncode(item.toJson()),
          headers: authHeaders,
        );
      }
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(data: item.fromJson(data["data"]));
      } else {
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase.value,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  // https://backend.ateliya.com/api/modeleBoutique/modele/by/boutique/1

  Future<DataResponse<List<ModeleBoutique>>> getModeleBoutiqueByBoutiqueId(
      int id) async {
    try {
      final res = await client.get(
        urlBuilder(api: "/modele/by/boutique/$id", module: "modeleBoutique"),
        headers: authHeaders,
      );
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
            data: (data["data"] as List).map((e) {
          return ModeleBoutique.fromJson(e);
        }).toList());
      } else {
        return DataResponse.error(
          message: data["message"] ?? res.reasonPhrase.value,
        );
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<PaiementBoutique>> makePaiement(
      PaiementBoutiqueDto data) async {
    try {
      final res = await client.post(
        urlBuilder(
          module: "paiement",
          api: "boutique/multiple/${data.boutiqueId}",
        ),
        headers: authHeaders,
        body: data.toJson().parseToJson(),
      );
      var resData = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DataResponse.success(
          data: PaiementBoutique.fromJson(resData["data"]),
        );
      } else {
        return DataResponse.error(message: resData["message"]);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<List<PaiementBoutique>>> getVentes(
      int id, Map<String, dynamic> data) async {
    try {
      final res = await client.post(
        urlBuilder(api: "boutique/$id", module: "vente"),
        headers: authHeaders,
        body: data.parseToJson(),
      );
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = (json['data']['data'] as List)
            .map((e) => PaiementBoutique.fromJson(e))
            .toList();
        return DataResponse.success(data: list);
      } else {
        return DataResponse.error(message: json['message']);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
