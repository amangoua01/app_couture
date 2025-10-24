import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/surcusale.dart';

class SurcursaleApi extends CrudWebController<Surcursale> {
  @override
  Surcursale get item => Surcursale();

  @override
  String get module => "surccursale";
}
