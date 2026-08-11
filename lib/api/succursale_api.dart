import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/atelier.dart';

class SuccursaleApi extends CrudWebController<Atelier> {
  @override
  Atelier get item => Atelier();

  SuccursaleApi() : super(listApi: "entreprise");

  @override
  String get module => "succursale";
}
