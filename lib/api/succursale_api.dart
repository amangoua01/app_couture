import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/succursale.dart';

class SuccursaleApi extends CrudWebController<Succursale> {
  @override
  Succursale get item => Succursale();

  SuccursaleApi() : super(listApi: "entreprise");

  @override
  String get module => "succursale";
}
