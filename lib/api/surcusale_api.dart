import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/surcusale.dart';

class SurcusaleApi extends CrudWebController<Surcusale> {
  @override
  Surcusale get item => Surcusale();

  @override
  String get module => "surcusale";
}
