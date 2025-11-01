import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/categorie_type_mesure.dart';

class CategorieTypeMesureApi extends CrudWebController<CategorieTypeMesure> {
  @override
  CategorieTypeMesure get item => CategorieTypeMesure();

  @override
  String get module => "categorieTypeMesure";
}
