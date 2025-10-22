import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/modele.dart';

class ModeleApi extends CrudWebController<Modele> {
  @override
  Modele get item => Modele();

  @override
  String get module => "modele";
}
