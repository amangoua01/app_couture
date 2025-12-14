import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/categorie_mesure.dart';

class CategorieMesureApi extends CrudWebController<CategorieMesure> {
  @override
  CategorieMesure get item => CategorieMesure();

  @override
  String get module => "categorieMesure";
}
