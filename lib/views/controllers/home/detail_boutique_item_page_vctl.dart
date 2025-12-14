import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/models/detail_model_filter_vente.dart';
import 'package:ateliya/tools/models/detail_modele_entre_stock.dart';
import 'package:get/get.dart';

class DetailBoutiqueItemPageVctl extends GetxController {
  final ModeleBoutique modele;
  final filterVente = DetailModelFilterVente();
  final entreStockFilter = DetailModeleEntreStock();

  DetailBoutiqueItemPageVctl(this.modele);
}
