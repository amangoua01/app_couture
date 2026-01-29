import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/mesure.dart';

class MesureApi extends CrudWebController<Mesure> {
  @override
  String get module => "factures";

  @override
  Mesure get item => Mesure();
}
