import 'dart:convert';
import 'dart:typed_data';

import 'package:ateliya/data/dto/mesure/mesure_dto.dart';
import 'package:ateliya/data/dto/upload_file_dto.dart';
import 'package:ateliya/data/models/abstract/model_form_data.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/ligne_mesure.dart';
import 'package:ateliya/data/models/mensuration.dart';
import 'package:ateliya/data/models/paiement_facture.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:http/http.dart' as http;

class Mesure extends ModelFormData<Mesure> {
  DateTime? dateRetrait;
  DateTime? dateDepot;
  Client? client;
  List<LigneMesure> lignesMesures = [];
  Succursale? succursale;
  double avance = 0;
  double remiseGlobale = 0;
  Uint8List? signature;
  FichierServer? signatureUrl;
  List<UploadFileDto> files = const [];
  List<PaiementFacture> paiementFactures = [];

  double? _montantTotal;
  double? _resteArgent;

  double get montantTotal =>
      _montantTotal ?? lignesMesures.fold(0, (a, b) => a + b.total);
  double get resteArgent =>
      _resteArgent ?? (montantTotal - avance - remiseGlobale);

  bool isActive = true;
  DateTime? createdAt;
  String? etatFacture;

  Mesure({
    this.dateRetrait,
    this.dateDepot,
    this.client,
    this.lignesMesures = const [],
    this.succursale,
    this.avance = 0,
    this.remiseGlobale = 0,
    this.signature,
    this.signatureUrl,
    this.files = const [],
    this.paiementFactures = const [],
    this.createdAt,
    this.isActive = true,
    this.etatFacture,
  });

  Mesure.fromJson(Json json) {
    id = json['id'];
    dateRetrait = json['dateRetrait'].toString().toDateTime();
    dateDepot = json['dateDepot'].toString().toDateTime();
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
    succursale = json['succursale'] != null
        ? Succursale.fromJson(json['succursale'])
        : null;
    avance = json['avance'].toString().toDouble().value;
    remiseGlobale =
        (json['remise'] ?? json['remiseGlobale']).toString().toDouble().value;
    _montantTotal = (json['MontantTotal'] ?? json['montantTotal'])
        .toString()
        .toDouble()
        .value;
    _resteArgent = (json['ResteArgent'] ?? json['resteArgent'])
        .toString()
        .toDouble()
        .value;

    if (json['signature'] is Map) {
      signatureUrl = FichierServer.fromJson(json['signature']);
    } else {
      signature = json['signature'];
    }

    if (json['mesures'] != null) {
      lignesMesures = (json['mesures'] as List)
          .map((e) => LigneMesure.fromJson(e))
          .toList();
    }
    if (json['paiementFactures'] != null) {
      paiementFactures = (json['paiementFactures'] as List)
          .map((e) => PaiementFacture.fromJson(e))
          .toList();
    }
    createdAt = json['createdAt'].toString().toDateTime();
    isActive = json['isActive'] ?? true;
    etatFacture = json['etatFacture'];
  }

  @override
  Mesure fromJson(Json json) => Mesure.fromJson(json);

  static Mesure fromDto(MesureDto dto) {
    return Mesure(
      dateRetrait: dto.dateRetrait,
      client: dto.client,
      lignesMesures: dto.lignesMesures
          .map(
            (e) => LigneMesure(
              nom: e.nomClient,
              montant: e.montant,
              remise: e.remise,
              typeMesure: e.typeMesureDto?.toModel(),
              mensurations: e.typeMesureDto?.mensurations
                      .map((m) => Mensuration(
                            taille: m.valeur,
                            categorieMesure: m.categorieMesure,
                          ))
                      .toList() ??
                  [],
              photoModele: e.modeleImagePath != null
                  ? FichierLocal(path: e.modeleImagePath!)
                  : null,
              photoPagne: e.pagneImagePath != null
                  ? FichierLocal(path: e.pagneImagePath!)
                  : null,
            ),
          )
          .toList(),
      succursale: dto.succursale,
      avance: dto.avance,
      remiseGlobale: dto.remiseGlobale,
      signature: dto.signature,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "dateRetrait": dateRetrait?.toIso8601String(),
      "dateDepot": dateDepot?.toIso8601String(),
      "client": client?.toJson(),
      "succursale": succursale?.toJson(),
      "avance": avance,
      "remiseGlobale": remiseGlobale,
      "remise": remiseGlobale,
      "montantTotal": montantTotal,
      "MontantTotal": montantTotal,
      "resteArgent": resteArgent,
      "ResteArgent": resteArgent,
      "signature": signature,
      "mesures": lignesMesures.map((e) => e.toJson()).toList(),
      "createdAt": createdAt?.toIso8601String(),
      "isActive": isActive,
      "paiementFactures": paiementFactures.map((e) => e.toJson()).toList(),
      "etatFacture": etatFacture,
    };
  }

  @override
  Map<String, String> toFields() {
    final mesuresJson = lignesMesures
        .map((m) => {
              "typeMesureId": m.typeMesure?.id,
              "nom": m.nom,
              "montant": m.montant,
              "remise": m.remise,
              "ligneMesures": m.mensurations
                  .map((l) => {
                        "categorieId": l.categorieMesure?.id,
                        "taille": l.taille,
                      })
                  .toList(),
            })
        .toList();

    return {
      "clientId": client?.id?.toString() ?? "",
      "succursaleId": succursale?.id?.toString() ?? "",
      "montantTotal": montantTotal.toString(),
      "avance": avance.toString(),
      "remise": remiseGlobale.toString(),
      "resteArgent": resteArgent.toString(),
      "dateRetrait": dateRetrait?.toIso8601String() ?? "",
      "mesures": jsonEncode(mesuresJson),
    };
  }

  @override
  Future<List<http.MultipartFile>> toMultipartFile() async {
    List<http.MultipartFile> files = [];

    if (signature != null) {
      files.add(http.MultipartFile.fromBytes(
        'signature',
        signature!,
        filename: 'signature.png',
      ));
    }

    for (int i = 0; i < lignesMesures.length; i++) {
      final item = lignesMesures[i];
      if (item.photoPagne is FichierLocal) {
        final path = (item.photoPagne as FichierLocal).path;
        if (path.isNotEmpty) {
          files.add(await http.MultipartFile.fromPath(
            'mesures[$i][photoPagne]',
            path,
          ));
        }
      }

      if (item.photoModele is FichierLocal) {
        final path = (item.photoModele as FichierLocal).path;
        if (path.isNotEmpty) {
          files.add(await http.MultipartFile.fromPath(
            'mesures[$i][photoModele]',
            path,
          ));
        }
      }
    }

    return files;
  }
}
