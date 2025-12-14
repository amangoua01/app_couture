import 'package:ateliya/api/categorie_mesure_api.dart';
import 'package:ateliya/data/models/categorie_mesure.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class CategorieListPageVctl extends ListViewController<CategorieMesure> {
  CategorieListPageVctl() : super(CategorieMesureApi());
}
