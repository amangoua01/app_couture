import 'package:get/get.dart';

class EditionMesurePageVctl extends GetxController {
  int page = 0;
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
