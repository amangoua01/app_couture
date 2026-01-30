import 'dart:convert';

import 'package:ateliya/data/dto/abstract/multi_part_dto_model.dart';
import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' hide Client;

class MesureDto extends MultiPartDtoModel {
  DateTime? dateRetrait;
  Client? client;
  List<LigneMesureDto> lignesMesures;
  Succursale? succursale;
  double avance = 0;
  double remiseGlobale = 0;
  Uint8List? signature;

  MesureDto({
    this.dateRetrait,
    this.client,
    List<LigneMesureDto>? lignesMesures,
  }) : lignesMesures = lignesMesures ?? [];

  @override
  Map<String, String> toJson() {
    final mesuresJson = lignesMesures
        .map((m) => {
              "typeMesureId": m.typeMesureDto?.id,
              "nom": m.nomClient,
              "montant": m.montant,
              "remise": m.remise,
              "ligneMesures": m.typeMesureDto?.mensurations
                  .map((l) => {
                        "categorieId": l.categorieMesure.id,
                        "taille": l.valeur,
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
      "resteArgent": resteArgent().toString(),
      "dateRetrait": dateRetrait?.toIso8601String() ?? "",
      "mesures": jsonEncode(mesuresJson),
    };
  }

  @override
  Future<List<MultipartFile>> getFiles() async {
    final files = <MultipartFile>[];
    if (signature != null) {
      files.add(MultipartFile.fromBytes(
        "signature",
        signature!,
        filename: "signature.png",
      ));
    }
    for (var i = 0; i < lignesMesures.length; i++) {
      final item = lignesMesures[i];
      if (item.pagneImagePath != null && item.pagneImagePath!.isNotEmpty) {
        files.add(await MultipartFile.fromPath(
          "mesures[$i][photoPagne]",
          item.pagneImagePath!,
        ));
      }
      if (item.modeleImagePath != null && item.modeleImagePath!.isNotEmpty) {
        files.add(await MultipartFile.fromPath(
          "mesures[$i][photoModele]",
          item.modeleImagePath!,
        ));
      }
    }
    return files;
  }

  bool get isMensurationValide =>
      lignesMesures.every((e) => e.typeMesureDto!.isMensurationValide);

  bool get isValide {
    return lignesMesures.isNotEmpty &&
        lignesMesures
            .where((e) => e.typeMesureDto!.mensurations.any((e) => e.isActive))
            .isNotEmpty;
  }

  double get montantTotal => lignesMesures.fold(0, (a, b) => a + b.total);

  double resteArgent([double? av, double? rem]) =>
      montantTotal - (av ?? avance) - (rem ?? remiseGlobale);
}
