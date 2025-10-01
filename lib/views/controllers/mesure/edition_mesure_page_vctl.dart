import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

class EditionMesurePageVctl extends GetxController {
  int page = 0;
  final signatureCtl = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    strokeCap: StrokeCap.round,
    exportBackgroundColor: Colors.blue,
  );
  List<Map<String, String>> pages = [
    {
      "title": "Faisons connaissance",
      "subtitle": "Informations personnelles",
    },
    {
      "title": "Donnez votre mesuration",
      "subtitle": "Informations sur vos mesures"
    },
    {
      "title": "INFORMATIONS GLOBALES",
      "subtitle": "Gestion finale",
    },
  ];
}
