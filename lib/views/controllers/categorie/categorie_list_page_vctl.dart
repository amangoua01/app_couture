import 'package:app_couture/api/categorie_mesure_api.dart';
import 'package:app_couture/data/models/categorie_mesure.dart';
import 'package:app_couture/views/controllers/abstract/list_view_controller.dart';

class CategorieListPageVctl extends ListViewController<CategorieMesure> {
  CategorieListPageVctl() : super(CategorieMesureApi());
}