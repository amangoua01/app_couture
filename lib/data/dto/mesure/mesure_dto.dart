import 'dart:convert';

import 'package:ateliya/data/dto/abstract/multi_part_dto_model.dart';
import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/dto/upload_file_dto.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:flutter/services.dart';

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
    return {
      "clientId": client!.id.toString(),
      "succursaleId": succursale!.id.toString(),
      "montantTotal": montantTotal.toString(),
      "avance": avance.toString(),
      "remise": remiseGlobale.toString(),
      "resteArgent": resteArgent.toString(),
      "dateRetrait": dateRetrait.toString(),
      "lignesMesures": jsonEncode(
        lignesMesures.map((e) => e.toJson()).toList(),
      ),
    };
  }

  @override
  List<UploadFileDto> getFiles() => [];

  bool get isMensurationValide =>
      lignesMesures.every((e) => e.typeMesureDto!.isMensurationValide);

  bool get isValide {
    return lignesMesures.isNotEmpty &&
        lignesMesures
            .where((e) => e.typeMesureDto!.mensurations.any((e) => e.isActive))
            .isNotEmpty;
  }

  double get montantTotal => 0;
  double get resteArgent => 0;
}
