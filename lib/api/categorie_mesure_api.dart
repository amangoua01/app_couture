import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/categorie_mesure.dart';

class CategorieMesureApi extends CrudWebController<CategorieMesure> {
  @override
  CategorieMesure get item => CategorieMesure();

  @override
  String get module => "categorieMesure";
}
