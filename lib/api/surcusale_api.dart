import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/succursale.dart';

class SuccursaleApi extends CrudWebController<Succursale> {
  @override
  Succursale get item => Succursale();

  @override
  String get module => "succursale";
}
